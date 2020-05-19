---
title: 在 Red Hat / CentOS 上安装 InfluxDB
author: Scott
tags:
  - InfluxDB
  - Linux
categories: []
date: 2019-07-03 14:47:00
---
本文介绍如何在 Red Hat 或 CentOS 上安装 InfluxDB。
<!--more-->

### 安装要求
InfluxDB 软件包的安装可能需要 `root` 或管理员权限才能顺利完成安装。

### 网络端口
InfluxDB 默认使用以下网络端口：

* TCP 端口 `8086` 用于通过 InfluxDB 的 HTTP API 进行客户端 - 服务器(C/S)通信；
* TCP 端口 `8088` 用于 RPC 服务进行备份和还原。
除了上面的端口，InfluxDB 还提供了多个可能需要[自定义端口](https://www.docs.influxdata.com/influxdb/v1.7/administration/ports/)的插件。可以通过[配置文件](https://www.docs.influxdata.com/influxdb/v1.7/administration/config)修改所有端口映射，该文件默认安装位于`/etc/influxdb/influxdb.conf`。

### 网络时间协议（NTP）
InfluxDB 使用主机的 UTC 本地时间为数据分配时间戳并用于进程协作。使用网络时间协议（Network Time Protocol , NTP）同步主机之间的时间；如果主机的时钟与 NTP 不同步，写入 InfluxDB 的数据的时间戳可能会不准确。

### 服务安装
Red Hat 和 CentOS 用户可以使用 `yum` 软件包管理器安装最新稳定版本的 InfluxDB：
```bash
cat <<EOF | sudo tee /etc/yum.repos.d/influxdb.repo
[influxdb]
name = InfluxDB Repository - RHEL \$releasever
baseurl = https://repos.influxdata.com/rhel/\$releasever/\$basearch/stable
enabled = 1
gpgcheck = 1
gpgkey = https://repos.influxdata.com/influxdb.key
EOF
```

将存储库添加到 `yum` 配置后，通过运行以下命令安装并启动 InfluxDB 服务：
```bash
sudo yum install influxdb
sudo service influxdb start
```
或者，如果您的操作系统使用的是 `systemd`（CentOS 7+，RHEL 7+)：
```bash
sudo yum install influxdb
sudo systemctl start influxdb
```
### 服务配置
系统内部为每个配置文件设置了默认值。使用 `Influxd config` 命令可以查看默认配置。

本地配置文件（`/etc/influxdb/influxdb.conf`）中的大多数设置都被注释掉了；所有注释掉的设置将由内部默认值兜底。本地配置文件中的任何未注释的设置都会覆盖内部默认值。请注意，本地配置文件不需要包含每项配置信息。

有两种方法可以使用您的配置文件启动 InfluxDB：
* 使用 `-config` 选项将进程指向正确的配置文件：
``` bash
influxd -config /etc/influxdb/influxdb.conf
```
* 将环境变量 `INFLUXDB_CONFIG_PATH` 设置为配置文件的路径并启动该进程。例如：
```bash
echo $INFLUXDB_CONFIG_PATH
/etc/influxdb/influxdb.conf

influxd
```
**InfluxDB 会先检查 `-config` 选项，然后检查环境变量。**

有关更多信息，请参阅[配置文档](https://www.docs.influxdata.com/influxdb/v1.7/administration/config/)。

### 数据与 WAL 目录权限
确保存储数据和 [write ahead log](https://www.docs.influxdata.com/influxdb/v1.7/concepts/glossary#wal-write-ahead-log) (WAL) 的目录对于运行 `influxd ` 服务的用户是可写的。

> 如果数据和WAL目录不可写，则 `influxd ` 服务会启动失败。

有关 `data` 和 `wal` 目录路径的信息，请参阅 InfluxDB [配置文档](https://www.docs.influxdata.com/influxdb/v1.7/administration/config/)的[数据设置](https://www.docs.influxdata.com/influxdb/v1.7/administration/config/#data-settings)部分。

> 官网地址：https://www.docs.influxdata.com/influxdb/v1.7/introduction/installation/ 

关于安装 RPM 软件包的问题，请参考[下载页面](https://influxdata.com/downloads/)。