---
title: "Linux kernel版本分类"
date: 2021-11-01T16:24:44+08:00
author: Scott
tags: 
  - Linux
categories: 
  - 技术
  - 笔记
---

Linux 内核版本有几种类型：`Prepatch`、`Mainline`、`Stable`、`Longterm`。

<!--more-->



### 1、Linux 内核

Linux Kernel Organization（内核组织）是一个成立于2002年的加利福尼亚公益组织，免费向公众发布 Linux 内核和其他开源软件。该组织由 Linux 基金会管理，由基金会为运行和维护 [Kernel.org](https://www.kernel.org/) 提供技术、财务和人员支持。

**Linux 不同的发行版本可能会采用自己维护的内核版，不一定全都是采用Linux内核官方团队的内核版本。**

### 2、如何查看Linux 内核版本

可以通过 `uname -r` 命令来查看。

例如：

```bash
ubuntu@VM-0-3-ubuntu:~$ uname -r
4.15.0-54-generic
```

其中 `4.15.0-54-generic` 就是内核版本。

### 3、Linux 内核版本类型对比

| 版本类型          | 说明                                                         | 备注                                                         |
| ----------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| `Prepatch` / `RC` | 试验版，包含新的特性，主要针对其他内核开发人员和 Linux 爱好者 | <li>1、必须从源代码进行编译。</li><li>2、由 Linus Torvalds 维护和发布。</li> |
| `Mainline`        | 主线版，所有新特性被引入的树                                 | 1、由 Linus Torvalds 维护。<br />2、每2-3个月发布一次。      |
| `Stable`          | 稳定版，stable上的bug都是从mainline上解决并merge到stable上。 | 1、通常一周一次。                                            |
| `Longterm`        | 长期维护版                                                   | 1、一般不会发布；<br />2、只有重要的问题修复了才会发布；     |

### 1.4 Linux内核长期维护版清单

| 版本号 | 维护人员                         | 发布日期   | 结束日期   |
| ------ | -------------------------------- | ---------- | ---------- |
| 5.15   | Greg Kroah-Hartman & Sasha Levin | 2021-10-31 | 2023年10月 |
| 5.10   | Greg Kroah-Hartman & Sasha Levin | 2020-12-13 | 2026年12月 |
| 5.4    | Greg Kroah-Hartman & Sasha Levin | 2019-11-24 | 2025年12月 |
| 4.19   | Greg Kroah-Hartman & Sasha Levin | 2018-10-22 | 2024年12月 |
| 4.14   | Greg Kroah-Hartman & Sasha Levin | 2017-11-12 | 2024年1月  |
| 4.9    | Greg Kroah-Hartman & Sasha Levin | 2016-12-11 | 2023年1月  |
| 4.4    | Greg Kroah-Hartman & Sasha Levin | 2016-01-10 | 2022年2月  |

### 5、内核镜像仓库

- HTTP：[ http://mirrors.kernel.org/](http://mirrors.kernel.org/)

- rsync：[rsync://mirrors.kernel.org/mirrors/](rsync://mirrors.kernel.org/mirrors/)

### 6、相关链接

- Linux 内核官网：[https://www.kernel.org/](https://www.kernel.org/)
- Linux 内核镜像仓库官网：[https://mirrors.kernel.org/](https://mirrors.kernel.org/)
- Linux 官网：[https://www.linux.com/](https://www.linux.com/)
- Linux 基金会官网：[https://www.linuxfoundation.org/](https://www.linuxfoundation.org/)

