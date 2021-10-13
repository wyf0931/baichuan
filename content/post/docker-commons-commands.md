---
title: "Docker 常用命令"
date: 2021-08-31T10:59:54+08:00
author: Scott
tags:
  - Docker
categories:
  - 技术
draft: false
---

本文记录了一些常用的Docker 命令，作为操作手册，方便日常使用。

<!--more-->

说明：本文中都以nginx为案例。

## 一、镜像相关操作

#### 1.1 拉取镜像

```bash
docker pull nginx:latest
```

#### 1.2 查看镜像列表

```bash
docker images
```

说明：`REPOSITORY` 就是镜像名称。
![image-20210831120942577](https://blog-1252438081.cos.ap-shanghai.myqcloud.com/img/image-20210831120942577.png)

#### 1.3 删除镜像

```bash
docker rmi 698e0fb19402
```

说明：`698e0fb19402` 是镜像ID，可以用 `docker images` 来查看镜像ID；

## 二、容器相关操作

#### 2.1 运行容器

以启动 nginx 为例：

```
docker run -d -p 8080:80 --name nginx-demo \
  -v /home/demo/app/nginx/www:/usr/share/nginx/html \
  -v /home/demo/app/nginx/conf/nginx.conf:/etc/nginx/nginx.conf \
  -v /home/demo/app/nginx/logs:/var/log/nginx \
  nginx
```

说明：

- `-p` ：本地 `8080` 映射到容器中的 `80` 端口；
- `-v` ：本地 `/home/demo/app/nginx/www` 文件路径挂载到容器中的 `/usr/share/nginx/html`；
- `--name` ：指定容器名称为 `nginx-demo`；
- `-d` ：容器在后台运行；
-  `nginx` ：最后的那个 `nginx` 指的是镜像名称，可以用 `docker images` 来查看；

#### 2.2 停止容器

```
docker stop nginx-demo
```

#### 2.3 启动容器

```bash
docker start nginx-demo
```

#### 2.4 删除容器

```bash
docker rm 5d45a9dfbaad
```

说明：`5d45a9dfbaad` 是容器ID，可以用 `docker ps -a` 查看容器ID；

#### 2.5 从容器中复制文件到宿主机

```bash
docker cp nginx-demo:/etc/nginx/nginx.conf ~/app/nginx/conf/
```

说明：

* `nginx-demo` 是容器名称，也就是启动容器时 `--name` 参数后面的名称；
* 不管容器有没有启动，拷贝命令都会生效；

#### 2.6 从宿主机拷文件到容器里面

```bash
docker cp ~/app/nginx/conf/demo.conf nginx-demo:/etc/nginx/conf.d/demo.conf
```

#### 2.7 查看容器信息

```bash
docker ps -a
```

说明：`-a` 参数会展示全部容器信息，包括已经停止的。

输出内容如下：

![image-20210831120902794](https://blog-1252438081.cos.ap-shanghai.myqcloud.com/img/image-20210831120902794.png)

#### 2.8 进入容器内部命令行：

```bash
docker exec -it nginx-demo /bin/bash
```
说明： `nginx-demo` 是容器名称；
![image-20210831122527235](https://blog-1252438081.cos.ap-shanghai.myqcloud.com/img/image-20210831122527235.png)

## 三、系统信息

#### 3.1 查看docker信息

```bash
docker info
```

