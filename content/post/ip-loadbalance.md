---
title: "【转】IP负载均衡技术"
author: Scott
tags:
  - 架构设计
  - LVS
categories:
  - 技术
date: 2020-06-24T15:00:48+08:00
draft: false
---

> 原文地址：http://zh.linuxvirtualserver.org/node/25

#### 概述

**在可伸缩网络服务的几种架构中，都需要一个前端调度器。在调度器的实现技术中，IP负载均衡技术是效率最高的。**

在已有的IP负载均衡技术中，有通过网络地址转换（Network Address Translation）将一组服务器构成一个高性能的、高可用的虚拟服务器，我们称之为 `VS/NAT` 技术（Virtual Server via Network Address Translation），大多数商业化的IP负载均衡调度器都是使用此方案，如 Cisco 的 LocalDirector、F5 的 Big/IP 和 Alteon 的 ACEDirector。

在分析 VS/NAT 的缺点和网络服务的非对称性的基础上，提出了以下方案：

1. 通过IP隧道（IP Tunneling）实现虚拟服务器的方案 VS/TUN（Virtual Server via IP Tunneling）；
2. 通过直接路由（Direct Routing）实现虚拟服务器的方案 VS/DR（Virtual Server via Direct Routing）；

它们可以极大地提高系统的伸缩性。

#### 三种IP负载均衡技术

本文将介绍三种IP负载均衡技术：**VS/NAT**、**VS/TUN** 和 **VS/DR** 的工作原理，以及它们的优缺点。在以下介绍中，我们称客户端的 socket 和服务器的 socket 之间的数据通讯为连接，无论它们是使用 TCP 还是 UDP 协议。

* [通过NAT实现虚拟服务器（VS/NAT）](/post/ip-vs-nat/)
* [通过IP隧道实现虚拟服务器（VS/TUN）](/post/ip-vs-tun/)
* [通过直接路由实现虚拟服务器（VS/DR）](/post/ip-vs-dr/)

#### 三种方案的优缺点比较

三种IP负载均衡技术的优缺点归纳在下表中：

|                    | VS/NAT        | VS/TUN     | VS/DR          |
| ------------------ | ------------- | ---------- | -------------- |
| **Server**         | any           | Tunneling  | Non-arp device |
| **Server network** | private       | LAN/WAN    | LAN            |
| **Server number**  | Low (10~20)   | High (100) | High (100)     |
| **Server gateway** | Load balancer | Own router | Own router     |

> 备注：
>
> 以上三种方案所能支持最大服务器数目的预估假设如下：
>
> - 调度器使用100M网卡；
> - 调度器的硬件配置与后端服务器的硬件配置相同；
> - 针对一般Web服务；
>
> 因此，使用更高的硬件配置（如千兆网卡和更快的处理器）作为调度器，调度器所能调度的服务器数量会相应增加。当应用（application）不同时，服务器的数目也会相应地改变。所以，以上数据估计主要是为三种方法的伸缩性进行量化比较。

#### 小结

本文主要讲述了可伸缩网络服务 LVS 框架中的三种IP负载均衡技术。在分析网络地址转换方案（VS/NAT）的缺点和网络服务的非对称性的基础上，给出了通过IP隧道实现虚拟服务器的方案（VS/TUN），和通过直接路由实现虚拟服务器方案（VS/DR），极大地提高了系统的伸缩性。




