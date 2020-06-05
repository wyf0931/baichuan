---
title: Ubuntu apt 国内镜像站
author: Scott
tags:
  - ubuntu
  - Linux
categories: []
date: 2019-08-19 12:03:00
---
由于国内网络环境问题，apt 安装会很慢，可以改为国内镜像站，提高速度。
<!--more-->

## 操作步骤
Ubuntu 镜像源配置文件为 `/etc/apt/resours.list`，只需编辑里面文件将自带链接替换为各大镜像站链接即可，步骤如下：

1、备份原配置文件：
```bash
sudo mv /etc/apt/sources.list /etc/apt/sources.list.bak
```

2、编辑配置文件：
```bash
sudo vi /etc/apt/sources.list
```
将内容替换为下面任意一个即可。

3、更新链接索引：
```bash
sudo apt-get update
```

## 镜像地址
以 Ubuntu 18.04 版为例：

* **清华大学**

Ubuntu 页面：https://mirrors.tuna.tsinghua.edu.cn/help/ubuntu/
源地址：https://mirrors.tuna.tsinghua.edu.cn/ubuntu/

```bash
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-security main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-proposed main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-proposed main restricted universe multiverse
```

* **中科大**

Ubuntu 页面：http://mirrors.ustc.edu.cn/help/ubuntu.html
源地址：https://mirrors.ustc.edu.cn/ubuntu/
```bash
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.ustc.edu.cn/ubuntu/ bionic main restricted universe multiverse
# deb-src https://mirrors.ustc.edu.cn/ubuntu/ bionic main restricted universe multiverse
deb https://mirrors.ustc.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse
# deb-src https://mirrors.ustc.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse
deb https://mirrors.ustc.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse
# deb-src https://mirrors.ustc.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse
deb https://mirrors.ustc.edu.cn/ubuntu/ bionic-security main restricted universe multiverse
# deb-src https://mirrors.ustc.edu.cn/ubuntu/ bionic-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb https://mirrors.ustc.edu.cn/ubuntu/ bionic-proposed main restricted universe multiverse
# deb-src https://mirrors.ustc.edu.cn/ubuntu/ bionic-proposed main restricted universe multiverse
```

* **阿里巴巴**

Ubuntu 页面：https://opsx.alibaba.com/guide?lang=zh-CN&document=69a2341e-801e-11e8-8b5a-00163e04cdbb
源地址：http://mirrors.aliyun.com/ubuntu/

```bash
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
# deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
# deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
# deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
# deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse

# 预发布软件源，不建议启用
# deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
# deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
```

* **网易**

Ubuntu 页面：http://mirrors.163.com/.help/ubuntu.html
源地址：http://mirrors.163.com/

```bash
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb http://mirrors.163.com/ubuntu/ bionic main restricted universe multiverse
# deb-src http://mirrors.163.com/ubuntu/ bionic main restricted universe multiverse

deb http://mirrors.163.com/ubuntu/ bionic-security main restricted universe multiverse
# deb-src http://mirrors.163.com/ubuntu/ bionic-security main restricted universe multiverse

deb http://mirrors.163.com/ubuntu/ bionic-updates main restricted universe multiverse
# deb-src http://mirrors.163.com/ubuntu/ bionic-updates main restricted universe multiverse

deb http://mirrors.163.com/ubuntu/ bionic-proposed main restricted universe multiverse
# deb-src http://mirrors.163.com/ubuntu/ bionic-proposed main restricted universe multiverse

# 预发布软件源，不建议启用
# deb http://mirrors.163.com/ubuntu/ bionic-backports main restricted universe multiverse
# deb-src http://mirrors.163.com/ubuntu/ bionic-backports main restricted universe multiverse
```