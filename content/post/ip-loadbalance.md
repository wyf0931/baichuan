---
title: "IP负载均衡技术"
author: Scott
tags:
  - 架构设计
categories: 
  - LVS
date: 2020-06-24T15:00:48+08:00
draft: false
---

> 原文地址：http://zh.linuxvirtualserver.org/node/25

#### 概述

可伸缩网络服务的几种结构，它们都需要一个前端调度器。在调度器的实现技术中，IP负载均衡技术是效率最高的。在已有的IP负载均衡技术中有通过网络地址转换（Network Address Translation）将一组服务器构成一个高性能的、高可用的虚拟服务器，我们称之为VS/NAT技术（Virtual Server via Network Address Translation），大多数商品化的IP负载均衡调度器产品都是使用此方法，如Cisco的LocalDirector、F5的Big/IP和Alteon的ACEDirector。在分析VS/NAT的缺点和网络服务的非对称性的基础上，我们提出通过IP隧道实现虚拟服务器的方法VS/TUN（Virtual Server via IP Tunneling），和通过直接路由实现虚拟服务器的方法 VS/DR（Virtual Server via Direct Routing），它们可以极大地提高系统的伸缩性。

#### 三种IP负载均衡技术

本文将描述三种IP负载均衡技术：**VS/NAT**、**VS/TUN** 和 **VS/DR** 的工作原理，以及它们的优缺点。在以下描述中，我们称客户的 socket 和服务器的 socket 之间的数据通讯为连接，无论它们是使用 TCP 还是 UDP 协议。

* [通过NAT实现虚拟服务器（VS/NAT）](/post/ip-vs-nat/)
* [通过IP隧道实现虚拟服务器（VS/TUN）](/post/ip-vs-tun/)
* [通过直接路由实现虚拟服务器（VS/DR）](/post/ip-vs-dr/)

#### 三种方法的优缺点比较

三种IP负载均衡技术的优缺点归纳在下表中：

<table border="1" cellpadding="0" cellspacing="0"><tbody><tr><td width="175"> </td>
<td width="149"> VS/NAT </td>
<td width="140"> VS/TUN </td>
<td width="149"> VS/DR </td>
</tr><tr><td width="175"> Server </td>
<td width="149"> any </td>
<td width="140"> Tunneling </td>
<td width="149"> Non-arp device </td>
</tr><tr><td width="175"> server network </td>
<td width="149"> private </td>
<td width="140"> LAN/WAN </td>
<td width="149"> LAN </td>
</tr><tr><td width="175"> server number </td>
<td width="149"> low (10~20) </td>
<td width="140"> High (100) </td>
<td width="149"> High (100) </td>
</tr><tr><td> server gateway </td>
<td> load balancer </td>
<td width="140"> own router </td>
<td width="149"> Own router </td>
</tr></tbody></table>

注：以上三种方法所能支持最大服务器数目的估计是假设调度器使用100M网卡，调度器的硬件配置与后端服务器的硬件配置相同，而且是对一般Web服务。使用更高的硬件配置（如千兆网卡和更快的处理器）作为调度器，调度器所能调度的服务器数量会相应增加。当应用不同时，服务器的数目也会相应地改变。所以，以上数据估计主要是为三种方法的伸缩性进行量化比较。

#### 小结

本章主要讲述了可伸缩网络服务LVS框架中的三种IP负载均衡技术。在分析网络地址转换方法（VS/NAT）的缺点和网络服务的非对称性的基础上，我们给出了通过IP隧道实现虚拟服务器的方法VS/TUN，和通过直接路由实现虚拟服务器的方法VS/DR，极大地提高了系统的伸缩性。




