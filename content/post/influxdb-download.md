---
title: InfluxDB 安装包下载
author: Scott
tags:
  - InfluxDB
categories:
  - 技术
date: 2019-07-03 14:56:00
---
本文介绍 InfluxDB 的多种下载方式，以 v1.7.1 版本为例。
<!--more-->

#### OS X (via [Homebrew](http://brew.sh/))
```bash
brew update
brew install influxdb
```

#### Docker Image
```bash
docker pull influxdb
```

#### Ubuntu & Debian
**SHA256**: `e7fd1ac2c14a6d5bbff74148770ce2309174e4d998770e70c1cb360f53ba1f02` 
```bash
wget https://dl.influxdata.com/influxdb/releases/influxdb_1.7.1_amd64.deb
sudo dpkg -i influxdb_1.7.1_amd64.deb
```

#### RedHat & CentOS
**SHA256**: `6ec75d444e70590be8ff3561b00cbec73b407a45281f16f0106b860590d0a4d6`
```bash
wget https://dl.influxdata.com/influxdb/releases/influxdb-1.7.1.x86_64.rpm
sudo yum localinstall influxdb-1.7.1.x86_64.rpm
```

#### Mac OS X
**SHA256**: `8d89a2134c2a4db8bd993f85c0fe2a6394ab2ab9e0310fbdbb6babe28ebac05c` 
```bash
https://dl.influxdata.com/influxdb/releases/influxdb-1.7.1_darwin_amd64.tar.gz
tar zxvf influxdb-1.7.1_darwin_amd64.tar.gz
```


#### Windows Binaries (64-bit)
**SHA256**: `619909e53c2f51e99a1e3957cb8b511eed79b9332307ab39f45fc5dcf9a2feba` 
```bash
https://dl.influxdata.com/influxdb/releases/influxdb-1.7.1_windows_amd64.zip
unzip influxdb-1.7.1_windows_amd64.zip
```


#### Linux Binaries (64-bit)
**SHA256**: `cfdf5d29b6d0044b8bce41ce6e52250f5ffc2aefbc89a5a3f33824d96b47ab6c` 
```bash
wget https://dl.influxdata.com/influxdb/releases/influxdb-1.7.1_linux_amd64.tar.gz
tar xvfz influxdb-1.7.1_linux_amd64.tar.gz
```

#### Linux Binaries (64-bit, static)
**SHA256**: `48099d178107b605c593e1ce85d55d47c3d764c717a682abf57f18c68f716054` 
```bash
wget https://dl.influxdata.com/influxdb/releases/influxdb-1.7.1-static_linux_amd64.tar.gz
tar xvfz influxdb-1.7.1-static_linux_amd64.tar.gz
```

#### Linux Binaries (32-bit)
**SHA256**: `ccbb05d57374024c51421d4e5be1bd03385262df0c58f7191ed17af680ad71af` 
```bash
wget https://dl.influxdata.com/influxdb/releases/influxdb-1.7.1_linux_i386.tar.gz
tar xvfz influxdb-1.7.1_linux_i386.tar.gz
```

#### Linux Binaries (ARM)
**SHA256**: `723c33b4cf7714fc0864d7a91de324e84427a25b1ca44eaa891bef82523e110a` 
```bash
wget https://dl.influxdata.com/influxdb/releases/influxdb-1.7.1_linux_armhf.tar.gz
tar xvfz influxdb-1.7.1_linux_armhf.tar.gz
```

> 原文地址：https://portal.influxdata.com/downloads