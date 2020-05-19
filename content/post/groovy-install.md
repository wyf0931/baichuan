---
title: Groovy 环境安装
author: Scott
tags:
  - groovy
categories: []
date: 2019-06-28 17:13:00
---
以 Groovy  的二进制发行版，安装过程如下：

* 首先，[下载 Groovy](http://www.groovy-lang.org/install.html#download-groovy) 的二进制发行版并将其解压缩到本地文件系统上的某个文件中；
* 将 `GROOVY_HOME` 环境变量设置为解压缩发行版文件的目录；
* 将 `GROOVY_HOME/bin` 添加到 `PATH` 环境变量中；
* 将 `JAVA_HOME` 环境变量指向你的 JDK。OS X 上是 `/Library/Java/Home`，其他 unix 环境通常是 `/usr/java` 。如果你已经装过 Ant 或 Maven 等工具，可能你已经完成这一步了。

此时，你可能已经安装完成了。你可以通过拼写以下命令来测试：
```bash
groovysh
```
它会创建一个 groovy shell 交互会话，你可以在此处拼写 Groovy 语句。或者拼写以下命令来运行Swing 交互控制台： 
```bash
groovyConsole
```
运行指定的 Groovy 脚本：
```bash
groovy SomeScript
```

> 原文地址：http://www.groovy-lang.org/install.html#_install_binary