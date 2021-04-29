---
title: MySQL InnoDB Table 最佳实践
author: Scott
tags:
  - MySQL
  - InnoDB
categories:
  - 技术
date: 2019-07-03 14:32:00
draft: false
---
本文总结了一些 MySQL InnoDB 引擎中关于表的一些最佳实践。
<!--more-->

* 给每张表指定一个[主键](https://dev.mysql.com/doc/refman/5.7/en/glossary.html#glos_primary_key)，可以用最常用的单列或多列，假如没有明显的主键，也可以用[自增](https://dev.mysql.com/doc/refman/5.7/en/glossary.html#glos_auto_increment) 值作为主键；
* 基于表中共同的ID，可以使用 [join](https://dev.mysql.com/doc/refman/5.7/en/glossary.html#glos_join "join") 方式从多张表中获取数据。为了性能更好，建议在 join 相关列上定义 [外键](https://dev.mysql.com/doc/refman/5.7/en/glossary.html#glos_foreign_key "foreign key")，并且要与其他表中相同列的字段类型保持一致。加外键的列要保证被引用的列已经建了索引，这样可以提高性能。外键还会将删除、更新传播到所有受影响的表，如果父表中不存在相应的ID，则会阻止在子表中插入数据。

* 关闭 [autocommit](https://dev.mysql.com/doc/refman/5.7/en/glossary.html#glos_autocommit "autocommit")，每秒数以百计次的提交会影响性能（受存储设备写入速度的限制）；
* 将相关 [DML](https://dev.mysql.com/doc/refman/5.7/en/glossary.html#glos_dml) 操作集合分组到 [事务](https://dev.mysql.com/doc/refman/5.7/en/glossary.html#glos_transaction "transaction") 中，用 `START TRANSACTION` 和 `COMMIT` 语句括起来。虽然我们不想时时 COMMIT，但也不希望积累大量没有 COMMIT 的 [`INSERT`](https://dev.mysql.com/doc/refman/5.7/en/insert.html "13.2.5 INSERT Syntax")、[`UPDATE`](https://dev.mysql.com/doc/refman/5.7/en/update.html "13.2.11 UPDATE Syntax") 或 [`DELETE`](https://dev.mysql.com/doc/refman/5.7/en/delete.html "13.2.2 DELETE Syntax") 语句；
* 不要用  [`LOCK TABLES`](https://dev.mysql.com/doc/refman/5.7/en/lock-tables.html "13.3.5 LOCK TABLES and UNLOCK TABLES Syntax") 语句，InnoDB 可以在不牺牲可靠性或高性能的前提下，允许多个会话同时读取和写入同一个表。如果想要获得一组行的独占写访问权，可以用 [`SELECT ... FOR UPDATE`](https://dev.mysql.com/doc/refman/5.7/en/innodb-locking-reads.html "14.7.2.4 Locking Reads") 锁定要更新的行；
* 启用 [`innodb_file_per_table`](https://dev.mysql.com/doc/refman/5.7/en/innodb-parameters.html#sysvar_innodb_file_per_table) 选项，使用通用表空间将表的数据和索引放入单独的文件中，别放在 [系统表空间](https://dev.mysql.com/doc/refman/5.7/en/glossary.html#glos_system_tablespace) 中， [`innodb_file_per_table`](https://dev.mysql.com/doc/refman/5.7/en/innodb-parameters.html#sysvar_innodb_file_per_table) 选项默认是启用的；
* 可以在不牺牲 读/写 性能的情况下使用 InnoDB 表或页 [压缩](https://dev.mysql.com/doc/refman/5.7/en/glossary.html#glos_compression) 功能；
* 推荐在启动应用服务时加上参数 [`--sql_mode=NO_ENGINE_SUBSTITUTION`](https://dev.mysql.com/doc/refman/5.7/en/server-system-variables.html#sysvar_sql_mode) 。可以防止因 [`CREATE TABLE`](https://dev.mysql.com/doc/refman/5.7/en/create-table.html "13.1.18 CREATE TABLE Syntax") 语句带 `ENGINE=` 所导致的将表建在不同引擎上的问题。

> 原文地址：https://dev.mysql.com/doc/refman/5.7/en/innodb-best-practices.html