---
title: 查看Linux版本信息
author: Scott
tags:
  - Linux
categories:
  - 技术
date: 2019-08-05 16:18:00
---
本文介绍一些用于查看linux系统版本信息的常用命令。

<!--more-->



### uname
在Linux 命令行中输入以下命令：
```bash
uname -a
```
命令行会输出类似如下信息：
```bash
Linux VM-0-3-ubuntu 4.4.0-92-generic #115-Ubuntu SMP Thu Aug 10 16:02:55 UTC 2017 i686 i686 i686 GNU/Linux
```
Windows 子系统类似如下输出 ：
```bash
Linux Scott-PC 4.4.0-17134-Microsoft #706-Microsoft Mon Apr 01 18:13:00 PST 2019 x86_64 x86_64 x86_64 GNU/Linux
```
其中 `x86_64` 表示基于 x86 架构的 64 位系统。

### lsb_release
在Linux 命令行中输入以下命令：
```bash
lsb_release -a
```
命令行输出类似如下信息:
```bash
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 16.04.6 LTS
Release:        16.04
Codename:       xenial
```

其中 `Release` 就是系统版本号，`Distributor ID` 为系统类型。