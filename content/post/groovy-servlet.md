---
title: Groovy Servlet 使用指南
author: Scott
tags:
  - groovy
  - servlet
categories: []
date: 2019-06-28 18:20:00
---
我们可以在 Groovy 中写 Java Servlet，称为 Groovlet 或 GroovyServlet。它能自动编译 `.groovy` 源文件并转换为字节码。

Groovlet使用示例如下：
```groovy
if (!session) {
  session = request.getSession(true)
}

if (!session.counter) {
  session.counter = 1
}

println """
<html>
    <head>
        <title>Groovy Servlet</title>
    </head>
    <body>
        <p>
Hello, ${request.remoteHost}: ${session.counter}! ${new Date()}
        </p>
    </body>
</html>
"""
session.counter = session.counter + 1
```
或者，使用 `MarkupBuilder` 执行相同的操作：
```groovy
if (!session) {
    session = request.getSession(true)
}

if (!session.counter) {
    session.counter = 1
}

html.html { // html is implicitly bound to new MarkupBuilder(out)
  head {
      title('Groovy Servlet')
  }
  body {
    p("Hello, ${request.remoteHost}: ${session.counter}! ${new Date()}")
  }
}
session.counter = session.counter + 1
```
> 注意：代码中使用隐式变量来访问 session、request、out，由于没有类包装，感觉像是个脚本。

### 隐式变量
以下变量可以在 Groovlet 中直接使用：

|变量名|	绑定	|备注|
|---|---|---|
|request|ServletRequest|-|
|response|ServletResponse|-|
|context|ServletContext|-|
|application|ServletContext|-|
|session|getSession(false)|可以是 null（参考<1>）|
|params||Map 对象|
|headers||Map对象|
|out|	response.getWriter()|参考<2>|
|sout|response.getOutputStream()|参考<2>|
|html|new MarkupBuilder(out)|参考<2>|
|json|new StreamingJsonBuilder(out)|参考<2>|

1. 如果已存在 `session` 对象，则仅设置 `session` 变量。请参阅上面示例中的 `if (session == null)` 检查。
2. 无法在 Groovlet 中重新分配这些变量。它们在第一次访问时受到约束，允许例如在使用之前调用`response` 对象上的`out`方法。

### groovylet 配置
在`web.xml` 中添加以下代码：
```xml
<servlet>
    <servlet-name>Groovy</servlet-name>
    <servlet-class>groovy.servlet.GroovyServlet</servlet-class>
</servlet>

<servlet-mapping>
    <servlet-name>Groovy</servlet-name>
    <url-pattern>*.groovy</url-pattern>
</servlet-mapping>
```
然后将所需的 groovy jar 文件放入`WEB-INF/lib`。

将 `.groovy` 文件放在根目录中（即放置 html 文件的位置）。GroovyServlet 负责编译 `.groovy` 文件。

以 tomcat 为例，可以像这样编辑 `tomcat/conf/server.xml`：
```xml
<Context path="/groovy" docBase="c:/groovy-servlet"/>
```
通过 `http://localhost:8080/groovy/hello.groovy` 访问它。

> 原文地址：http://groovy-lang.org/servlet.html