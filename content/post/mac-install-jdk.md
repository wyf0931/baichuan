---
title: "在Mac上配置JAVA、Maven环境变量"
author: Scott
tags:
  - Java
  - Maven
categories:
  - 技术
date: 2021-06-14T16:35:50+08:00
---

本文介绍如何在 Mac 系统上配置 Java、Maven 环境变量。

<!--more-->

## 一、配置Java环境变量

### 1、查看默认JDK的安装路径

在 Mac 的 Terminal（终端）中输入以下命令来查看系统默认的 JDK 安装路径：

```bash
/usr/libexec/java_home -V
```

输出类似如下：

```bash
Matching Java Virtual Machines (1):
    1.8.0_231, x86_64:	"Java SE 8"	/Library/Java/JavaVirtualMachines/jdk1.8.0_231.jdk/Contents/Home

/Library/Java/JavaVirtualMachines/jdk1.8.0_231.jdk/Contents/Home
```

其中 `/Library/Java/JavaVirtualMachines/jdk1.8.0_231.jdk/Contents/Home` 就是默认 JDK 的安装路径。

### 2、配置环境变量

通过以下命令来查看是否已经有 `.bash_profile` 文件。

```bash
ls -al ~ |grep .bash_profile
```

若没有，则用以下命令来创建一个空文件。（有则跳过）

```bash
touch ~/.bash_profile
```

打开该文件：

```bash
open -e ~/.bash_profile
```

在文件末尾加入以下内容，保存后关闭（下文中 `JAVA_HOME` 后面的值就是第一步中获取到的 JDK 安装路径）：

```bash
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_231.jdk/Contents/Home
export PATH=$JAVA_HOME/bin:$PATH:.
```

### 3、配置生效

通过以下命令使得上述配置生效：

```bash
source ~/.bash_profile
```

可以通过以下命令来检查是否已经生效：

```bash
echo $JAVA_HOME

#输出如下则表明已经生效
/Library/Java/JavaVirtualMachines/jdk1.8.0_231.jdk/Contents/Home
```



## 二、配置Maven环境变量

Maven 环境变量配置类似于Java。

### 1、配置环境变量

打开 `.bash_profile` 配置文件

```bash
open -e ~/.bash_profile
```

在文件末尾加入如下配置并保存：

```bash
export M2_HOME=/Users/xxx/Documents/apache-maven-3.6.2
export M2=$M2_HOME/bin
export PATH=$M2:$PATH
```

其中 `/Users/xxx/Documents/apache-maven-3.6.2` 就是你下载并解压后的 maven 路径。

### 2、配置生效

通过以下命令使得上述配置生效：

```bash
source ~/.bash_profile
```

可以通过以下命令来检查是否已经生效：

```bash
echo $M2_HOME

#输出如下则表明已经生效
/Users/xxx/Documents/apache-maven-3.6.2
```





