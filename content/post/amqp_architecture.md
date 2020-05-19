---
title: AMQP 架构介绍
author: Scott
tags:
  - AMQP
  - 协议
  - 消息队列
  - 架构设计
categories: []
date: 2019-07-11 11:23:00
---
AMQP 1.0 版本规定了三个主要部分的基本语义：**网络协议**、**消息协议** 和 **代理服务** 。

<!--more-->

### 概览
AMQP 1.0 版本将网络传输、代理（broker）和管理拆分开来，支持各种代理架构（broker），这些代理可以用于接收、排队、路由和传递消息，也可以用于点对点（peer-to-peer）。

![upload successful](/images/pasted-9.png)

### 网络协议

这种底层网络协议功能强大，但通常对于消息传递软件的用户是不可见的。 与电子邮件一样，用户向 target@example.com 发送邮件时，不会意识到中介节点是如何处理的。

也就是说，可以将此协议用于其他目的。但预计到目前为止，该协议的最大用途是将消息传递客户端连接到消息代理（托管队列和 topic 的 broker），消息代理负责存储，路由和交付。

![upload successful](/images/pasted-10.png)

### 消息表示
AMQP 1.0 版本的类型系统和消息编码工具为消息提供可移植的编码方案，以满系统之间的可移植性。

通常，AMQP编码仅用于将路由属性添加到消息的“头部”，消息体的内容不受影响。应用程序可能会在其消息内容中使用XML、JSON或类似编码。当然，也可以选择使用 AMQP 编码对消息内容进行编码。

### 代理服务
消息代理的主要任务是处理消息排队、路由和传递的复杂性。AMQP 定义了消息代理的最小需求集，目标是使应用程序能够通过代理服务发送消息。

> 名词解释：
> 
> * AMQP：Advanced Message Queuing Protocol
> * OASIS：Organization for the Advancement of Structured Information Standards

> 原文地址：https://www.amqp.org/product/architecture