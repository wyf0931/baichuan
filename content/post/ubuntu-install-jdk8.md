---
title: 'Ubuntu 安装 JDK 8 '
author: Scott
tags:
  - Java
  - ubuntu
categories:
  - 技术
date: 2019-07-02 16:17:00
draft: false
---
本文介绍如何在 Ubuntu 环境安装 Oracle JDK。
<!--more-->

### 下载并解压 JDK
首先需要在Oracle 官网下载 JDK 安装包。

> 官网地址：http://www.oracle.com/technetwork/java/javase/downloads/index.html


我下载的是 *jdk-8u131-linux-x64.tar.gz*：

```bash
wget -O "jdk-8u131-linux-x64.tar.gz" http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz
```

解压 *jdk-8u131-linux-x64.tar.gz*，此处解压到了 `/usr/lib/jvm` 目录：
```bash
mkdir /usr/lib/jvm
tar -xzf jdk-8u131-linux-x64.tar.gz -C /usr/lib/jvm
```

### 配置环境变量
```bash
export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_131
export JRE_HOME=${JAVA_HOME}/jre
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
export PATH={JAVA_HOME}/bin:$PATH
```

### 检查是否安装成功
可以通过查看 Java 版本的方式来检查是否安装成功，命令如下：
```bash
> java -version
java version "1.8.0_131"
Java(TM) SE Runtime Environment (build 1.8.0_131-b11)
Java HotSpot(TM) 64-Bit Server VM (build 25.131-b11, mixed mode)
```