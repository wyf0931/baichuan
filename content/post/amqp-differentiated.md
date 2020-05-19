---
title: AMQP 与其他中间件标准之间的差异
author: Scott
tags:
  - AMQP
  - 协议
categories: []
date: 2019-07-11 15:02:00
---
### 与其他标准之间的差异
AMQP 与其他中间件标准的不同之处主要有：

* **互操作性（INTEROPERABLE）** 所有 AMQP 客户端与服务端均可进行互操作。不同的编程语言可以轻松地进行通信。为了从网络中删除专有协议，可以对旧的消息代理（broker）进行改造。可以将消息传递作为云服务启用。
* **可靠（RELIABLE）** 能够消除企业内外系统以及不同平台、业务系统、应用程序组件之间的通信速度差距。
* **统一化（UNIFIED）** 通过一个可管理的协议提供一组核心的消息传递模式。
* **全面（COMPLETE）** JMS 用 Java 语言为应用程序协议提供了 API。AMQP 为使用该 API 的应用程序提供线路级传输。AMQP 具有广泛的适用性，可以用任何语言实现，在统一规范中展现存储-转发和发布-订阅语义。
* **公开（OPEN）** 由用户和技术提供商合作创建，没有明确的供应商和平台。
* **安全（SAFE）** 通过安全解决方案，保障重要消息可以在企业、技术平台和虚拟云计算环境之间传输。

### 用 AMQP 实现 SOA


![upload successful](/images/pasted-11.png)

* AMQP 采用了 TCP/IP 进行传输，提供可靠的连接； 
* 可以利用 XML 提供统一的数据编码； 
* 可以利用 XML schema 提供元数据规范； 
* 可以利用 SOAP 提供预期的消息交换模式； 
* 可以利用 Web Service 标准提供业务契约表示。

> 名词解释：
> 
> 1. SOA ：Service Oriented Architecture，面向服务的架构
> 2. Expected Message Exchange Patterns ：预期的消息交换模式 
> 3. SOAP ：Simple Object Access Protocol，简单对象访问协议
