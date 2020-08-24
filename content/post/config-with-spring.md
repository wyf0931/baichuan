---
title: 一个基于数据库的动态配置实现
author: Scott
tags:
  - spring
  - 架构设计
categories:
  - 技术
date: 2019-08-15 19:15:00
---
基于spring boot 实现一个简易的动态配置注入功能。

<!--more-->

### 基本思路

1. 在数据库中定义一个`config_item` 表，存放配置信息；
2. 通过 swagger-ui，实现一套简单的配置项维护界面；
3. 通过 spring 的 `@Scheduled` 实现周期性刷新配置项，以达到动态更新的效果；
4. 通过 spring 的 `@EventListener` 实现服务启动后配置项的加载和注入；

### 表结构定义

| 字段         | 类型      | 备注                     |
| ------------ | --------- | ------------------------ |
| id           | long      | 主键（`AUTO_INCREMENT`） |
| group        | varchar   | 组                       |
| key          | varchar   | 键                       |
| value        | varchar   | 值                       |
| remark       | varchar   | 备注信息                 |
| version      | long      | 版本号                   |
| gmt_created  | timestamp | 创建时间                 |
| gmt_modified | timestamp | 修改时间                 |

建表 SQL 语句如下：

```mysql
CREATE TABLE `config_item`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `group` varchar(255) NOT NULL DEFAULT 'DEFAULT_GROUP' COMMENT '组',
  `key` varchar(255) NOT NULL COMMENT '键',
  `value` varchar(511) NULL COMMENT '值',
  `remark` varchar(511) NULL COMMENT '备注信息',
  `version` bigint(12) NULL COMMENT '版本号',
  `gmt_created` timestamp(0) NOT NULL COMMENT '创建时间',
  `gmt_modified` timestamp(0) NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '配置信息表' ROW_FORMAT = Compact;
```

### 根据 group 和 key 查询配置项

Mybatis `ConfigItemDOMapper.xml` 中定义根据 group 和 key 查询配置信息 SQL 语句：

```xml
<select id="selectByGroupAndKey" parameterType="com.zhizhiting.domain.ConfigItemDO" resultMap="BaseResultMap">
	select
	<include refid="Base_Column_List"/>
	from config_item
	<where>
		`group` = #{group,jdbcType=VARCHAR} and `key` = #{key,jdbcType=VARCHAR}
	</where>
	order by gmt_created desc limit 1
</select>
```
Mybatis 中对应的 `ConfigItemDOMapper` 接口：
```java
package com.zhizhiting.mapper;

import com.zhizhiting.domain.ConfigItemDO

public interface ConfigItemDOMapper {
	ConfigItemDO selectByGroupAndKey(ConfigItemDO param);
}
```

### 定义 `@Dvalue` 注解

```java
package com.zhizhiting.commons;

import java.lang.annotation.ElementType;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import java.lang.annotation.Retention;
import java.lang.annotation.Documented;

@Target(ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface Dvalue {
    /**
     * 对应 dict 表中的 group 字段
     */
    String group() default "DEFAULT_GROUP";

    /**
     * 对应 dict 表中的 key 字段
     */
    String key();
    
}
```

### 收集带有 `@Dvalue` 注解的 Spring bean 信息

通过实现 `BeanPostProcessor` 接口，可以在bean初始化时加入自定义逻辑。

```java
package com.zhizhiting.commons;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.BeanPostProcessor;
import org.springframework.stereotype.Component;

import java.lang.reflect.Field;
import java.util.AbstractMap.SimpleEntry;
import java.util.HashSet;
import java.util.Objects;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
@Component
public class DvalueAnnotationBeanPostProcessor implements BeanPostProcessor {

    // 配置项与spring bean 之间的映射关系
    private ConcurrentHashMap<SimpleEntry<String, String>, Set<String>> configValueMap = new ConcurrentHashMap<>();

    @Override
    public Object postProcessBeforeInitialization(Object bean, String beanName) throws BeansException {
        Field[] fields = bean.getClass().getDeclaredFields();
        for (Field field : fields) {
            Dvalue dvalue = field.getAnnotation(Dvalue.class);
            if (Objects.isNull(dvalue)) {
                continue;
            }
            log.info("Found Dvalue, beanName={}, group={}, key={}", beanName, dvalue.group(), dvalue.key());

            SimpleEntry<String, String> config = new SimpleEntry(dvalue.group(), dvalue.key());
            Set<String> beanNames = configValueMap.get(config);
            if (Objects.isNull(beanNames)) {
                beanNames = new HashSet<>();
            }
            beanNames.add(beanName);
            configValueMap.put(config, beanNames);
        }
        return bean;
    }

    public ConcurrentHashMap<SimpleEntry<String, String>, Set<String>> getConfigMap() {
        return configValueMap;
    }
}
```

### 配置加载插件

此处为了提升扩展性，预留了配置加载接口，未来可以对接其他配置服务：

```java
package com.zhizhiting.service;

public interface IConfigLoadPlugin {
    /**
     * 加载指定 group 和 key 的配置项
     *
     * @param group
     * @param key
     * @return
     */
    String load(String group, String key);
}
```

实现基于数据库的配置加载方式：

```java
package com.zhizhiting.commons;

import com.zhizhiting.mapper.ConfigItemDOMapper;
import com.zhizhiting.domain.ConfigItemDO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.util.Objects;

@Slf4j
@Component
public class DatabaseConfigLoadPlugin implements IConfigLoadPlugin {

    @Resource
    private ConfigItemDOMapper configItemDOMapper;

    @Override
    public String load(String group, String key) {
        ConfigItemDO param = new ConfigItemDO();
        param.setGroup(group);
        param.setKey(key);

        ConfigItemDO item = configItemDOMapper.selectByGroupAndKey(param);
        if (Objects.isNull(item)) {
            throw new IllegalArgumentException("配置信息丢失：group=" + group + ", key=" + key);
        }
        return item.getValue();
    }
}
```

### 周期性刷新配置项：

在 spring boot 中需要使用 `@EnableScheduling` 来开启定时任务。

```java
package com.zhizhiting.commons;

import com.zhizhiting.utils.ReflectionUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.ApplicationContext;
import org.springframework.context.event.EventListener;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.util.AbstractMap;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
@Component
public class RefreshConfigProcessor {

    @Resource
    private DvalueAnnotationBeanPostProcessor processor;

    @Autowired
    private ApplicationContext applicationContext;

    @Resource
    private IConfigLoadPlugin configLoadPlugin;

    /**
     * Spring 启动成功后立刻刷新配置项
     */
    @EventListener
    public void handleEvent(ApplicationReadyEvent event) {
        log.info("spring startup success, start inject value");
        refresh();
    }

    /**
     * 每分钟刷新所有{@code Dvalue} 注解的属性值
     */
    @Scheduled(fixedRate = 60 * 1000)
    void refresh() {
        long start = System.currentTimeMillis();
        ConcurrentHashMap<AbstractMap.SimpleEntry<String, String>, Set<String>> configValueMap = processor.getConfigMap();

        AbstractMap.SimpleEntry<String, String> config;
        Set<String> beanNames;
        for (Map.Entry<AbstractMap.SimpleEntry<String, String>, Set<String>> entry : configValueMap.entrySet()) {
            config = entry.getKey();
            beanNames = entry.getValue();
            log.info("start process dvalue, group={}, key={}", config.getKey(), config.getValue());

            String newValue = configLoaderPlugin.load(config.getKey(), config.getValue());
            for (String beanName : beanNames) {
                Object bean = applicationContext.getBean(beanName);
                ReflectionUtil.injectDvalueToSpringProxyBean(bean, config.getKey(), config.getValue(), newValue, beanName);
                log.info("inject success beanName={}, group={}, key={}, newValue={}", beanName, config.getKey(), config.getValue(), newValue);
            }
        }
        log.info("refresh config success cost={}", (System.currentTimeMillis() - start));
    }
}
```

此处用到了一个工具类，可以在获取 spring cglib 中的真实对象：

```java
package com.zhizhiting.utils;

import com.zhizhiting.commons.Dvalue;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.aop.TargetSource;
import org.springframework.aop.framework.Advised;
import org.springframework.aop.support.AopUtils;

import java.lang.reflect.Field;
import java.util.Objects;


/**
 * 工具类
 * @author wangyunfei
 * @version 1.0.0
 * @date 2019/8/15
 */
@Slf4j
public class ReflectionUtil {

    /**
     * 从代理对象中获取原始对象
     */
    public static <T> T getProxyTarget(Object proxy) {
        if (!AopUtils.isAopProxy(proxy)) {
            throw new IllegalStateException("Target must be a proxy");
        }
        TargetSource targetSource = ((Advised) proxy).getTargetSource();
        try {
            return (T) targetSource.getTarget();
        } catch (Exception e) {
            throw new IllegalStateException(e);
        }
    }

    public static void injectDvalueToSpringProxyBean(Object bean, String group, String key, String value, String beanName) {
        try {
            Object realBean = bean;
            Field[] fields = bean.getClass().getDeclaredFields();

            if (AopUtils.isAopProxy(bean)) {
                realBean = ReflectionUtil.getProxyTarget(bean);
                fields = AopUtils.getTargetClass(bean).getDeclaredFields();
            }

            for (Field field : fields) {
                Dvalue dvalue = field.getAnnotation(Dvalue.class);
                if (Objects.nonNull(dvalue) && StringUtils.equals(group, dvalue.group()) && StringUtils.equals(key, dvalue.key())) {
                    ReflectionUtil.setFieldValue(realBean, field, value);
                    log.info("set field, beanName={}, group={}, key={}, value={}", beanName, group, key, value);
                }
                continue;
            }
        } catch (Exception e) {
            log.error("inject value fail.", e);
        }
    }

    public static void setFieldValue(Object bean, Field field, String value) {
        try {
            field.setAccessible(true);
            if (field.getType() == int.class) {
                field.setInt(bean, Integer.valueOf(value).intValue());
            } else if (field.getType() == Integer.class) {
                field.set(bean, Integer.valueOf(value));
            } else if (field.getType() == boolean.class) {
                field.setBoolean(bean, Boolean.valueOf(value).booleanValue());
            } else if (field.getType() == Boolean.class) {
                field.set(bean, Boolean.valueOf(value));
            } else if (field.getType() == float.class) {
                field.setFloat(bean, Float.valueOf(value).floatValue());
            } else if (field.getType() == Float.class) {
                field.set(bean, Float.valueOf(value));
            } else if (field.getType() == double.class) {
                field.setDouble(bean, Double.valueOf(value).doubleValue());
            } else if (field.getType() == Double.class) {
                field.set(bean, Double.valueOf(value));
            } else if (field.getType() == byte.class) {
                field.setByte(bean, Byte.valueOf(value).byteValue());
            } else if (field.getType() == Byte.class) {
                field.set(bean, Byte.valueOf(value));
            } else if (field.getType() == char.class) {
                field.setChar(bean, value.charAt(0));
            } else if (field.getType() == Character.class) {
                field.set(bean, Character.valueOf(value.charAt(0)));
            } else if (field.getType() == short.class) {
                field.setShort(bean, Short.valueOf(value).shortValue());
            } else if (field.getType() == Short.class) {
                field.set(bean, Short.valueOf(value));
            } else if (field.getType() == long.class) {
                field.setLong(bean, Long.valueOf(value).longValue());
            } else if (field.getType() == Long.class) {
                field.set(bean, Long.valueOf(value));
            } else {
                field.set(bean, value);
            }
        } catch (IllegalAccessException e) {
            log.error(String.format("set value fail. bean=%s, field=%s, value=%s", bean.getClass().getName(), field.getName(), value), e);
        }
    }
}
```

### 项目启动类

```java
package com.zhizhiting;

import org.springframework.boot.autoconfigure.SpringBootApplication;

import org.springframework.boot.SpringApplication;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.EnableScheduling;

@Slf4j
@EnableScheduling
@SpringBootApplication
public class ConfigApplication {
    public static void main(String[] args) {
        SpringApplication.run(ConfigApplication.class, args);
    }
}
```

###  使用方式

```java
@Dvalue(group = "test", key = "product.name")
private String name;
```

### 启动项目看看效果

```bash
2019-08-15 19:09:23,453 INFO [RefreshConfigProcessor.java:57] - start process dvalue, group=test, key=product.name
2019-08-15 19:09:23,529 INFO [ReflectionUtil.java:52] - set field, beanName=customerServiceImpl, group=test, key=product.name, value=abc
2019-08-15 19:09:23,529 INFO [RefreshConfigProcessor.java:63] - inject success beanName=customerServiceImpl, group=test, key=product.name, newValue=123
2019-08-15 19:09:23,530 INFO [RefreshConfigProcessor.java:66] - refresh config success cost=77
```

已经替换成功。



到此，功能已经结束。



### 改进项

* 改为 spring boot starter