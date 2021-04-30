---
title: "MySQL事务处理"
author: Scott
tags:
  - MySQL
categories:
  - 技术
date: 2019-09-06 18:38:00
---
本文简单介绍事务特性、事务并发问题、 MySQL 事务隔离级别和相关操作语句。

<!--more-->

### 事务的特性（ACID）

- 原子性：事务开始后所有操作，要么全部做完，要么全部不做，不可能停滞在中间环节；
- 一致性：事务开始前和结束后，数据库的完整性约束没有被破坏 ；
- 隔离性：同一时间，只允许一个事务请求同一数据，不同的事务之间彼此没有任何干扰；
- 持久性：事务完成后，事务对数据库的所有更新将被保存到数据库，不能回滚。



### 事务并发问题

- **脏读（Dirty Read）**：一个事务读取了另外一个事务未提交的数据。
- **不可重复读（Non-Repeatable Read）**：在同一事务中，两次读取同一数据，得到内容不同（事务执行期间，其他事务在该数据上执行过 `update` 操作）。
- **幻读（Phantom Read）**：在一个事务的两次查询中数据记录数不一致（事务执行期间，其他事务进行过`insert` / `delete`操作）。



### MySQL 事务隔离级别

| 隔离级别                     |  脏读  | 不可重复读 |  幻读  |            锁            |
| ---------------------------- | :----: | :--------: | :----: | :----------------------: |
| NONE（无事务）               |   -    |     -      |   -    |            -             |
| READ_UNCOMMITTED（未提交读） |  可能  |    可能    |  可能  |            无            |
| READ_COMMITTED（已提交读）   | 不可能 |    可能    |  可能  |      写数据时会锁行      |
| REPEATABLE_READ（可重复读）  | 不可能 |   不可能   |  可能  | 没索引时更新数据会锁全表 |
| SERIALIZABLE（串行化）       | 不可能 |   不可能   | 不可能 |      读写都会锁全表      |

>  **注意：**
> MySQL 默认的事务处理级别是`TRANSACTION_REPEATABLE_READ`，也就是可重复读。



### MySQL 事务相关操作语句

查看当前会话隔离级别：

```mysql
select @@tx_isolation;
```

查看系统当前隔离级别：

```mysql
select @@global.tx_isolation;
```

设置事务的语法：

```mysql
SET [GLOBAL | SESSION] TRANSACTION transaction_characteristic [, transaction_characteristic]
```

其中，`transaction_characteristic` 定义如下：

```mysql
transaction_characteristic: {
    ISOLATION LEVEL level | access_mode
}

level: {
     REPEATABLE READ
   | READ COMMITTED
   | READ UNCOMMITTED
   | SERIALIZABLE
}

access_mode: {
     READ WRITE
   | READ ONLY
}
```

以下是一些使用案例，设置当前会话隔离级别：

```mysql
set session transaction isolation level repeatable read;
```

设置系统当前隔离级别：

```mysql
set global transaction isolation level repeatable read;
```

> **注意：**
>
> * 默认访问模式为 `READ WRITE` ，事务级别为 `REPEATABLE READ` 。
> * 访问模式设为 `READ ONLY`，则不允许其他事务在当前事务执行期间进行写操作，可以提升数据库性能。



相关文档：

* https://dev.mysql.com/doc/refman/5.7/en/innodb-transaction-isolation-levels.html
* https://dev.mysql.com/doc/refman/5.7/en/glossary.html#glos_dirty_read