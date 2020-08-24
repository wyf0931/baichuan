---
title: InnoDB 存储引擎架构
author: Scott
tags:
  - MySQL
  - InnoDB
  - 架构设计
categories:
  - 技术
date: 2019-08-01 14:20:00
---
InnoDB 是一种通用存储引擎，可以实现高可靠性与高性能。在 MySQL 5.7 中，InnoDB 是默认的 MySQL 存储引擎，若使用 `CREATE TABLE` 语句建表时未带 `ENGINE =` 的子句，系统会默认创建 InnoDB 表。

<!--more-->

下图展示了 InnoDB 存储引擎架构中的 in-memory 和 on-disk 组件结构。

![Figure 14.1 InnoDB 架构图](/images/pasted-21.png)

> 原文地址：https://dev.mysql.com/doc/refman/5.7/en/innodb-architecture.html

> 扩展阅读：
> 
> * [InnoDB In-Memory Structures](https://dev.mysql.com/doc/refman/5.7/en/innodb-in-memory-structures.html)
> * [InnoDB On-Disk Structures](https://dev.mysql.com/doc/refman/5.7/en/innodb-on-disk-structures.html)。
