---
title: JVM 平台相关 JMX Bean 介绍
author: Scott
tags:
  - JVM
  - JMX
categories:
  - 技术
date: 2019-07-03 12:05:00
---
本文介绍JVM 平台自带的一些 MXBean，及其所管理的虚拟机模块。
<!--more-->

平台 MXBean 是用于监控 JVM 和 JRE 的其他组件的 MBean。每个 MXBean 封装了 VM 功能的一部分，例如类加载系统、即时编译系统（JIT）、垃圾收集器等。

下表展示所有平台 MXBean 及其管理的 VM 的板块。每个平台 MXBean 都有一个唯一的 `javax.management.ObjectName` ，它在平台 MBean 服务器中注册时使用。 JVM 可以有每个 MXBean 的` [0~n]` 个实例，取决于其功能，如表中所示：

<style>
table th:nth-of-type(1){
width: 35%;
}
table th:nth-of-type(2){
width: 15%;
}
table th:nth-of-type(3){
width: 50%;
}
</style>

|接口|管理的 VM 板块|对象名称|
|---|---|---|
|ClassLoadingMXBean|类加载系统|java.lang:type= ClassLoading|
|CompilationMXBean|编译系统|java.lang:type= Compilation|
|GarbageCollectorMXBean|垃圾收集器|java.lang:type= GarbageCollector, name=collectorName|
|LoggingMXBean|日志系统|java.util.logging:type =Logging|
|MemoryManagerMXBean <br/>(GarbageCollectorMXBean 的子接口)|内存管理器|java.lang: typeMemoryManager, name=managerName|
|MemoryPoolMXBean|内存池|java.lang: type= MemoryPool, name=poolName|
|MemoryMXBean|内存|java.lang:type= Memory|
|OperatingSystemMXBean|底层操作系统|java.lang:type= OperatingSystem|
|RuntimeMXBean|运行时系统|java.lang:type= Runtime|
|ThreadMXBean|线程系统|java.lang:type= Threading|



> 原文地址：http://docs.oracle.com/javase/6/docs/technotes/guides/management/overview.html