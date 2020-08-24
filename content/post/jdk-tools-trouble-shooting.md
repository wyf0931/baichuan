---
title: JDK 故障排除工具介绍
author: Scott
tags:
  - Java
  - JVM
categories:
  - 技术
date: 2019-07-03 12:24:00
---
下面的工具可以用来解决特定的故障排除任务。
本文中的工具目前还在试验阶段，不推荐使用，使用前请三思。在未来的 JDK 版本中可能会移除。有些工具目前无法在 Windows 平台上使用。

<!--more-->

<style>
table th:nth-of-type(1){
width: 10%;
}
table th:nth-of-type(2){
width: 55%;
}
table th:nth-of-type(3){
width: 35%;
}
</style>

|名称|介绍|文档链接|
|---|---|---|
|jinfo|Java 配置信息操作，打印指定的进程、核心文件、远程调试服务器的配置信息。| [[Solaris, Linux, and OS X](https://docs.oracle.com/javase/8/docs/technotes/tools/unix/jinfo.html)][[Windows](https://docs.oracle.com/javase/8/docs/technotes/tools/windows/jinfo.html)]|
| jhat | 堆dump信息查看操作，在对dump 文件（例如：jmap -dump）上启动一个web服务器，用来查看堆信息。|[[Solaris, Linux, and OS X](https://docs.oracle.com/javase/8/docs/technotes/tools/unix/jhat.html)] [[Windows](https://docs.oracle.com/javase/8/docs/technotes/tools/windows/jhat.html)]|
|jmap| Java 内存映射操作，打印给定对象、核心文件、远程调试服务器的共享对象内存映射或堆内存详细信息。|[[Solaris, Linux, and OS X](https://docs.oracle.com/javase/8/docs/technotes/tools/unix/jmap.html)] [[Windows](https://docs.oracle.com/javase/8/docs/technotes/tools/windows/jmap.html)]|
|jsadebugd| 使用代理调试Java 后台程序，连接到进程、核心文件，并充当调试服务器。| [[Solaris, Linux, and OS X](https://docs.oracle.com/javase/8/docs/technotes/tools/unix/jsadebugd.html)] [[Windows](https://docs.oracle.com/javase/8/docs/technotes/tools/windows/jsadebugd.html)]|
|jstack| Java 栈追踪操作，打印给定进程、核心文件、远程调试服务器的线程堆栈跟踪信息。| [[Solaris, Linux, and OS X](https://docs.oracle.com/javase/8/docs/technotes/tools/unix/jstack.html)] [[Windows](https://docs.oracle.com/javase/8/docs/technotes/tools/windows/jstack.html)]|

请参考 [Java™ SE Troubleshooting web site] 中有关工具、选项、和其他信息的描述来分析问题，文档包含了一些建议，如在提交错误报告之前要尝试什么，以及为报告收集什么数据等。