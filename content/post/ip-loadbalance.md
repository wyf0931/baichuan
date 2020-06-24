---
title: "IP负载均衡技术"
author: Scott
tags:
  - LVS
categories: 
  - 架构设计
date: 2020-06-24T15:00:48+08:00
draft: true
---

### 概述

可伸缩网络服务的几种结构，它们都需要一个前端调度器。在调度器的实现技术中，IP负载均衡技术是效率最高的。在已有的IP负载均衡技术中有通过网络地址转换（Network Address Translation）将一组服务器构成一个高性能的、高可用的虚拟服务器，我们称之为VS/NAT技术（Virtual Server via Network Address Translation），大多数商品化的IP负载均衡调度器产品都是使用此方法，如Cisco的LocalDirector、F5的Big/IP和Alteon的ACEDirector。在分析VS/NAT的缺点和网络服务的非对称性的基础上，我们提出通过IP隧道实现虚拟服务器的方法VS/TUN（Virtual Server via IP Tunneling），和通过直接路由实现虚拟服务器的方法 VS/DR（Virtual Server via Direct Routing），它们可以极大地提高系统的伸缩性。

本文将描述三种IP负载均衡技术：**VS/NAT**、**VS/TUN** 和 **VS/DR** 的工作原理，以及它们的优缺点。在以下描述中，我们称客户的 socket 和服务器的 socket 之间的数据通讯为连接，无论它们是使用 TCP 还是 UDP 协议。

### 目录

* [通过NAT实现虚拟服务器（VS/NAT）](http://zh.linuxvirtualserver.org/node/26)
* [通过IP隧道实现虚拟服务器（VS/TUN）](http://zh.linuxvirtualserver.org/node/27)
* [通过直接路由实现虚拟服务器（VS/DR）](http://zh.linuxvirtualserver.org/node/28)
* [三种方法的优缺点比较](http://zh.linuxvirtualserver.org/node/29)

### 小结

本章主要讲述了可伸缩网络服务LVS框架中的三种IP负载均衡技术。在分析网络地址转换方法（VS/NAT）的缺点和网络服务的非对称性的基础上，我们给出了通过IP隧道实现虚拟服务器的方法VS/TUN，和通过直接路由实现虚拟服务器的方法VS/DR，极大地提高了系统的伸缩性。



