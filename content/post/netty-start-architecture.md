---
title: "Netty 架构概览"
date: 2020-10-10T10:20:34+08:00
author: Scott
tags:
  - Netty
categories:
  - 技术
---

在本文中，我们将了解 Netty 提供了哪些核心功能，以及它们如何在核心之上组成一个完整的网络应用程序开发栈。下图是Netty总体架构示意图，在读本文时对照此图有助于理解。

![The Architecture Diagram of Netty](https://blog-1252438081.cos.ap-shanghai.myqcloud.com/img/architecture.png)

### 1. 多种 Buffer 数据结构

Netty 用自己的 buffer API 代替了 NIO 的 `ByteBuffer` 来表示字节序列。Netty 的缓冲区类型 [ChannelBuffer](http://static.netty.io/3.5/api/org/jboss/netty/buffer/ChannelBuffer.html) 是为了解决 `ByteBuffer` 的问题和满足开发者的日常需求而设计的。下面列举一些特色功能:

* 支持自定义缓冲区类型；
* 内置的复合缓冲区类型实现了透明零拷贝；
* 动态缓冲区类型是开箱即用的，容量可以按需扩展，类似于 `StringBuffer`；
* 无需调用 `flip()` ；
* 比 `ByteBuffer` 更快；

更多信息，请参考 `org.jboss.netty.buffer` 包描述。

#### 1.1. ChannelBuffers 组合和切片

在通信层之间传输数据时，通常需要对数据进行组合或分片。例如，如果一个有效 payload 分散在多个包中，通常需要将其组合起来进行解码。一般情况下，来自多个包的数据通过将它们复制到一个新的缓冲区来组合。Netty 支持零拷贝方法，通过 `ChannelBuffer` “指针”指向所需的缓冲区，从而消除了执行拷贝的需要。

![Combining and Slicing ChannelBuffers](https://blog-1252438081.cos.ap-shanghai.myqcloud.com/img/combine-slice-buffer.png)

### 2. 通用异步 I/O API

Java 中 I/O API 的已知问题：

* 未提供通用的传输类型。例如TCP（`java.net.Socket`）和 UDP（`java.net.DatagramSocket`）没有父类，导致传输层几乎无法移植或切换；
* 新老 I/O 的 API 不兼容。NIO 不兼容 OIO（阻塞式IO），并且新版的 NIO.2（AIO）也不兼容OIO，这会导致OIO 相关代码改造成本很高。

Netty 设计了一套通用的异步 I/O 接口，称为 [Channel](http://static.netty.io/3.5/api/org/jboss/netty/channel/Channel.html)，它抽象出点对点通信所需的所有操作。Netty 通过一个通用 API 提供了许多基础的传输能力：

* 基于 NIO 的 TCP/IP 传输（参见 `org.jboss.net ty.channel.socket.nio`）；
* 基于 OIO 的 TCP/IP 传输（参见 `org.jboss.netty.channel.socket.oio`）；
* 基于 OIO 的 UDP/IP 传输；
* 本地传输（参考 `org.jboss.netty.channel.local`）；

从一个传输切换到另一个传输通常只需要几行修改，比如选择不同的 [ChannelFactory](http://static.netty.io/3.5/api/org/jboss/netty/channel/ChannelFactory.html) 实现。

此外，您可以通过扩展核心 API 编写自己的传输方式。

### 3. 基于拦截器链模式的事件模型

对于事件驱动的应用程序来说，一个定义良好且可扩展的事件模型是必须的。Netty 允许在不破坏现有代码的情况下实现自己的事件类型，因为每个事件类型都是通过严格的类型层次结构来区分的。这是与其他框架的另一个不同之处。许多 NIO 框架没有或者只有非常有限的事件模型概念。如果它们提供扩展，那么在尝试添加自定义事件类型时，它们通常会破坏现有代码。

 由 [ChannelPipeline](http://static.netty.io/3.5/api/org/jboss/netty/channel/ChannelHandler.html) 中的 [ChannelHandlers](http://static.netty.io/3.5/api/org/jboss/netty/channel/ChannelPipeline.html) 列表处理。管道（pipeline）实现了[拦截过滤器](http://java.sun.com/blueprints/corej2eepatterns/Patterns/InterceptingFilter.html)模式的高级形式，使用户能够完全控制事件的处理方式以及管道中的处理程序之间的交互方式。

例如，可以定义从 socket 读取数据时应该做什么：

```java
public class MyReadHandler implements SimpleChannelHandler {
    public void messageReceived(ChannelHandlerContext ctx, MessageEvent evt) {
            Object message = evt.getMessage();
        // Do something with the received message.
        ...

        // And forward the event to the next handler.
        ctx.sendUpstream(evt);
    }
}
```

当处理程序接收到写请求时，你也可以定义该做什么:

```java
public class MyWriteHandler implements SimpleChannelHandler {
    public void writeRequested(ChannelHandlerContext ctx, MessageEvent evt) {
        Object message = evt.getMessage();
        // Do something with the message to be written.
        ...

        // And forward the event to the next handler.
        ctx.sendDownstream(evt);
    }
}
```
> 相关 API 链接：
> * [SimpleChannelHandler](http://static.netty.io/3.5/api/org/jboss/netty/channel/SimpleChannelHandler.html)
> * [ChannelHandlerContext](http://static.netty.io/3.5/api/org/jboss/netty/channel/ChannelHandlerContext.html)
> * [MessageEvent](http://static.netty.io/3.5/api/org/jboss/netty/channel/MessageEvent.html)

### 4. 可以加速开发进度高级组件

除了上面提到的核心组件之外，Netty 还提供了一系列高级特性，可以进一步加快开发速度。

#### 4.1 编解码框架

正如第8节 [“使用 POJO 而不是 ChannelBuffer”](https://netty.io/3.8/guide/#start.pojo) 中所演示的那样，将协议编码解码器与业务逻辑分离总是一个好主意。然而，当从零开始实施这个想法时，会有一些复杂的问题。您必须处理消息的碎片。有些协议是多层次的(即构建在其他低层协议之上)。有些功能过于复杂，无法在单个状态机中实现。

因此，一个好的网络应用程序框架应该提供一个可扩展的、可重用的、可单元测试的、多层次的编解码器框架来生成可维护的用户编解码器。

Netty 提供了许多基本的和高级的编解码器来解决您在编写协议编解码器时遇到的大多数问题，无论它是简单的还是非简单的，二进制的还是文本的。

#### 4.2 SSL/TLS 支持

与旧的阻塞 I/O 不同，在 NIO 中支持 SSL 是一项非常重要的任务。不能简单地封装一个流来加密或解密数据，但必须使用 `javax.net.ssl.SSLEngine`。`SSLEngine` 是一个状态机，它和 SSL 本身一样复杂。您必须管理所有可能的状态，例如密码套件和加密密钥协商(或重新协商)、证书交换和验证。此外，`SSLEngine` 甚至不像人们预期的那样完全是线程安全的。 

在 Netty 中，[SslHandler](http://static.netty.io/3.5/api/org/jboss/netty/handler/ssl/SslHandler.html) 处理 SSLEngine 的所有血淋淋的细节和缺陷。您所需要做的就是配置 `SslHandler` 并将其插入到 `ChannelPipeline` 中。它还允许您非常容易地实现诸如 [StartTLS](https://en.wikipedia.org/wiki/Starttls) 之类的高级功能。

#### 4.3 HTTP 实现

HTTP 无疑是互联网上最流行的协议。现在已经有许多 HTTP 实现，比如 Servlet 容器。那么为什么 Netty 的核心上有 HTTP 呢？

Netty 的 HTTP 支持与现有的 HTTP 库非常不同。它使您能够完全控制 HTTP 消息在低级别上的交换方式。因为它基本上是 HTTP 编解码器和 HTTP 消息类的组合，所以不存在强制线程模型之类的限制。也就是说，您可以编写自己的 HTTP 客户端或服务器，它们的工作方式完全符合您的要求。您可以完全控制 HTTP 规范中的所有内容，包括线程模型、连接（connection）生命周期和分块（chunked）编码。

由于其高度可定制的特性，您可以编写一个非常高效的 HTTP 服务器，如:

* 需要持久连接和服务器推送技术的聊天服务器（例如 Comet）；
* 媒体流服务器，需要保持连接开放，直到整个媒体流传输完成（例如2小时的视频）；
* 允许在没有内存压力的情况下上传大文件的文件服务器（例如，每个请求上传 1GB）；
* 可扩展的 mash-up 客户端，异步连接到数以万计的第三方 web 服务；

#### 4.4. WebSockets 实现

通过一个单传输控制协议(TCP)套接字，[websocket](https://en.wikipedia.org/wiki/WebSockets) 允许双向、全双工通信信道。它被设计成允许在网络浏览器和网络服务器之间传输数据。

WebSocket 协议已经被 IETF 标准化为 [RFC 6455](https://tools.ietf.org/html/rfc6455)。

Netty 实现了 RFC 6455和许多旧版本的规范。请参考 [org.jboss. net ty.handler.codec.http.websocketx](http://static.netty.io/3.5/api/org/jboss/netty/handler/codec/http/websocketx/package-summary#package_description) 包和相关[示例](http://static.netty.io/3.5/xref/org/jboss/netty/example/http/websocketx/server/package-summary.html)。

#### 4.5. Google Protocol Buffer 集成

对于快速实现随时间演变的高效二进制协议来说，[Google 协议缓冲](https://code.google.com/apis/protocolbuffers/docs/overview.html)是一个理想的解决方案。使用 [ProtobufEncoder](http://static.netty.io/3.5/api/org/jboss/netty/handler/codec/protobuf/ProtobufEncoder.html) 和 [ProtobufDecoder](http://static.netty.io/3.5/api/org/jboss/netty/handler/codec/protobuf/ProtobufDecoder.html)，可以将由 Google 协议缓冲编译器(protoc)生成的消息类转换为 Netty 编解码器。请查看一下[“ LocalTime”示例](http://static.netty.io/3.5/xref/org/jboss/netty/example/localtime/package-summary.html)，它展示了如何轻松地从示例协议定义创建高性能的二进制协议客户机和服务器。

原文地址：https://netty.io/3.8/guide/#architecture