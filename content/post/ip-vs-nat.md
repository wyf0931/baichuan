---
title: "通过NAT实现虚拟服务器（VS/NAT）"
author: Scott
tags:
  - 架构设计
  - LVS
categories:
  - 技术
date: 2020-06-24T15:27:24+08:00
draft: false
---

> 原文地址：http://zh.linuxvirtualserver.org/node/26

由于IPv4 中 IP地址空间的日益紧张和安全方面的原因，很多网络使用保留IP地址（`10.0.0.0/255.0.0.0`、`172.16.0.0/255.240.0.0`和`192.168.0.0/255.255.0.0`）`[64, 65, 66]`。这些地址不在Internet上使用，而是专门为内部网络预留的。当内部网络中的主机要访问Internet或被Internet访问时，就需要采用**网络地址转换（Network Address Translation, 以下简称NAT），将内部地址转化为Internets上可用的外部地址。NAT的工作原理是报文头（目标地址、源地址和端口等）被正确改写后，客户相信它们连接一个IP地址，而不同IP地址的服务器组也认为它们是与客户直接相连的。**由此，可以用NAT方法将不同IP地址的并行网络服务变成在一个IP地址上的一个虚拟服务。

VS/NAT 的体系结构如图3.1所示。在一组服务器前有一个调度器，它们是通过 Switch/HUB 相连接的。这些服务器提供相同的网络服务、相同的内容，即不管请求被发送到哪一台服务器，执行结果是一样的。服务的内容可以复制到每台服务器的本地硬盘上，可以通过网络文件系统（如NFS）共享，也可以通过一个分布式文件系统来提供。

![图3.1：VS/NAT的体系结构](https://blog-1252438081.cos.ap-shanghai.myqcloud.com/img/vs-nat.jpg)

客户通过 Virtual IP Address（虚拟服务的IP地址）访问网络服务时，请求报文到达调度器，调度器根据连接调度算法从一组真实服务器中选出一台服务器，将报文的目标地址Virtual IP Address改写成选定服务器的地址，报文的目标端口改写成选定服务器的相应端口，最后将修改后的报文发送给选出的服务器。同时，调度器在连接Hash表中记录这个连接，当这个连接的下一个报文到达时，从连接Hash表中可以得到原选定服务器的地址和端口，进行同样的改写操作，并将报文传给原选定的服务器。当来自真实服务器的响应报文经过调度器时，调度器将报文的源地址和源端口改为 Virtual IP Address 和相应的端口，再把报文发给用户。我们在连接上引入一个状态机，不同的报文会使得连接处于不同的状态，不同的状态有不同的超时值。

在TCP连接中，根据标准的TCP有限状态机进行状态迁移；在UDP中，我们只设置一个UDP状态。不同状态的超时值是可以设置的，在默认情况下：

* *SYN* 状态的超时为1分钟；

* *ESTABLISHED* 状态的超时为15分钟；

* *FIN* 状态的超时为1分钟；

* *UDP* 状态的超时为5分钟。


当连接终止或超时，调度器将这个连接从连接Hash表中删除。



这样，客户所看到的只是在Virtual IP Address上提供的服务，而服务器集群的结构对用户是透明的。对改写后的报文，应用增量调整Checksum的算法调整TCP Checksum的值，避免了扫描整个报文来计算Checksum的开销。

在一些网络服务中，它们将IP地址或者端口号在报文的数据中传送，若我们只对报文头的IP地址和端口号作转换，这样就会出现不一致性，服务会中断。所以，针对这些服务，需要编写相应的应用模块来转换报文数据中的IP地址或者端口号。我们所知道有这个问题的网络服务有：FTP、IRC、H.323、CUSeeMe、Real Audio、Real Video、Vxtreme / Vosiac、VDOLive、VIVOActive、True Speech、RSTP、PPTP、StreamWorks、NTT AudioLink、NTT SoftwareVision、Yamaha MIDPlug、iChat Pager、Quake和Diablo。



下面，举个例子来进一步说明VS/NAT，如图3.2所示：

![图3.2：VS/NAT的例子](https://blog-1252438081.cos.ap-shanghai.myqcloud.com/img/vs-nat-example.jpg)

VS/NAT 的配置如下表所示，所有到IP地址为 `202.103.106.5` 和端口为 `80` 的流量都被负载均衡地调度的真实服务器 `172.16.0.2:80` 和 `172.16.0.3:8000` 上。目标地址为 `202.103.106.5:21` 的报文被转移到 `172.16.0.3:21` 上。而到其他端口的报文将被拒绝。

<table border="1" cellpadding="0" cellspacing="0">
<tbody><tr><td valign="top" width="103"> Protocol </td>
<td valign="top" width="173"> Virtual IP Address </td>
<td valign="top" width="58"> Port </td>
<td valign="top" width="167"> Real IP Address </td>
<td valign="top" width="58"> Port </td>
<td valign="top" width="84"> Weight </td>
</tr><tr><td rowspan="2" valign="top" width="103"> TCP </td>
<td rowspan="2" valign="top" width="173"> 202.103.106.5 </td>
<td rowspan="2" valign="top" width="58"> 80 </td>
<td valign="top" width="167"> 172.16.0.2 </td>
<td valign="top" width="58"> 80 </td>
<td valign="top" width="84"> 1 </td>
</tr><tr><td valign="top" width="167"> 172.16.0.3 </td>
<td valign="top" width="58"> 8000 </td>
<td valign="top" width="84"> 2 </td>
</tr><tr><td valign="top" width="103"> TCP </td>
<td valign="top" width="173"> 202.103.106.5 </td>
<td valign="top" width="58"> 21 </td>
<td valign="top" width="167"> 172.16.0.3 </td>
<td valign="top" width="58"> 21 </td>
<td valign="top" width="84"> 1 </td>
</tr></tbody></table>
从以下的例子中，我们可以更详细地了解报文改写的流程。

访问Web服务的报文可能有以下的源地址和目标地址：

<table border="1" cellpadding="0" cellspacing="0"><tbody><tr><td valign="top" width="149"> SOURCE </td>
<td valign="top" width="175"> 202.100.1.2:3456 </td>
<td valign="top" width="158"> DEST </td>
<td valign="top" width="166"> 202.103.106.5:80 </td>
</tr></tbody></table>
调度器从调度列表中选出一台服务器，例如是172.16.0.3:8000。该报文会被改写为如下地址，并将它发送给选出的服务器。

<table border="1" cellpadding="0" cellspacing="0"><tbody><tr><td valign="top" width="149"> SOURCE </td>
<td valign="top" width="175"> 202.100.1.2:3456 </td>
<td valign="top" width="158"> DEST </td>
<td valign="top" width="166"> 172.16.0.3:8000 </td>
</tr></tbody></table>
从服务器返回到调度器的响应报文如下：

<table border="1" cellpadding="0" cellspacing="0"><tbody><tr><td valign="top" width="149"> SOURCE </td>
<td valign="top" width="175"> 172.16.0.3:8000 </td>
<td valign="top" width="158"> DEST </td>
<td valign="top" width="166"> 202.100.1.2:3456 </td>
</tr></tbody></table>
响应报文的源地址会被改写为虚拟服务的地址，再将报文发送给客户：

<table border="1" cellpadding="0" cellspacing="0"><tbody><tr><td valign="top" width="149"> SOURCE </td>
<td valign="top" width="175"> 202.103.106.5:80 </td>
<td valign="top" width="158"> DEST </td>
<td valign="top" width="166"> 202.100.1.2:3456 </td>
</tr></tbody></table>
这样，客户认为是从202.103.106.5:80服务得到正确的响应，而不会知道该请求是服务器172.16.0.2还是服务器172.16.0.3处理的。