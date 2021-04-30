---
title: "科技行业的宏观趋势 | 2020年10月"
author: Scott
tags:
  - 资讯
  - 翻译
categories:
  - 技术
date: 2020-11-29T14:59:42+08:00
---

本文翻译自 [Macro trends in the tech industry | Oct 2020](https://www.thoughtworks.com/insights/blog/macro-trends-tech-industry-oct-2020) ，作者作为 ThoughtWorks Technology Radar 团队的一员，该团队成立已近十年，这篇文章主要阐述科技产业中正在发生的重大趋势。

<!--more-->

### 一、编程大众化

我们这个月 Radar 的主题之一，可能也是当今技术最大的持续趋势之一，就是我们所说的编程的“民主化”。这意味着将编程交到任何想要编程的人手中，并使编程机器或系统的能力变得更容易获得。这并不是什么新想法；[COBOL](https://en.wikipedia.org/wiki/COBOL) ——“通用的、面向商业的语言”——是上世纪60年代的一种尝试，目的是使用一种更容易为非程序员所理解的类似英语的语言来编写计算机程序。今天，我们看到了对“傻瓜式代码（low-code）“平台的巨大兴趣，这些平台允许我们不需要程序员就可以创建软件。还有一些平台，比如以消费者为中心的 [IFTTT](https://ifttt.com/) 或者以企业为中心的 [Zapier](https://zapier.com/)，它们允许技术水平较低的用户将各种设备、 SaaS 平台、端点（endpoints）和工作流（workflows）连接起来，做一些有趣且有用的事情。如果你正在寻找一个集成框架，[Apiant](https://apiant.com/)，[Blendr](https://www.blendr.io/)，[Microsoft Flow](https://flow.microsoft.com/)，[Pipedream](https://pipedream.com/)，[Quickwork](https://quickwork.co/) 和 [Tray.io](https://tray.io/) （仅举几个例子）可以帮助你。在应用程序创建方面，[Amazon Honeycode](https://www.honeycode.aws/) 已经取得了一些进展，尽管其中一位 Radar 的作者将其描述为“微软云端访问”。

我们认为编程的能力，或者至少对我们使用的系统的功能有一定的发言权，是极其重要的。在 Douglas Rushkoff 的[《程序或被编程》（Program or Be Programmed）](https://rushkoff.com/books/program-or-be-programmed/)一书中，他认为我们必须选择是否引导技术，或者让自己被它和那些已经掌握了它的人所引导。除了这种哲学观点，一个明显的事实是，这个世界对软件的需求超过了现有 IT 团队所能创造的，而且更快。

电子表格就是一个常见的例子。几乎每个企业都有某种类型的电子表格参与运行，IT 行业的每个人都知道哪里会出错；嵌入关键的、未经测试的业务逻辑的巨型电子表格相当普遍。最近，更令人担忧的是，我们看到世界各地的医疗保健服务由于电子表格错误而[丢失或错误处理2019冠状病毒疾病数据](https://www.popularmechanics.com/technology/a34274176/uk-coronavirus-excel-spreadsheet-lost-cases/)。电子表格通常用于允许非程序员快速创建、存储和操作数据，而无需进入“真正的”程序员的漫长开发周期。低代码平台的相似之处在于，它们承诺通过使用预焙（pre-baked）组件和配置而不是代码来加速软件开发。

电子表格和低代码有一个共同的关键特征：就所需功能的类型或问题域的复杂性而言，它们都能很好地在某个“最佳位置”工作，但如果推进得更远，则可能会严重失败。不幸的是，之所以选择这样的解决方案，首先是因为缺乏技术人才或时间，这也妨碍了使用电子表格或低代码环境的人意识到，他们已经把解决方案推到了最佳位置之外。出于这个原因，我们推荐使用有限的低代码平台来管理这种风险，同时还可以利用大众化编程平台可能加速的优势。

### 二、Rust 高速增长

我们最喜欢的编程语言之一是 [Rust](https://www.rust-lang.org/)，它是一种高性能类型和内存安全的语言，可以用作系统编程语言（取代 C 或 C++） ，也可以用作通用语言。Rust 的受欢迎程度持续增长，它连续五年被 [Stack Overflow](https://insights.stackoverflow.com/survey/2019#most-loved-dreaded-and-wanted) 评为最受欢迎的语言。

在这个版本的《雷达》（Rodar）中，我们注意到 Rust 被用于传统上需要 Python 的大数据和机器学习任务，并且在某些情况下可以提供巨大的性能优势。我们还注意到了 [Materialize](https://github.com/MaterializeInc/materialize)，一个用 Rust 写的面向流，低延迟的数据库。

那么，是什么让 Rust 如此受欢迎呢？就我个人而言，我发现它结合了强大的表现力和编译时的安全性是独一无二的。[Stack Overflow notes](https://stackoverflow.blog/2020/06/05/why-the-developers-who-use-rust-love-it-so-much/) 上说 Rust 是一种编程语言，“看起来像是由用户体验设计师开发的” ，他们对这种语言有着清晰的认识，并仔细地选择了要包含的内容。所有这些良好的意愿已经创造了一个支持的，可访问的社区锈和一个不断改善的生态系统的库和工具。

### 三、可视化

这个版本的雷达包括一些可视化工具的很好的例子。对于理解我们今天构建的复杂系统来说，比以往任何时候都更有能力创建一幅关于某些事物的良好愿景——架构、代码复杂性、系统性能或微服务生态系统中的分布式跟踪（traces）—— 至关重要。我们讨论过的可视化工具包括:

* [Dash](https://plotly.com/dash/) 和 [Streamlit](https://www.streamlit.io/) ：建立机器学习和数据科学网络应用的框架；
* [Dash](https://plotly.com/dash/) ：它既用于机器学习类型的应用程序，也用于构建自定义报告和仪表盘的商业智能场景；
* [Kiali](https://kiali.io/) ：为基于 Istio 的服务网格提供仪表盘和其他可观察性工具的管理控制台；
* [OpenTelemetry](https://opentelemetry.io/) ：一个用于捕获分布式跟踪和指标（metrics）的 API 和 SDK；
* [Polyglot Code Explorer](https://github.com/kornysietsma/polyglot-code-explorer) ：一种用于视觉检查代码基并探索其健康和结构的工具；

您可能已经熟悉主流 BI 工具的可视化功能，比如 Tableau 或者 Power BI，而且这个工具空间正在产品中爆炸式增长。但是像 Dash 和 Streamlit 这样的工具提供了一种基于代码的可视化方法，它具有所有相关的好处ーー灵活性、可定制性、版本控制和自动部署。这些都是考虑使用框架而不是完全成熟的“数据工作室（data studio）”式工具的好理由。

### 四、基础设施即代码

在我们的雷达主题中，我们把基础设施称为代码，我们正在深思熟虑地使用这个词，它既有积极的意义，也有消极的意义。就像一个有点笨拙的少年，基础设施作为代码正在成长。这是积极的，因为随着越来越成熟，我们开始看到更好的结果和围绕这一技术的生态系统的成长。但是也有成长的烦恼，例如某些工具的不一致性，以及相互竞争的方法和哲学。

那么什么是将基础设施作为代码呢？简而言之，它是基础设施自动化和自动化的精心管理。权威的描述来自我们的同事 Kief Morris 的书[《代码的基础设施: 云中的服务器管理》（Infrastructure as Code: Managing Servers in the Cloud）](https://www.thoughtworks.com/books/infrastructure-as-code) ，该书的第二版即将出版。根据Morris 的说法，不同的思想流派正在以代码的形式出现在基础设施领域: Pulumi 迷们谈论“基础设施即软件（infrastructure as software）” ，Hightower 谈论“基础设施即数据（infrastructure as data）” ，WeaveWorks 催生了“ GitOps”这些不同的哲学最终会走向何方还有待观察，但是现在我们会把它们描述为基础设施的一种特点，即代码，而不是对代码的重大背离。这一领域的工具已经得到了飞跃性的改进，[CDK](https://thoughtworks.com/radar/platforms/aws-cloud-development-kit) 和 Pulumi 的例子表明生态系统正在变得越来越成熟。

### 五、浏览器成了一个意外的应用平台

老牌的互联网浏览器刚开始只是一个浏览 HTML 文档并使用超链接在这些文档之间导航的工具。随着浏览器的普及，HTML 2.0添加了更多的标签，并且能够向服务器提交“表单”以获得更多交互式网页。在 Netscape 与微软的较量中，他们意识到了浏览器需要一个脚本语言，所以 JavaScript （初期叫 Mocha）匆忙地通过了10天的开发周期，并加入到了 Netscape 中。历史上这一次被称为“浏览器战争” ，因为 Netscape 和微软等公司在 HTML 中添加了专有扩展，试图在竞争中占据优势。你可能会记得这个时候网页上的徽章上写着“在 Internet Explorer 工作效率最高”。Flash 和嵌入式 Java 小应用程序也为页面增加了交互性，Ajax 标准诞生了，JavaScript 被开发者再次发掘，甚至开始被用作后端语言(例如在 node.js 中)。

这里的要点是，浏览器开始时只是一个简单的文档查看器，但后来被迫成为一个应用程序平台。我在 Google Docs 上写这篇文章，在 YouTube 上听音乐，通过 Google Chat 与同事聊天。这个聊天窗口看起来像是一个本地应用程序窗口，但实际上只是一个包含网页的窗格。我现在使用的大部分应用程序都是通过浏览器发布的。

> 事实上，浏览器意外地成为了一个应用平台，而且从一开始就不是这样设计的，这持续的给 IT 行业带来很大压力。

多年来，我们一直在说服浏览器做更多令人惊叹的事情，浏览器已经成为一个复杂的平台和生态系统。一般来说，各种浏览器都具有广泛的兼容性，多种浏览器弥补了这一差距，使开发人员更容易针对多种浏览器开发。但是 JavaScript 的生态系统本身仍然是令人困惑的复杂，而且还在不断变化。我们讨论过将 [Redux](https://www.thoughtworks.com/radar/languages-and-frameworks/redux) 从“ Adopt” 移回 “Trial” ，因为开发人员开始在 React 应用程序中寻找其他地方来管理状态(例如 [Recol](https://www.thoughtworks.com/radar/languages-and-frameworks/recoil))。但即使在今天，构建 web 应用程序的正确方式仍在继续发展: [Svelte](https://thoughtworks.com/radar/languages-and-frameworks/svelte) 已经获得了越来越多的关注，并且正在挑战流行的应用框架 [React](https://thoughtworks.com/radar/languages-and-frameworks/react-js) 和 [Vue.js](https://thoughtworks.com/radar/languages-and-frameworks/vue-js) 应用的一个既定概念: 虚拟 DOM。

测试是另一个领域，在这个领域中，浏览器或多或少被迫进行合作，但仍然受到自动化和测试工具被改装而不是作为一流目标来设计和支持的困扰。在这个版本的 Radar 中，[Playwright](https://thoughtworks.com/radar/tools/playwright) 试图改进 UI 测试，而 [Mock Service Worker](https://thoughtworks.com/radar/languages-and-frameworks/mock-service-workers) 是一种将测试与后端交互解耦的方法。

我们也看到了浏览器向“本地”代码平台的演变，[WebAssembly](https://webassembly.org/)  提供了一个高效的虚拟机，旨在以接近本地的速度运行代码。例如，在你的浏览器中查看运行速度为[ 60 FPS 的 Doom 3](https://wasm.continuation-labs.com/d3demo/)。

浏览器是不会离开任何地方的，但事实上，它基本上是一个偶然的应用程序平台，这一事实继续在科技界引起反响，每个项目都应该至少花一些时间来关注最新的浏览器相关开发。

### 六、相关链接：

- 官网：https://www.thoughtworks.com/radar
- 下载页面：https://www.thoughtworks.com/radar#download-current-radar