---
title: "Clean Architecture (整洁架构)"
author: Scott
tags:
  - 架构设计
categories:
  - 技术
date: 2021-06-14T17:55:31+08:00
draft: false
---

在 2012 年，Robert C. Martin（又名 Uncle Bob）在他的博客上发表了关于整洁架构（Clean Architecture）的想法。整洁架构将一些已有的概念、规则和模式组合在一起，提出了一种构建应用程序的标准化方法。

<!--more-->



## 一、整洁架构、六边形架构、洋葱架构对比

**名词解释：**

> EBI：
>
> Hexagonal Architecture：六边形架构；
>
> Onion Architecture：洋葱架构；
>
> Clean Architecture：整洁架构；



**整洁架构的核心目标与六边形架构和洋葱架构相同：**

- 工具的独立性；
- 交付机制的独立性；
- 可测试性的隔离（领域、层之间的测试可以隔离）；



#### 1、整洁架构（Clean Architecture）

![整洁架构](https://blog-1252438081.cos.ap-shanghai.myqcloud.com/img/cleanarchitecture-5c6d7ec787d447a81b708b73abba1680.jpg)

#### 2、六边形架构（Hexagonal Architecture）

![Hexagonal Architecture](https://blog-1252438081.cos.ap-shanghai.myqcloud.com/img/hexagonal_original.gif)

#### 3、洋葱架构（Onion Architecture）

![Onion Architecture](https://blog-1252438081.cos.ap-shanghai.myqcloud.com/img/4ioq9.png)

#### 4、架构模型对比

1. **工具和交付机制的外部化（Externalisation of tools and delivery mechanisms）**

六边形架构侧重于使用接口（interface）和适配器 （Adapter）将工具和传递机制从应用程序外部化。这也是洋葱架构的核心基础之一，我们可以从它的图中看到，UI、基础结构（Infrastructure）和测试（Test）都在图的最外层。整洁架构具有相同的特性，在最外层具有 UI、 Web、 DB 等。最后，所有的应用程序核心代码都是 Framework（框架）或 Library（库）独立的。

2. **依赖方向（Dependencies direction）**

在六边形架构中没有明确告诉我们依赖的方向。不过，我们可以很容易地推断出：Application 有一个接口（interface），必须由适配器实现或使用。因此，适配器依赖于接口，它依赖于位于中心的 Application。外在取决于内在，依赖的方向是朝向中心的。在洋葱架构图中，也没有明确告诉我们依赖关系的方向，然而，在他的第二篇文章中，Jeffrey Palermo 非常清楚地指出，所有的依赖关系都朝向中心。整洁架构图则相反，明确指出了依赖方向是朝向中心的。他们都在架构层面上介绍依赖反转原则。内部圈子里的人不可能知道外部圈子里的任何事情。此外，**当我们在边界上传递数据时，它总是以对内圈最方便的形式传递。**

3. **图层（Layers）**

六边形架构图只向我们展示了两个层次: 应用程序内部和应用程序外部。另一方面，洋葱架构带来了 DDD 标识的应用层的混合: 包含用例逻辑的应用服务; 域服务封装不属于实体或值对象的域逻辑; 以及实体、值对象等等。与洋葱架构相比，清洁架构维护应用程序服务层(用例)和实体层，但似乎忘记了域服务层。然而，阅读 Bob 叔叔的帖子，我们意识到他不仅认为一个实体是 DDD 意义上的实体，而且认为它是任何领域对象: “一个实体可以是一个带有方法的对象，也可以是一组数据结构和函数。“。实际上，他合并了这两个最内层以简化图表。

4. **隔离测试性（Testability in isolation）**

在这三种建筑风格中，他们遵循的规则为他们提供了应用程序和领域逻辑的隔离。这意味着在任何情况下，我们都可以简单地模仿外部工具和交付机制，并在绝缘中测试应用程序代码，而不需要使用任何 DB 或 HTTP 请求。

正如我们所看到的，清洁建筑融合了六边形建筑和洋葱形建筑的规则。到目前为止，清洁架构并没有给这个等式增加任何新的东西。然而，在清洁架构图的右下角，我们可以看到一个额外的小图..。



## 二、MVC、EBI

清洁架构图右下角的附图解释了控制流程是如何工作的。这个附图展示的信息不多，但是博客上的解释和罗伯特 · c · 马丁的会议演讲扩展了这个主题。

![cleanarchitecturedesign](https://blog-1252438081.cos.ap-shanghai.myqcloud.com/img/cleanarchitecturedesign.png)

在上面的图表中，在左边，我们有 MVC 的视图和控制器。黑色双线之间的每一个内容都代表 MVC 中的 Model。该模型还代表 EBI 架构(我们可以清楚地看到边界、交互者和实体)、六边形架构中的“应用程序”、洋葱架构中的“应用程序核心”，以及上面清洁架构图中的“实体”和“用例”层。

在控制流之后，我们有一个到达 Controller 的 HTTP Request，Controller 会:

1. 对请求拆包；

2. 用相关数据创建请求 Model；

3. 在 Interactor 中执行一个方法（用 Interactor 的接口注入到 Controller 中），将请求 Model 传递给它;

4. Interactor：

   3.1 用 Entity Gateway Implementation (通过实体网关接口注入到交互器中) 来查找相关 Entity；

   3.2 编排 Interactor Entity；

   3.3 用操作的数据结果创建响应 Model；

   3.4 通过响应 Model 填充 Presenter；

   3.5 将 Presenter 返回给 Controller；

5. 用 Presenter 生成一个 ViewModel；

6. 将 ViewModel 绑定到 View；

7. 将 View 返回给客户端；

在这里，我唯一感觉到一些摩擦，并在我的项目做不同的是 “Presenter” 的使用。我宁愿让 Interactor 以某种 DTO 的形式返回数据，而不是注入一个用数据填充的对象。

我通常做的是实际的 MVP 实现，其中 Controller 负责接收和响应客户端。

## 三、总结

整洁架构实际上并没有带来一个新的开创性的概念或模式，因此不能说是革命性的成果。但这也是一项很重要的里程碑：

- 它恢复了一些被遗忘的概念、规则和模式；

- 它阐明了有用和重要的概念、规则和模式；

- 它告诉我们所有这些概念、规则和模式是如何组合在一起的，从而为我们提供了一种标准化的方法来构建具有可维护性的复杂应用程序；

当我想到 Uncle Bob 在创造整洁架构的时候，我想到了牛顿（Isaac Newton）。地心引力一直存在，每个人都知道，如果我们在离地一米的地方放一个苹果，它就会向地面移动。牛顿“唯一”做的就是发表了一篇论文，将这一事实明确化  。这是一件“简单”的事情，但它允许人们对它进行推理，并将这个具体的想法作为其他想法的基础。

换句话说，我认为 Robert C. Martin 是软件开发领域的牛顿！



### 参考文章

- [The Clean Architecture ](https://blog.8thlight.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- 原文 - [Clean Architecture: Standing on the shoulders of giants](https://herbertograca.com/2017/09/28/clean-architecture-standing-on-the-shoulders-of-giants/)
- 2012 – Robert C. Martin – [Clean Architecture (NDC 2012)](https://youtu.be/Nltqi7ODZTM)
- 2012 – Robert C. Martin – [The Clean Architecture](https://blog.8thlight.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- 2012 – Benjamin Eberlei – [OOP Business Applications: Entity, Boundary, Interactor](https://beberlei.de/2012/08/13/oop_business_applications_entity_boundary_interactor.html)
- 2017 – Lieven Doclo – [A couple of thoughts on Clean Architecture](https://www.insaneprogramming.be/article/2017/02/14/thoughts-on-clean-architecture/)
- 2017 – Grzegorz Ziemoński  – [Clean Architecture Is Screaming](https://dzone.com/articles/clean-architecture-is-screaming)

