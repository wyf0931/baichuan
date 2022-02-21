---
title: 在 Linux 上用 Docker 安装 Portainer-CE
identifier: install-portainer-ce-on-linux
author: Scott
date: 2022-02-21T06:29:44.737Z
tags:
  - Docker
categories:
  - 技术
---
Portainer 由两部分组成：Portainer Server、Portainer Agent。这两部分在 Docker 引擎上作为轻量级 Docker 容器运行。此文主要介绍是在 Linux 环境中安装 Portainer Server 容器。

<!--more-->



### 准备工作

1、在机器上装好最新版的 Docker 并启动起来；

2、要部署 Portainer Server 的机器必须要有 sudo 权限；

3、默认情况下，Portainer Server 将**通过端口 9443 来访问 Web 页面**，并通过端口8000公开 TCP 隧道服务（这个是可配置的，只有在计划使用 Edge 代理程序计算边缘特性时才需要。）



### 部署步骤

1、首先，创建 Portainer Server 用来存储数据库的卷（volume）:

```bash
docker volume create portainer_data
```

2、下载并安装 Portainer Server 容器:

```bash
docker run -d -p 8000:8000 -p 9443:9443 --name portainer \
    --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    portainer/portainer-ce:latest
```

> 默认情况下，Portainer 生成并使用自签名的 SSL 证书来保护端口 9443。或者，您可以在安装过程中提供自己的 SSL 证书，或者在安装完成后通过 Portainer UI 提供。

已经安装了 Portainer Server。你可以通过运行 docker ps 来检查 Portainer Server 容器是否已经启动:

```bash
root@server:~# docker ps
CONTAINER ID   IMAGE                           COMMAND        CREATED         STATUS         PORTS                                                                                            NAMES
58505d965704   portainer/portainer-ce:latest   "/portainer"   3 seconds ago   Up 3 seconds   0.0.0.0:8000->8000/tcp, :::8000->8000/tcp, 0.0.0.0:9443->9443/tcp, :::9443->9443/tcp, 9000/tcp   portainer
```

### 登录

现在安装已经完成，可以在浏览器中打开这个地址：https://localhost:9443 ，将看到 Portainer Server 的初始设置页面。

> 如果需要，用相关的 IP 地址或 FQDN 替换本地主机，如果更早更改了端口，则调整端口。



初始化配置页面如下：

<img src="https://blog-1252438081.cos.ap-shanghai.myqcloud.com/img/image-20220221142545782.png" alt="初始化配置页面" style="zoom: 67%;" />

输入两次密码（**密码长度最少8位**），然后点击 【**Create user**】按钮即可进入主页：

<img src="https://blog-1252438081.cos.ap-shanghai.myqcloud.com/img/image-20220221142806359.png" alt="image-20220221142806359" style="zoom:67%;" />