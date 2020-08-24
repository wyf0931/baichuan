---
title: Java 线程生命周期
author: Scott
tags:
  - Java
categories:
  - 技术
date: 2019-06-29 00:00:00
---

Java 线程生命周期是什么呢？在不同阶段又有什么含义呢？
<!--more-->

线程从创建到运行完成要经历下面这些阶段：

* New
* Runnable
* Running
* Non-Runnable (blocked)
* Terminated

#### New:
已经创建了该线程类的实例，但是还没有调用 `start()`方法。

#### Runnable:
线程已经调用了 `start()` 方法，已经可以运行了，正在等待线程调度器（Java 采用操作系统的线程调度器）来运行。

#### Running:

线程已经被线程调度器选中并正在运行中。

#### Non-Runnable (blocked):
线程还存在但是没有资格运行。可能的原因有：`sleep` 操作、等待文件 I/O 的完成或等待释放锁状态等等。

#### Terminated:
线程已经运行结束，处于中止状态， `run()` 方法已经退出。

下面这幅图表述的是各个阶段的转换过程：
![Java 线程状态流转.png](/images/java-thread-life-cycle.webp)

[阅读英文原文](http://www.techbeamers.com/java-multithreading-with-examples/)