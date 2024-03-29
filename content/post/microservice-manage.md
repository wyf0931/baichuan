---
title: 微服务架构体系治理
author: Scott
tags:
  - 架构设计
  - 管理
categories:
  - 技术
date: 2019-08-27 16:58:00
---

本文是在天弘基金李鑫的演讲稿上提炼而来，介绍微服务架构深度治理。
<!--more-->

> 原文地址：https://www.infoq.cn/article/q65dDiRTdSbF*E6Ki2P4

## 微服务度量

> 管理学大师彼得. 德鲁克说过“如果你不能度量它，你就无法改进它”，强调的就是度量的重要性。

### 度量指标采集

**线上：**

* 通过服务注册中心获取到服务的注册信息及服务的管控指令信息；
* 通过微服务主机节点上的主机日志、应用及服务日志、APM 监控的调用链日志，可以获取到相关的性能及异常指标信息。

**线下：**

* 通过需求管理系统，可以采集到 UserStory 及各类需求的基本信息；
* 通过项目管理系统可以采集到开发人员、开发团队、开发任务的基础信息；
* 通过测试相关的管理系统可以采集到测试用例及测试 bug 的相关定义信息及过程指标信息；
* 通过源码仓库及软件版本仓库可以采集到最终研发产出物的基本信息。

> 一个系统的代码就是一本“书”，你只要读懂了这本“书”，你就知道这个系统的前世今生。

**源码分析：**

用 eclipse 中的 AST 组件（Abstract Syntax Tree，中文为抽象语法树）实现源代码分析，过程如下：

1. 通过 AST，获取到源码中任何一个 Java 源码文件中所调用的外部类、继承或者实现的接口（父类）、类变量集合、类方法集合、方法逻辑块（多层嵌套）、注释等基本信息;
2. 通过对代码的逐行扫描，并基于一系列的正则及其它匹配，获取到一个方法对其它方法的调用关系；
3. 汇总之后，构建出一个跨工程、方法一级的庞大的调用关系矩阵；

微服务之间的调用关系则是方法级调用矩阵的一个子集。

**协同：**

* 开发和测试之间的配合，会采用持续集成（CI）；
* 产品、开发、测试的协作，会采用敏捷协作模式；
* 开发与运维之间，使用 DevOps 的 Pipeline；

### 分析决策体系

治理决策和管控指令是微服务度量及分析体系的最终产出物。以下是分析与决策过程：

1. 通过各个指标来源渠道获取到各类度量指标，并把它们以 ODS（操作型数据）的格式汇总到数据仓库；
2. 通过数据模型抽取出主数据（MDM），这些主数据包括了服务、需求、任务、人员、团队等；
3. 通过不同的数据主题（Topic）构建起一个多层的“数据集市”，这些数据主题包括了异常、性能、资源、调用关系、容量、系统、测试、开发、运维协同效率等；
4. 在数据集市的基础之上进行各类数据分析，包括性能分析、容量分析、健康度分析、团队及个人的质量报告、质量趋势、动态调用链及静态调用链的深度梳理、以及各维度的汇总报表；
5. 根据分析报告，由治理委员会进行深度的分析并制定出各类的治理决策，或者通过人为或自动化的机制发出各类管控指令。

## 线上体系治理

### 服务限流
服务限流算法：

- 漏桶算法
- 令牌桶算法

构建服务限流能力的难点：标准化、体系化。

### 集群容错

集群容错策略：

- 快速失败（Failfast）
- 失败转移（Failover）
- 失败重试（Failback）
- 聚合调用（Forking）
- 广播调用（Broadcast）

> 在使用集群容错的时候，一定要设置最大重试次数。

### 服务降级

服务降级和服务限流类似，也是微服务集群自我保护的机制。

在服务降级之前要做好预案，提前梳理出核心业务链路和非核心业务链路（根据业务对相关服务定级）。

**服务降级方法：**

- 容错降级
- 静态返回值降级
- Mock 降级
- 备用服务降级

### 故障定位

分布式环境下的故障定界定位，最有效的工具就是动态调用链路跟踪。

**实现原理：**

根据 traceID 来对日志做聚合，找到所有的关联日志，并按顺序排序，构建出这个请求跨网络的调用链，详细描述请求的整个生命周期的状况。

**常见调用链路跟踪工具：**

- 开源：Zipkin，SkyWalking、PinPoint、CAT
- 商用：听云、AppDynamic、NewRelic

### 容量规划

**容量规划形式：**

1. 容量预估（基于业务预估和经验）；
2. 性能压测

**压测顺序：**

在调用链的末梢，也就是对数据库或者缓存先进行压测，再一级一级往上压测，最终覆盖整个链路，实现全链路压测。

**压测条件：**

全链路压测的前提是单点压测，需要先把单点压测能力做好，才能做全链路压测。

> **注意：**
> 压测数据与线上数据要隔离。

### 关联资源的治理

线上任何资源，如果只有服务对它进行调用，那么完全可以基于服务对资源的调用日志来分析资源的使用状况、性能状况。

**数据库：**

汇总对某个数据库访问的所有服务的调用日志，计算查询的调用延时、统计CRUD的请求量、表的调用的分布状况、推算出每个表的查询操作的整体表现及相关的慢查询等等。

**分布式缓存：**

汇总所有的读、写操作，并计算出读写比例，也可以基于每次的调用结果（是否为 null、是否异常）汇总出命中率，正常的缓存表现应该是读多写少，如果推算出的读写比例是读少写多，或者命中率偏低，说明缓存的使用策略有问题，需要进行改进。

**消息队列：**

1. 通过调用日志，计算出单位时间内写入的消息量、被消费的消息量，推算出消息队列当前的堆积情况；
2. 通过调用日志获取的资源的使用及性能状况，比通过资源自身的监控所获取到的相关指标会更客观一些；
3. 通过资源使用情况分析，可以实现资源回收。

### 生命周期管理

在弹性计算资源的基础上，通过整合资源编排、资源调度的能力，构建了微服务的综合管控平台，通过平台更好的进行服务的上线、下线、扩容、缩容等操作。

## 线下体系治理

### 整体架构治理

**基本原理：**

通过动态调用链的汇总来获取微服务集群服务间的调用关系总图，可以根据总图，对微服务的调用质量进行深入的分析。服务调用关系都是分层的，层层往下推进，最终形成一个有向无环图（DAG）。

**治理过程：**

1. 对调用关系图进行闭环检测，如果检测到回环调用的话，说明调用关系是有问题的，需要进行优化。
2. 对整个调用网络进行遍历计算，找出所有调用深度最深的调用链，并按调用深度进行 topN 排序，重点对排在头部的这些调用链分析它的必要性及合理性，看是否可以对调用深度进行缩减和优化。
3. 找出整个网络中被调用最多的这些服务节点，被依赖最多的节点，自然是最重要的节点，作为枢纽节点，在运维等级上需要重点保障（实际应用中，还会加上调用量这个权重来综合判定服务节点的重要性）。
4. 找出没有调用关系的服务节点，可以考虑对它进行下线处理，以释放资源。

**最佳实践：**
上述中所有的度量和治理都是在调用关系总图的基础上进行的，用的是图论中的常用算法，包括 BFS、DFS、PageRank 等，如果嫌麻烦，可以找个图数据库，比如 neo4j，它的基本查询能力中已经集成了这些算法。

### 单个架构治理
微服务的设计要尽量的遵循“迪米特法则”，要尽量少的和外部的系统或者服务发生交互。具体表现为：

- 承载的业务比较单一
- 架构上尽量做到自洽和内敛

**治理过程：**

1. 通过动态调用链分析，可以统计单个服务节点对外调用的服务数量，对于承载的业务太多的服务，需要分析是否不够纯粹，是否需要对它进行拆分。
2. 通过静态调用链分析，可以统计未触发的逻辑，定期找出冗余代码进行清理，保证微服务的体量不会膨胀。

### 开发质量度量与治理
**自动化：**

- Checkstyle
- 静态代码扫描工具（FindBugs、阿里代码插件、Sonar）

**流程化：**

* codereview 
* 统计线上 bug 的种类和数量（异常定级），综合评估开发人员的开发质量。

通过异常定级策略，形成团队的研发质量“画像”，作为团队 KPI 考核的参考。以时间维度，根据质量变化趋势，针对性的进行研发人员的质量改进和技能提升。

### 测试治理

**核心诉求：**

* 提高测试覆盖度（需求覆盖、代码覆盖、页面覆盖）
* 降低测试用例维护成本

**需求覆盖度：**

以服务维度对需求和测试用例进行关联，找出每个需求下所对应的单元测试用例、自动化测试用例、手工测试用例，在此基础上，可以把多个开发迭代周期的这些指标进行时间维度的纵比，以得出需求覆盖度的变化趋势。

**代码覆盖度：**

contest 、jacoco 

**页面覆盖度：**

将集成测试中调用的页面以日志的形式记录下来，通过日志的聚合分析，结合工程源码的扫描，对比统计出哪些页面是没有被覆盖到。

**测试用例维护成本：**

通过对测试指标的不断度量和治理，可以实现测试工作的整体“降本增效”。

* 新增用例成本
* 存量用例变更成本：用相似度匹配算法，算出存量测试用例前后两个版本代码的相似度，再换算成变更度。

### 接口联调
**搭建mock机制：**

1. 利用分布式服务框架提供的过滤器机制，开发了一个 Mock 过滤器，通过 Mock 数据文件来详细定义要被 mock 的服务的名称、入参及出参。
2. 利用服务框架的过滤器机制，开发了“在线数据抓取过滤器”，可以将指定的服务请求的入参和返回结果都抓取下来，直接写成 mock 数据文件，可以有效降低制作 mock 文件的成本。

> **注意：**线上需要注意数据合规问题，数据脱敏。

### 团队协同
通过制度化的发布计划，有效减轻部门间的沟通成本。

**需求管理：**

* 两周一迭代
* 固定发版
* 火车发布模式
* 班车制，准点发车

**最佳实践：**

* 工作量评估时，预留一些工作量 buffer，应对临时性需求，如果本次迭代内没有临时需求，可以从 backlog 中捞一些架构优化的需求来填补这些 buffer。
* UI 设计感性因素较多，因此不将 UI 设计纳入迭代之中，将其作为需求的一部分，在每个迭代开始之前的工作量评估中，要求必须提供完整的 UI 物料，否则不予评估工作量，此需求也不会被纳入迭代之中。

### 团队协同质量的度量与治理

1. 使用敏捷迭代协作，采用数据驱动的精益看板方法；
2. 持续采集每个迭代中各个阶段的过程指标事件（比如任务什么时候完成设计、什么时候进入开发、什么时候开发结束、什么时候进入测试…等等）

过程指标被汇总后，会产生几大典型报表：

- 韦伯分布图
- 累积流图
- 价值流图
- 控制图
