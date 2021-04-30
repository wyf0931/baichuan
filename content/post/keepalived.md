---
title: "Keepalived"
author: Scott
tags:
  - 高可用
categories:
  - 技术
date: 2020-06-24T16:43:03+08:00
draft: false
---

### 什么是 Keepalived ？

Keepalived 是一个用 C 语言编写的路由软件。 这个项目的主要目标是**为 Linux 系统和基于 Linux 的基础设施提供简单、健壮的负载均衡和高可用性基础设施。 负载均衡框架依赖于 [Linux Virtual Server (IPVS)](http://www.linux-vs.org/) 内核模块，提供了4层负载均衡。** Keepalived 实现了一组检查器，根据服务器池中服务器的健康状况动态地、自适应地维护和管理它们。 另一方面通过 [VRRP](http://datatracker.ietf.org/wg/vrrp/) 协议实现高可用性。 VRRP 是路由器故障转移的基本单元。 此外，Keepalived 实现了一组与 VRRP 有限状态机的挂钩（hooks），提供低级和高速的交互协议。为了提供最快的网络故障检测，Keepalived 实现了 [BFD](http://datatracker.ietf.org/wg/bfd/) 协议。 VRRP 状态转换可以考虑 BFD 提示来驱动快速状态转换。 Keepalived 框架可以单独使用，也可以一起使用，以提供弹性基础设施。

Keepalived 是免费软件，你可以根据自由软件基金会发布的GNU通用公共许可证的条款重新分发或修改它。

### 相关链接

* 官网：https://keepalived.org/
* 下载：https://keepalived.org/download.html
* 配置手册：https://keepalived.org/manpage.html