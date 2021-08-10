---
title: "MyBatis 插件开发"
date: 2021-08-08T19:47:55+08:00
tags:
  - mybatis
  - 架构设计
categories:
  - 技术
---

本文是抄书笔记，摘抄自刘增辉的《Mybatis从入门到精通》第八章。

<!--more-->

MyBatis 允许在已映射语句执行过程中的某一点进行拦截调用。默认情况下，MyBatis 允许使用插件来拦截的接口和方法包括以下几个：

| 接口               | 方法                                                         |
| ------------------ | ------------------------------------------------------------ |
| `Executor`         | `update`、`query`、`flushStatements`、`commit`、`rollback`、`getTransaction`、`close`、`isClosed` |
| `ParameterHandler` | `getParameterObject`、`setParameters`                        |
| `ResultSetHandler` | `handleResultSets` 、 `handleCursorResultSets` 、 `handleOutputParameters` |
| `StatementHandler` | `prepare`、`parameterize`、`batch`、`update`、`query`        |

这些接口都是底层类和方法，所以使用插件的时候要特别当心。因为在修改或重写已有方法行为的时候，很可能会破坏 MyBatis 的核心模块。下面将对拦截器的各个细节进行详细介绍。



## 一、拦截器接口介绍

MyBatis 插件可以用来实现拦截器接口 `Interceptor`(`org.apache.ibatis. plugin.Interceptor`)，在实现类中对拦截对象和方法进行处理。

`Interceptor` 接口代码如下：

```java
public interface Interceptor {
	Object intercept(Invocation invocation) throws Throwable; 
	Object plugin(Object target);
	void setProperties(Properties properties);
}
```

### 1.1 setProperties方法

其中 `setProperties` 方法用来传递插件的参数。参数值在 `mybatis-config.xml` 中配置拦截器传递进来，一般情况下，拦截器的配置如下。

在 mybatis-config.xml 中，一般情况下，拦截器的配置如下：

```xml
<plugins>
	<plugin interceptor="tk.mybatis.simple.plugin.XXXInterceptor">
		<property name="prop1" value="value1"/>
		<property name="prop2" value="value2"/> 
  </plugin>
</plugins>
```

### 1.2 plugin方法

第二个方法 `plugin`。这个方法的参数 `target` 就是拦截器要拦截的对象，该方法会在创建被拦截的接口实现类时被调用。该方法的实现很简单，只需要调用 MyBatis 提供的 `Plugin`(`org.apache.ibatis.plugin.Plugin`)类的 `wrap` 静态方法就可以通过 Java 的 动态代理拦截目标对象。这个接口方法通常的实现代码如下：

```java
@Override
public Object plugin(Object target) {
	return Plugin.wrap(target, this); 
}
```

`Plugin.wrap` 方法会自动判断拦截器的签名和被拦截对象的接口是否匹配，只有匹配的情况下才会使用动态代理拦截目标对象，因此在上面的实现方法中不必做额外的逻辑判断。

### 1.3 intercept方法

最后一个 `intercept` 方法是 MyBatis 运行时要执行的拦截方法。通过该方法的参数 `invocation` 可以得到很多有用的信息，该参数的常用方法如下。

```java
@Override
public Object intercept(Invocation invocation) throws Throwable {
  Object target = invocation.getTarget(); 
  Method method = invocation.getMethod(); 
  Object[] args = invocation.getArgs(); 
  Object result = invocation.proceed(); 
  return result;
}
```

- 使用 `getTarget()` 方法可以获取当前被拦截的对象；

- 使用 `getMethod()` 方法可以获取当前被拦截 的方法；

- 使用 `getArgs()` 方法可以返回被拦截方法中的参数。

通过调用 `invocation.proceed();` 可以执行被拦截对象真正的方法，`proceed()` 方法实际上执行了 `method.invoke(target, args) `方法，上面的代码中没有做任何特殊处理，直接返回了执行的结果。

### 1.4 多个拦截器的执行顺序

当配置多个拦截器时，MyBatis 会遍历所有拦截器，按顺序执行拦截器的 `plugin` 方法， 被拦截的对象就会被层层代理。在执行拦截对象的方法时，会一层层地调用拦截器，拦截器通 过 `invocation.proceed()` 调用下一层的方法，直到真正的方法被执行。方法执行的结果会 从最里面开始向外一层层返回，所以如果存在按顺序配置的 A、B、C 三个签名相同的拦截器， MyBaits 会按照 C>B>A>target.proceed()>A>B>C 的顺序执行。如果 A、B、C 签名不同， 就会按照 MyBatis 拦截对象的逻辑执行。



## 二、拦截器签名介绍

除了需要实现拦截器接口外，还需要给实现类配置以下的拦截器注解。

`@Intercepts`(`org.apache.ibatis.plugin.Intercepts`)和签名注解`@Signature` (`org.apache.ibatis.plugin.Signature`)，这两个注解用来配置拦截器要拦截的接口 的方法。

`@Intercepts` 注解中的属性是一个`@Signature`(签名)数组，可以在同一个拦截器中 同时拦截不同的接口和方法。

以拦截 `ResultSetHandler` 接口的 `handleResultSets` 方法为例，配置签名如下。

```java
@Intercepts({
         @Signature(
type = ResultSetHandler.class, method = "handleResultSets", args = {Statement.class})
      })
public class ResultSetInterceptor implements Interceptor
```

`@Signature` 注解包含以下三个属性。

- `type`: 设置拦截的接口，可选值是前面提到的 4 个接口。
- `method`: 设置拦截接口中的方法名，可选值是前面 4 个接口对应的方法，需要和接口匹配。
- `args`: 设置拦截方法的参数类型数组，通过方法名和参数类型可以确定唯一一个方法。

由于 MyBatis 代码具体实现的原因，可以被拦截的 4 个接口中的方法并不是都可以被拦截的。下面将针对这 4 种接口，将可以被拦截的方法以及方法被调用的位置和对应的拦截器签名依次列举出来，大家可以根据方法调用的位置和方法提供的参数来选择想要拦截的方法。

### 2.1 Executor接口

`Executor` 接口包含以下几个方法。

- `update`

```java
int update(MappedStatement ms, Object parameter) throws SQLException
```

该方法会在所有的 `INSERT`、`UPDATE`、`DELETE` 执行时被调用，因此如果想要拦截这 3 类操作，可以拦截该方法。接口方法对应的签名如下。

```java
@Signature(type = Executor.class, method = "update", args = {MappedStatement.class, Object.class})
```

- `query`

```java
<E> List<E> query( MappedStatement ms, Object parameter, RowBounds rowBounds, 
                  ResultHandler resultHandler) throws SQLException
```

该方法会在所有 `SELECT`  查询方法执行时被调用。通过这个接口参数可以获取很多有用的信息，因此这是最常被拦截的一个方法。使用该方法需要注意的是，虽然接口中还有一个参数更多的同名接口，但由于 MyBatis 的设计原因，这个参数多的接口不能被拦截。接口方法对应的签名如下。

```java
@Signature(type = Executor.class, method = "query", 
           args = {MappedStatement.class, Object.class, RowBounds.class, Result Handler.class})
```

- `queryCursor`

```java
<E> Cursor<E> queryCursor(MappedStatement ms, Object parameter, RowBounds rowBounds) throws SQLException
```

该方法只有在查询的返回值类型为 `Cursor` 时被调用。接口方法对应的签名如下。

```java
@Signature(type = Executor.class, method = "queryCursor", 
           args = {MappedStatement.class, Object.class, RowBounds.class})
```

- `flushStatements`

```java
List<BatchResult> flushStatements() throws SQLException
```

该方法只在通过 `SqlSession` 方法调用 `flushStatements` 方法或执行的接口方法中带 有 `@Flush` 注解时才被调用，接口方法对应的签名如下。

```java
@Signature(type = Executor.class, method = "flushStatements", args = {})
```

- `commit`

```java
void commit(boolean required) throws SQLException
```

该方法只在通过 `SqlSession` 方法调用 `commit` 方法时才被调用，接口方法对应的签名如下。

```java
@Signature(type = Executor.class, method = "commit", args = {boolean.class})
```

- `rollback`

```java
void rollback(boolean required) throws SQLException
```

该方法只在通过 `SqlSession` 方法调用 `rollback` 方法时才被调用，接口方法对应的签 名如下。

```java
@Signature(type = Executor.class,method = "rollback",args = {boolean.class})
```

- `getTransaction`

```java
Transaction getTransaction()
```

该方法只在通过 SqlSession 方法获取数据库连接时才被调用，接口方法对应的签名如下。

```java
@Signature(type = Executor.class, method = "getTransaction", args = {})
```

- `close`

```java
void close(boolean forceRollback)
```

该方法只在延迟加载获取新的 Executor 后才会被执行，接口方法对应的签名如下。

```java
@Signature(type = Executor.class,method = "close",args = {boolean.class})
```

- `isClosed`

```java
boolean isClosed()
```

该方法只在延迟加载执行查询方法前被执行，接口方法对应的签名如下。

```java
@Signature(type = Executor.class, method = "isClosed", args = {})
```

### 2.2 ResultSetHandler接口

`ResultSetHandler` 接口包含以下三个方法。

- `handleResultSets`

```java
<E> List<E> handleResultSets(Statementstmt)throwsSQLException;
```

该方法会在除存储过程及返回值类型为 `Cursor<T>`(`org.apache.ibatis. cursor.Cursor<T>`)以外的查询方法中被调用。接口方法对应的签名如下。

```java
@Signature(type = ResultSetHandler.class, method = "handleResultSets", args = {Statement.class})
```

- `handleCursorResultSets` (since 3.4.0)

```java
<E> Cursor<E> handleCursorResultSets(Statement stmt) throws SQLException;
```

该方法是 3.4.0 版本中新增加的，只会在返回值类型为 `Cursor<T>` 的查询方法中被调用， 接口方法对应的签名如下。

```java
@Signature(type = ResultSetHandler.class, method = "handleCursorResultSets", args = {Statement.class})
```

- `handleOutputParameters`

```java
void handleOutputParameters(CallableStatement cs) throws SQLException;
```

该方法只在使用存储过程处理出参时被调用，接口方法对应的签名如下。

```java
@Signature(type = ResultSetHandler.class, method = "handleOutputParameters", args = {CallableStatement.class})
```

`ResultSetHandler` 接口的第一个方法对于拦截处理 MyBatis 的查询结果非常有用，并且由于这个接口被调用的位置在处理二级缓存之前，因此通过这种方式处理的结果可以执行二级缓存。在后面一节中会就该方法提供一个针对 `Map` 类型结果处理 `key` 值的插件。



### 2.3 ResultSetHandler接口

ResultSetHandler 接口包含以下三个方法。

- `handleResultSets`

```java
<E> List<E> handleResultSets(Statementstmt) throws SQLException;
```

该方法会在除存储过程及返回值类型为 `Cursor<T>`(`org.apache.ibatis. cursor.Cursor<T>`)以外的查询方法中被调用。接口方法对应的签名如下。

```java
@Signature(type = ResultSetHandler.class, method = "handleResultSets", args = {Statement.class})
```

- `handleCursorResultSets` (since 3.4.0)

```java
<E> Cursor<E> handleCursorResultSets(Statement stmt) throws SQLException;
```

该方法是 3.4.0 版本中新增加的，只会在返回值类型为 `Cursor<T>` 的查询方法中被调用， 接口方法对应的签名如下。

```java
@Signature(type = ResultSetHandler.class, method = "handleCursorResultSets", args = {Statement.class})
```

```java
void handleOutputParameters(CallableStatement cs) throws SQLException;
```

该方法只在使用存储过程处理出参时被调用，接口方法对应的签名如下。

```java
@Signature(type = ResultSetHandler.class, method = "handleOutputParameters", args = {CallableStatement.class})
```

`ResultSetHandler` 接口的第一个方法对于拦截处理 MyBatis 的查询结果非常有用，并且由于这个接口被调用的位置在处理二级缓存之前，因此通过这种方式处理的结果可以执行二 级缓存。在后面一节中会就该方法提供一个针对 `Map` 类型结果处理 `key` 值的插件。

### 2.4 StatementHandler接口

`StatementHandler` 接口包含以下几个方法。

- `prepare`

```java
Statement prepare(Connection connection, Integer transactionTimeout) throws SQLException;
```

该方法会在数据库执行前被调用，优先于当前接口中的其他方法而被执行。接口方法对应 的签名如下。

```java
@Signature(type = StatementHandler.class, method = "prepare", args = {Connection.class, Integer.class})
```

- `parameterize`

```java
void parameterize(Statement statement) throws SQLException;
```

该方法在 `prepare` 方法之后执行，用于处理参数信息，接口方法对应的签名如下。

```java
@Signature(type = StatementHandler.class, method = "parameterize", args = {Statement.class})
```

- `batch`

```java
int batch(Statement statement) throws SQLException;
```

在全局设置配置 `defaultExecutorType="BATCH" `时，执行数据操作才会调用该方法， 接口方法对应的签名如下。

```java
@Signature(type = StatementHandler.class, method = "batch", args = {Statement.class})
```

- `query`

```java
<E> List<E> query(Statement statement, ResultHandler resultHandler) throws SQLException;
```

执行 `SELECT` 方法时调用，接口方法对应的签名如下。

```java
@Signature( type = StatementHandler.class, method = "query", args = {Statement.class, ResultHandler.class})
```

- `queryCursor` (since 3.4.0)

```java
<E> Cursor<E> queryCursor(Statementstatement)throwsSQLException;
```

该方法是 3.4.0 版本中新增加的，只会在返回值类型为 `Cursor<T>` 的查询中被调用，接口 方法对应的签名如下。

```java
@Signature( type = StatementHandler.class, method = "queryCursor", args ={Statement.class})
```

在介绍了以上签名后，下面要动手实现两个简单的拦截器了。

## 三、DEMO-下画线键值转小写驼峰形式插件

有些人在使用MyBatis时，为了方便扩展而使用 `Map` 类型的返回值。使用 `Map` 作为返回值 时，`Map` 中的键值就是查询结果中的列名，而列名一般都是大小写字母或者下画线形式，和 Java 中使用的驼峰形式不一致。而且由于不同数据库查询结果列的大小写也并不一致，因此为了保 证在使用 `Map` 时的属性一致，可以对 `Map` 类型的结果进行特殊处理，即将不同格式的列名转换 为 Java 中的驼峰形式。这种情况下，我们就可以使用拦截器，通过拦截 `ResultSetHandler` 接口中的 `handleResultSets` 方法去处理 `Map` 类型的结果。拦截器实现代码如下。

```java
package tk.mybatis.simple.plugin;

import java.sql.Statement; 
import java.util.HashSet; 
import java.util.List; 
import java.util.Map; 
import java.util.Properties; 
import java.util.Set;
import org.apache.ibatis.executor.resultset.ResultSetHandler; 
import org.apache.ibatis.plugin.Interceptor;
import org.apache.ibatis.plugin.Intercepts;
import org.apache.ibatis.plugin.Invocation;
import org.apache.ibatis.plugin.Plugin;
import org.apache.ibatis.plugin.Signature;
/**
* MyBatis Map 类型下画线 key 转小写驼峰形式 *
* @author liuzenghui
*/
@Intercepts(
  @Signature(type = ResultSetHandler.class, method = "handleResultSets", args = {Statement.class}))
@SuppressWarnings({ "unchecked", "rawtypes" })
public class CameHumpInterceptor implements Interceptor {
  @Override
  public Object intercept(Invocation invocation) throws Throwable {
    //先执行得到结果，再对结果进行处理
    List<Object> list = (List<Object>) invocation.proceed(); 
    for(Object object : list){
    	//如果结果是 Map 类型，就对 Map 的 key 进行转换 
      if(object instanceof Map){
        processMap((Map)object);
      } else {
        break; 
      }
  	}
		return list;
	}
  
  /**
  * 处理Map类型 *
  * @param map */
  private void processMap(Map<String, Object> map) {
    Set<String> keySet = new HashSet<String>(map.keySet()); 
    for(String key : keySet){
      //将以大写开头的字符串转换为小写，如果包含下画线也会处理为驼峰 
      //此处只通过这两个简单的标识来判断是否进行转换 
      if((key.charAt(0) >= 'A' && key.charAt(0) <= 'Z') || key. indexOf("_") >= 0){
        Object value = map.get(key); 
        map.remove(key);
        map.put(underlineToCamelhump(key), value);
      } 
    }
  }
  
  /**
    * 将下画线风格替换为驼峰风格 *
    * @param inputString
    * @return
    */
  public static String underlineToCamelhump(String inputString) { 
    StringBuilder sb = new StringBuilder();
    boolean nextUpperCase = false;
    for (int i = 0; i < inputString.length(); i++) {
      char c = inputString.charAt(i); 
      if(c == '_'){
        if (sb.length() > 0) {
          nextUpperCase = true; 
        }
  		} else {
  			if (nextUpperCase) {
  				sb.append(Character.toUpperCase(c));
  				nextUpperCase = false; 
        } else {
  				sb.append(Character.toLowerCase(c)); 
        }
  		}
    }
		return sb.toString(); 
  }
  
  @Override
  public Object plugin(Object target) {
    return Plugin.wrap(target, this); 
  }
  @Override
	public void setProperties(Properties properties) { 
  }
}
```

这个插件的功能很简单，就是循环判断结果。如果是 `Map` 类型的结果，就对 `Map` 的 `key` 进行处理，处理时为了避免把已经是驼峰的值转换为纯小写，因此通过首字母是否为大写或是 否包含下画线来判断(实际应用中要根据实际情况修改)。如果符合其中一个条件就转换为驼峰 形式，删除对应的 `key` 值，使用新的 `key` 值来代替。当数据经过这个拦截器插件处理后，就可 以保证在任何数据库中以 `Map` 作为结果值类型时，都有一致的 `key` 值，可以统一取值，尤其在 JSP 或者其他模板引擎中取值时，可以很方便地使用。想要使用该插件，需要在 `mybatis-config.xml` 中配置该插件。

```xml
<plugins>
	<plugin interceptor="tk.mybatis.simple.plugin.CameHumpInterceptor"/>
</plugins>
```

虽然这只是一个简单的例子，但是却有一段看似简单实际并不简单的代码，在上面拦截器 代码的第 31 行，`invocation.proceed()` 执行的结果被强制转换为了 `List` 类型。这是因为拦截器接口 `ResultSetHandler` 的 `handleResultSets` 方法的返回值为 `List` 类型，所以 才能在这里直接强制转换。如果不知道这一点，就很难处理这个返回值。许多接口方法的返回值类型都是 `List`，但是还有很多其他的类型，所以在写拦截器时，要根据被拦截的方法来确定返回值的类型。

## 四、总结

本章对 MyBatis 拦截器中可以拦截的每一个对象的每一个方法都进行了简单的介绍，通过 本章的学习，希望大家能根据自己的需要选择合适的方法进行拦截。本章以两个插件为例，对 最常用的两个拦截方法进行了演示，希望这两个例子能够引领大家入门。

如果对插件有兴趣，可以参考 http://mybatis.tk 上面提供的插件进行深入学习。想要灵活地运 用 MyBatis 中的对象实现插件，需要对 MyBatis 中的对象有所了解。在本书最后一章中，我们会 对 MyBatis 源码进行简单的介绍，让大家能更好地理解 MyBatis，进而开发自己需要的插件。