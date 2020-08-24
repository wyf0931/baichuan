---
title: Spring Cloud Data Flow 安装指南
author: Scott
tags:
  - spring
  - data
categories:
  - 技术
date: 2019-07-01 11:40:00
---
本文主要介绍 Spring cloud dataflow 的二进制包在 Linux 环境的安装与启动。
<!--more-->

### 系统要求
* Java 8
* Maven
* RDBMS，关系型数据库（用来存储流定义和部署资源以及任务/批处理作业状态。默认情况下，Data Flow 服务采用嵌入式 H2 数据库，你可以改为其他数据库）；
* Redis （如果是分析类应用或运行单元测试 / 集成测试，可能会用到Redis）；
* MQ（RabbitMQ、Kafka，用于应用间通信）；
* Spring Cloud Skipper 服务（如果想在运行时升级和回滚应用程序，可以考虑装一个）。

### 安装步骤
1. 下载 Spring Cloud Data Flow Server 和 Shell ：
```bash
wget https://repo.spring.io/release/org/springframework/cloud/spring-cloud-dataflow-server-local/1.7.3.RELEASE/spring-cloud-dataflow-server-local-1.7.3.RELEASE.jar
```
```bash
wget https://repo.spring.io/release/org/springframework/cloud/spring-cloud-dataflow-shell/1.7.3.RELEASE/spring-cloud-dataflow-shell-1.7.3.RELEASE.jar
```
自 1.3.x 开始，Data Flow Server 可以运行在 `skipper ` 和 `classic` 两种模式。`classic` 模式指 Data Flow Server 以 1.2.x 版运行。可以在 Data Flow Server 启动前在属性文件中通过 `spring.cloud.dataflow.features.skipper-enabled` 来指定。**默认情况下采用 `classic` 模式。**

2. 如果你想要在Stream 中升级、回滚应用的功能，可以下载 [Skipper](http://cloud.spring.io/spring-cloud-skipper/)，Data Flow 已经把这些功能委派给 Skipper 了。

```bash
wget https://repo.spring.io/release/org/springframework/cloud/spring-cloud-skipper-server/1.1.2.RELEASE/spring-cloud-skipper-server-1.1.2.RELEASE.jar
```

```bash
wget https://repo.spring.io/release/org/springframework/cloud/spring-cloud-skipper-shell/1.1.2.RELEASE/spring-cloud-skipper-shell-1.1.2.RELEASE.jar
```

3. 用 `java -jar` 命令启动 Skipper（如果 Spring Cloud Data Flow 以 `skipper` 模式运行）：

```bash
java -jar spring-cloud-skipper-server-1.1.2.RELEASE.jar
```

4. 通过 `java -jar` 命令以 `classic` 模式启动 Data Flow Server ：
```bash
java -jar spring-cloud-dataflow-server-local-1.7.3.RELEASE.jar
```
或以 `skipper` 模式启动：
```bash
java -jar spring-cloud-dataflow-server-local-1.7.3.RELEASE.jar --spring.cloud.dataflow.features.skipper-enabled=true
```
如果 Skipper 和 Data Flow Server 不在同一台机器上运行，可以在配置文件中通过 `spring.cloud.skipper.client.serverUri` 来指向Skipper：
```bash
java -jar spring-cloud-dataflow-server-local-1.7.3.RELEASE.jar --spring.cloud.skipper.client.serverUri=http://192.51.100.1:7577/api
```

5. 启动 Data Flow Shell时需要指定 Data Flow Server 的运行模式，例如以 `classic ` 模式启动：
```bash
java -jar spring-cloud-dataflow-shell-1.7.3.RELEASE.jar
```
或以 `skipper` 模式启动：
```bash
java -jar spring-cloud-dataflow-shell-1.7.3.RELEASE.jar --dataflow.mode=skipper
```
**注意：Data Flow Server 和 Data Flow Shell 启动时必须采用同一种模式。**
如果 Data Flow Server 和 Shell 不在同一台机器上运行，可以在Data Flow Shell 命令行中通过 `dataflow config server` 命令指定 Data Flow Server URL，如下所示：
```bash
server-unknown:>dataflow config server http://198.51.100.0
Successfully targeted http://198.51.100.0
dataflow:>
```
此外，也可以通过 `--dataflow.uri` 参数来指定，可以在 Data Flow Shell 中用 `--help` 选项来查看帮助。

> 
> * [Spring cloud dataflow Release 文档](https://docs.spring.io/spring-cloud-> dataflow/docs/1.7.3.RELEASE/reference/htmlsingle)
> * [Spring cloud dataflow Snapshot 文档](https://docs.spring.io/spring-cloud-dataflow/docs/current-SNAPSHOT/reference/html/)

原文地址：http://docs.spring.io/spring-cloud-dataflow/docs/current/reference/htmlsingle/