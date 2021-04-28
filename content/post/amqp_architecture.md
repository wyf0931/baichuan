---
title: AMQP 架构介绍
author: Scott
tags:
  - AMQP
  - 协议
  - 消息队列
  - 架构设计
categories:
  - 技术
date: 2019-07-11 11:23:00
---
AMQP 1.0 版本规定了三个主要部分的基本语义：**网络协议**、**消息协议** 和 **代理服务** 。

<!--more-->

### 一、概览
AMQP 1.0 版本将网络传输、代理（broker）和管理拆分开来，支持各种代理架构（broker），这些代理可以用于接收、排队、路由和传递消息，也可以用于点对点（peer-to-peer）。

![upload successful](https://blog-1252438081.cos.ap-shanghai.myqcloud.com/img/pasted-9.png)

### 二、网络协议

这种底层网络协议功能强大，但通常对于消息传递软件的用户是不可见的。 与电子邮件一样，用户向 target@example.com 发送邮件时，不会意识到中介节点是如何处理的。

也就是说，可以将此协议用于其他目的。但预计到目前为止，该协议的最大用途是将消息传递客户端连接到消息代理（托管队列和 topic 的 broker），消息代理负责存储，路由和交付。

![upload successful](https://blog-1252438081.cos.ap-shanghai.myqcloud.com/img/pasted-10.png)

### 三、消息表示
AMQP 1.0 版本的类型系统和消息编码工具为消息提供可移植的编码方案，以满系统之间的可移植性。

通常，AMQP编码仅用于将路由属性添加到消息的“头部”，消息体的内容不受影响。应用程序可能会在其消息内容中使用XML、JSON或类似编码。当然，也可以选择使用 AMQP 编码对消息内容进行编码。

### 四、代理服务
消息代理的主要任务是处理消息排队、路由和传递的复杂性。AMQP 定义了消息代理的最小需求集，目标是使应用程序能够通过代理服务发送消息。

### 五、与其他标准之间的差异
AMQP 与其他中间件标准的不同之处主要有：

* **互操作性（INTEROPERABLE）** 所有 AMQP 客户端与服务端均可进行互操作。不同的编程语言可以轻松地进行通信。为了从网络中删除专有协议，可以对旧的消息代理（broker）进行改造。可以将消息传递作为云服务启用。
* **可靠（RELIABLE）** 能够消除企业内外系统以及不同平台、业务系统、应用程序组件之间的通信速度差距。
* **统一化（UNIFIED）** 通过一个可管理的协议提供一组核心的消息传递模式。
* **全面（COMPLETE）** JMS 用 Java 语言为应用程序协议提供了 API。AMQP 为使用该 API 的应用程序提供线路级传输。AMQP 具有广泛的适用性，可以用任何语言实现，在统一规范中展现存储-转发和发布-订阅语义。
* **公开（OPEN）** 由用户和技术提供商合作创建，没有明确的供应商和平台。
* **安全（SAFE）** 通过安全解决方案，保障重要消息可以在企业、技术平台和虚拟云计算环境之间传输。

### 六、用 AMQP 实现 SOA

![upload successful](https://blog-1252438081.cos.ap-shanghai.myqcloud.com/img/pasted-11.png)

* AMQP 采用了 TCP/IP 进行传输，提供可靠的连接； 
* 可以利用 XML 提供统一的数据编码； 
* 可以利用 XML schema 提供元数据规范； 
* 可以利用 SOAP 提供预期的消息交换模式； 
* 可以利用 Web Service 标准提供业务契约表示。


> 名词解释：
> 1. SOA ：Service Oriented Architecture，面向服务的架构
> 2. Expected Message Exchange Patterns ：预期的消息交换模式 
> 3. SOAP ：Simple Object Access Protocol，简单对象访问协议
> 4. AMQP：Advanced Message Queuing Protocol
> 5. OASIS：Organization for the Advancement of Structured Information Standards

> 原文地址：https://www.amqp.org/product/architecture