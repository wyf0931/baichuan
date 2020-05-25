---
title: "Inotify简介"
author: Scott
tags:
  - Linux
  - 定时任务
categories: []
date: 2020-05-25T19:49:39+08:00
draft: false
---

### 简介
Inotify 是一种强大的，细粒度的。异步的文件系统事件监控机制，linux 内核从2.6.13起，加入了 Inotify 支持，通过Inotify可以监控文件系统中添加、删除，修改、移动等各种事件,利用这个内核接口，第三方软件就可以监控文件系统下文件的各种变化情况，而` inotify-tools` 正是实施这样监控的软件。

**Inotify 实际是一种事件驱动机制**，它为应用程序监控文件系统事件提供了实时响应事件的机制，而无须通过诸如cron等的轮询机制来获取事件。cron等机制不仅无法做到实时性，而且消耗大量系统资源。相比之下，inotify基于事件驱动，可以做到对事件处理的实时响应，也没有轮询造成的系统资源消耗，是非常自然的事件通知接口，也与自然世界事件机制相符合。



 实现inotify机制的软件：

- inotify-tools
- sersync
- lrsyncd