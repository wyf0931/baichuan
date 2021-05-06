---
title: "Paxos 协议"
date: 2021-04-30T15:49:10+08:00
author: Scott
tags:
  - 协议
  - 算法
  - 高可用
categories:
  - 技术
draft: false
---

**Paxos 算法**是[莱斯利·兰伯特](https://zh.wikipedia.org/wiki/莱斯利·兰伯特)（英语：Leslie Lamport，[LaTeX](https://zh.wikipedia.org/wiki/LaTeX)中的“La”，此人现在在微软研究院）于1990年提出的一种**基于消息传递**且具有高度容错特性的共识（consensus）算法，是目前公认的解决**分布式一致性**问题**最有效**的算法之一。需要注意的是，Paxos 常被误称为“一致性算法”。但是“[一致性（consistency）](https://zh.wikipedia.org/wiki/线性一致性)”和“共识（consensus）”并不是同一个概念。Paxos是一个共识（consensus）算法。
<!--more-->

### 概述

**Paxos 算法解决的问题是一个分布式系统如何就某个值（决议）达成一致。** 一个典型的场景是，在一个分布式数据库系统中，如果各节点的初始状态一致，每个节点都执行相同的操作序列，那么他们最后能得到一个一致的状态。为保证每个节点执行相同的命令序列，需要在每一条指令上执行一个"一致性算法"以保证每个节点看到的指令一致。一个通用的一致性算法可以应用在许多场景中，是分布式计算中的重要问题。

**Paxos 中保证一致性的最核心的两个原则是：**

- 少数服从多数；
- 后者认同前者；

**Paxos 分为两类：**

- Basic Paxos：也叫 single decree paxos，每次有1个或多个节点针对一个变量进行投票，确定变量的值；
- Multi Paxos：通过一系列 Basic Paxos 的实例来确定一系列变量的值，来实现一个Log；

**Paxos 主要满足下面两个需求：**

- Safety：一个变量只会被确定一个值，一个变量只有在值被确定之后，才能被学习；
- Liveness：一些提案最终会被接受；一个提案被接受之后，最终会被学习到；

Liveness 的解决其实比较简单，每个 Proposer 引入随机超时回退，这样可以让某一个 Proposer 能够先进行提议，成功提交到多数，那么就可以解决活锁的问题了。

Paxos 中只有对应的 Proposer 知道提案的值，其他 Proposer 如果要读取提案的值，也需要执行一遍 Basic Paxos 的提案才能拿到提案值。

### 1. Basic Paxos

#### 1.1 Components

**Paxos 主要包括两个组件：Proposer 和 Acceptor，其中 Proposer 主动发起投票，Acceptor 被动接收投票，并存储提案值。** 在实际系统中，每个 Paxos Server 都包含这两个组件。

#### 1.2 Problem

Paxos 的提案过程中为了解决 acceptor crash，需要多个 acceptor 中 quorum 应答才算成功，这样应答之后只要有1个节点存活提案值就是有效的。但是多个 acceptor 就会出现 Split Votes 和 Conflict Chose 的问题。

#### 1.3 Split Votes

如果 Acceptor 只接受第一个提案值，考虑多个 Proposer 同时对一个提案进行提议，那么可能任何一个 Proposer 都不会拿到多数应答。

[![img](https://blog-1252438081.cos.ap-shanghai.myqcloud.com/img/split_votes.png)](https://github.com/baidu/braft/blob/master/docs/images/split_votes.png)

这个时候 Acceptor 就需要允许接收多个不同的值，来解决 Split Votes 的问题。

#### 1.4 Conflicting Choices

为了解决 Split Votes，Acceptor 可以接受多个不同的值，如果 Acceptor 要接受每一个提议，那么可能不同的 Proposer 提议不同的值，可能都会被 chosen，破坏每个提案只有一个值的原则。

![img](https://blog-1252438081.cos.ap-shanghai.myqcloud.com/img/conflict_choices.png)

这个时候就需要采用 2-phase 协议，对于已经 chosen 的值，后面的 proposal 必须提议相同的值。

![img](https://blog-1252438081.cos.ap-shanghai.myqcloud.com/img/2pc_choice.png)

如图 S3 应该拒绝 S1 的 proposal，这样就可以保证 S5 的提案成功，S1 的提案因为冲突而失败。需要对提议进行排序，这样 Acceptor 可以拒绝老的提议。

#### 1.5 Proposal Number

可以通过 Proposal Number 来唯一标示 Proposal，方便 Acceptor 进行排序。

一个简单的 Proposal Number 的定义为：

[![img](https://blog-1252438081.cos.ap-shanghai.myqcloud.com/img/proposal_number.png)](https://github.com/baidu/braft/blob/master/docs/images/proposal_number.png)

Proposer 保存 `maxRound`，表示当前看到的最大 Round Number，每次重新发起 Proposal 的时候，增加 `maxRound`，拼接上 `ServerId` 构成 Proposal Number。

Proposer 需要将 `maxRound` 持久化，确保宕机之后不会重用之前的 `maxRound`，避免生成相同的 Proposal Number。

#### 1.6 Flow

**Paxos 执行过程包括两个阶段：Prepare 和 Accept。** 其中 Prepare 阶段用于 block 当前未完成的老的提案，并发现当前已经被选取的提案（如果已经提案完成或部分完成），Accept 过程用于真正的进行提交提案，Acceptor 需要持久化提案，但需要保证每个提案号只接受一次提案的原则。具体流程如下：

![img](https://blog-1252438081.cos.ap-shanghai.myqcloud.com/img/flow-20210430155818558.png)

#### 1.7 Example

下面针对几种情况来讨论 paxos 的实际运行。最常见的是之前的提案已经完成，后面又有 proposer 又发起提案，除了提案号变化之外，提案值并没有变化： [![img](https://blog-1252438081.cos.ap-shanghai.myqcloud.com/img/pp1.png)](https://github.com/baidu/braft/blob/master/docs/images/pp1.png) 当多个proposer 并发发起提案或者是上一个 proposer 异常终止，都会出现提案部分完成的情况，如果新的 proposer 在 prepare 阶段看到了上一个 proposer 的提案值，就将其作为自己的提案值，这样即使两个 proposer 并发提案，依然可以保证两个 proposer 都成功且 value 是一致的： [![img](https://blog-1252438081.cos.ap-shanghai.myqcloud.com/img/pp2.png)](https://github.com/baidu/braft/blob/master/docs/images/pp2.png) 在上面并发提案的情况下，如果新的 proposer 在 prepare 阶段没有看到上一个 proposer 的提案值，将提交自己新的提案值，这样老的 proposer 会失败，而接受新的提案值： [![img](https://blog-1252438081.cos.ap-shanghai.myqcloud.com/img/pp3.png)](https://github.com/baidu/braft/blob/master/docs/images/pp3.png)

### 2. Multi Paxos

Lamport 并没有在论文中详细描述 Multi Paxos 的细节，Multi Paxos 直观来看是给每个提案增加一个 Index，将其组成一个顺序 Basic Paxos 实例流。

当收到 Client 的请求时处理流程如下：

1. 寻找第一个没有 chosen 的 LogEntry；
2. 针对这个 LogEntry 对应的 Index 运行 Basic Paxos 进行提案；
3. Prepare是否返回 acceptedValue？
   1. Yes：完成chosing acceptedValue，跳到1继续处理；
   2. No：使用 Client 的 Value 进行 Accept；

[![img](https://blog-1252438081.cos.ap-shanghai.myqcloud.com/img/multi_paxos.png)](https://github.com/baidu/braft/blob/master/docs/images/multi_paxos.png)

通过上面的流程可以看出，每个提案在最优情况下需要2个RTT。当多个节点同时进行提议的时候，对于index的争抢会比较严重，会造成Split Votes。为了解决Split Votes，节点需要进行随机超时回退，这样写入延迟就会增加。针对这个问题，一般通过如下方案进行解决：

1. 选择一个Leader，任意时刻只有一个Proposer，这样可以避免冲突，降低延迟
2. 消除大部分Prepare，只需要对整个Log进行一次Prepare，后面大部分Log可以通过一次Accept被chosen

#### 2.1 Leader Election

对于Leader Election，Lamport 提出了一种简单的方式：让`ServerId`最大的节点成为 Leader。

每个节点定期T向其他节点发送心跳，如果某个节点在2T内没有收到最大`ServerId`节点的心跳，则变为 Leader。

Leader 会接收 Client 的请求，并扮演 Proposer 和 Acceptor；其他节点拒绝 Client 的请求，只扮演 Acceptor。

#### 2.2 Eliminating Prepares

在讨论消除 Prepare 请求之前，我们先讨论一下 Prepare 的作用：

1. 屏蔽老的 Proposal：拒绝老的 Proposal 提议，作用域是一个 Index
2. 返回可能 chosen 的 Value：多个 Proposer 进行并发 Proposal 的时候，新的 Proposal 需要确保提议相同的值

在Multi-Paxos过程中，要消除 Prepare 是消除大多数的 Prepare，但是依然需要 Prepare 的：

1. 屏蔽老的Proposal：拒绝老的Proposal提议，但是作用域名是整个Log，而不是单个Index
2. 返回可能chosen的Value：返回最大的Proposal Number的acceptedValue，当后面的Proposal没有acceptedValue的时候返回noMoreAccepted。

这样一个 acceptor 一旦用 noMoreAccepted 回复 Prepare 之后，Proposer 就不需要再向其发送 Prepare 了。

如果 Proposer 拿到了多数 acceptor 的 noMoreAccepted 之后，Proposer后面的提议就不需要发送 Prepare了，这样每个 LogEntry 只需要1个RTT的 Accept 就可以 chosen 了。

#### 2.3 Other

通过选主和消除 Prepare 之后，Multi Paxos 依然不够完整，还需要解决：

- Full Replication：全部节点都需要复制得到全部的Log；
- All Server Know about chosen value：全部节点需要知道Log中哪些值被chosen了 对于Full Replication可以通过Leader一直重试Accept 请求，来保证 Acceptor 上数据尽可能的最新。

为了通知每个节点 Chosen 的 Value，我们增加了一些内容：

- 每个LogEntry都有一个 `acceptedProposal`，标明提案号，一旦被 Chosen，将其设置为`∞`；
- 每个Server都维护一个 `firstUnChosenIndex`，表明第一个没有被 Chosen 的 LogEntry 的位置。

Proposer 向 Acceptor 发送 Accept 请求的时候带上 `firstUnChosenIndex`，这样 Acceptor 接收到 Accept 请求的时候，就可以更新本地Log 中 Chosen Value 的范围：

- `i < request.firstUnChosenIndex`
- `acceptedProposal[i] = request.proposal`

上面讨论的几种方式都是 Leader 存活期间由 Leader 来保证其提案值在全部节点上尽可能的被复制和被 Chosen，需要考虑 Leader 故障之后新的 Leader 需要将上一个 Leader 尽可能但是没有完成的数据进行复制和 Chosen。

- Acceptor 将其 `firstUnChosenIndex` 作为 Accept 的应答返回给 Proposer；
- Proposer 判断如果 `Acceptor.firstUnChosenIndex < local.firstUnChosenIndex`，则异步发送Success RPC。

`Success(index, v)` 用于通知 Acceptor 已经 Chosen 的 Value：

- `acceptedValue[index] = v`
- `acceptedProposal[index]=∞`

Acceptor 返回 `firstUnChosenIndex` 给 Proposer，Proposer 再继续发送 Success 请求来通知其他 Chosen 的 Value。



### 相关链接：

- 原文：[https://github.com/baidu/braft/blob/master/docs/cn/paxos_protocol.md](https://github.com/baidu/braft/blob/master/docs/cn/paxos_protocol.md)
- Paxos算法 - 维基百科：[https://zh.wikipedia.org/wiki/Paxos算法](https://zh.wikipedia.org/wiki/Paxos算法)

