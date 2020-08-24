---
title: Maven Deploy Plugin 使用方法
author: Scott
tags:
  - Maven
  - Java
categories:
  - 技术
date: 2020-01-02 11:23:00
---

本文介绍Maven 项目中如何通过 deploy plugin 配置来跳过某些不需要 deploy 的maven 模块。

<!--more-->

Maven 依赖声明：

```xml
<build>
  <plugins>
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-deploy-plugin</artifactId>
      <configuration>
        <skip>true</skip>
      </configuration>
    </plugin>
  </plugins>
</build>
```
可以在需要跳过的 model 中配置上述信息，并声明 `<skip>true</skip>` ，即可在全局执行 `mvn deploy` 动作时跳过该模块。


> 最新版本：https://mvnrepository.com/artifact/org.apache.maven.plugins/maven-deploy-plugin

