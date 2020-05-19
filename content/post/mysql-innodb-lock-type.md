---
title: MySQL InnoDB 锁类型介绍
author: Scott
tags:
  - MySQL
  - InnoDB
  - Lock
categories: []
date: 2019-07-03 12:24:00
---

本节介绍 InnoDB 的锁类型：

*   [共享和排他锁（Shared and Exclusive Locks）](https://docs.oracle.com/cd/E17952_01/mysql-5.5-en/innodb-locking.html#innodb-shared-exclusive-locks "Shared and Exclusive Locks")
*   [意向锁（Intention Locks）](https://docs.oracle.com/cd/E17952_01/mysql-5.5-en/innodb-locking.html#innodb-intention-locks "Intention Locks")
*   [记录锁（Record Locks）](https://docs.oracle.com/cd/E17952_01/mysql-5.5-en/innodb-locking.html#innodb-record-locks "Record Locks")
*   [区间锁 / 间隙锁（Gap Locks)](https://docs.oracle.com/cd/E17952_01/mysql-5.5-en/innodb-locking.html#innodb-gap-locks "Gap Locks")
*   [意向插入锁（Insert Intention Locks）](https://docs.oracle.com/cd/E17952_01/mysql-5.5-en/innodb-locking.html#innodb-insert-intention-locks "Insert Intention Locks")
*   [自增锁（AUTO-INC Locks）](https://docs.oracle.com/cd/E17952_01/mysql-5.5-en/innodb-locking.html#innodb-auto-inc-locks "AUTO-INC Locks")
*   [Next-Key Locks](https://docs.oracle.com/cd/E17952_01/mysql-5.5-en/innodb-locking.html#innodb-next-key-locks "Next-Key Locks")

## 共享和排他锁（Shared and Exclusive Locks）
InnoDB 实现了标准的行级锁，分为两种类型：[共享（`S`）锁](https://docs.oracle.com/cd/E17952_01/mysql-5.5-en/glossary.html#glos_shared_lock) 和 [排他（`X`）锁](https://docs.oracle.com/cd/E17952_01/mysql-5.5-en/glossary.html#glos_exclusive_lock)。
* [共享(`S`) 锁](https://docs.oracle.com/cd/E17952_01/mysql-5.5-en/glossary.html#glos_shared_lock "shared lock")允许持有该锁的事务读取行。
* [排他(`X`) 锁](https://docs.oracle.com/cd/E17952_01/mysql-5.5-en/glossary.html#glos_exclusive_lock "exclusive lock") 允许持有该锁的事务更新或删除行。

如果事务T1在行 r 上持有共享（S）锁，则其他事务T2对行 r 的锁的请求按如下方式处理：
* 可以立即授予T2对S锁的请求。 结果，T1和T2都在r上持有S锁。
* T2的X锁定请求不能立即授予。

如果事务T1在行r上持有排他（X）锁，则不能立即授予其他事务T2对r上任何类型的锁请求。相反，T2必须等待T1释放其对行r的锁定。

## 意向锁（Intention Locks）
**InnoDB支持多种粒度的锁，允许行锁和表锁共存。** 例如 [`LOCK TABLES ... WRITE`](https://docs.oracle.com/cd/E17952_01/mysql-5.5-en/lock-tables.html "13.3.5 LOCK TABLES and UNLOCK TABLES Syntax")
等语句在指定的表上持有排他锁（*X* 锁）。 InnoDB用意向锁来实现多粒度级别的锁。意向锁是表级锁，表示事务稍后对表中的行进行加相关类型的锁（共享或排他）。意向锁有两种类型：
* [意向共享锁（intention shared lock, IS）](https://docs.oracle.com/cd/E17952_01/mysql-5.5-en/glossary.html#glos_intention_shared_lock)表示事务打算在表中的各个行上设置共享锁。
* [意向排他锁（intention exclusive lock, IX）](https://docs.oracle.com/cd/E17952_01/mysql-5.5-en/glossary.html#glos_intention_exclusive_lock)表示事务打算在表中的各个行上设置排他锁。

例如 [`SELECT ... LOCK IN SHARE MODE`](https://docs.oracle.com/cd/E17952_01/mysql-5.5-en/select.html "13.2.9 SELECT Syntax") 设置`IS`锁， [`SELECT ... FOR UPDATE`](https://docs.oracle.com/cd/E17952_01/mysql-5.5-en/select.html "13.2.9 SELECT Syntax")设置`IX`锁定。

意向锁的规则如下：
* 事务在获取表中某行的共享锁之前，必须先获取表上的 *IS* 锁或类似的锁。
* 事务在获取表中某行的排他锁之前，必须先获取表上的 *IX* 锁。

下面是表级锁类型兼容性总结：

|当前事务现有的锁 / 其他事务的锁请求 |X |IX |S |IS|
|-|-|-|-|-|
|X|冲突|冲突|冲突|冲突|
|IX|冲突|兼容|冲突|兼容|
|S|冲突|冲突|兼容|兼容|
|IS|冲突|兼容|兼容|兼容|

如果事务请求的锁与现有锁兼容就授予锁，如果冲突则不会。 事务会一直等到现有的锁释放。如果因为事务请求的锁与现有的锁冲突而无法授予，则可能会导致发生[死锁（deadlock）](https://docs.oracle.com/cd/E17952_01/mysql-5.5-en/glossary.html#glos_deadlock "deadlock")错误。
除全表请求之外，意向锁不会阻塞任何事务（例如 [`LOCK TABLES ... WRITE`](https://docs.oracle.com/cd/E17952_01/mysql-5.5-en/lock-tables.html "13.3.5 LOCK TABLES and UNLOCK TABLES Syntax")）。意向锁的主要目的是表示某人正在锁定行，或将要锁定表中的行。
意向锁的事务数据与 [`SHOW ENGINE INNODB STATUS`](https://docs.oracle.com/cd/E17952_01/mysql-5.5-en/show-engine.html "13.7.5.16 SHOW ENGINE Syntax") 和 [InnoDB monitor](https://docs.oracle.com/cd/E17952_01/mysql-5.5-en/innodb-standard-monitor.html "14.20.3 InnoDB Standard Monitor and Lock Monitor Output")  输出中的以下内容类似：
```bash
TABLE LOCK table `test`.`t` trx id 10080 lock mode IX
```



## 记录锁（Record Locks）
记录锁是对索引记录的锁定。 例如，`SELECT c1 FROM t WHERE c1 = 10 FOR UPDATE;` 防止任何其他事务插入，更新或删除 t.c1 的值为 10 的行。

即使表没有定义索引，记录锁也能锁定索引记录。因为 InnoDB创建了一个隐藏的聚簇索引并使用此索引做记录锁。 请参见 [第14.11.2.1节“聚簇和二级索引”](https://docs.oracle.com/cd/E17952_01/mysql-5.5-en/innodb-index-types.html)。

记录锁的事务数据在SHOW ENGINE INNODB STATUS和InnoDB监视器输出中显示类似于以下内容：
```bash
RECORD LOCKS space id 58 page no 3 n bits 72 index `PRIMARY` of table `test`.`t` 
trx id 10078 lock_mode X locks rec but not gap
Record lock, heap no 2 PHYSICAL RECORD: n_fields 3; compact format; info bits 0
 0: len 4; hex 8000000a; asc     ;;
 1: len 6; hex 00000000274f; asc     'O;;
 2: len 7; hex b60000019d0110; asc        ;;
```

## 区间锁 / 间隙锁（Gap Locks）
区间锁是锁定索引记录之间的区间，或锁定在第一个或最后一个索引记录之前的区间上。 例如，`SELECT c1 FROM t WHERE c1 BETWEEN 10 and 20 FOR UPDATE; ` 阻止其他事务将值15插入到列 t.c1 中，无论列中是否存在任何此类值，因为该范围内所有现有值之间的区间都被锁定。

区间可能跨越单个索引值，多个索引值，甚至可能为空。
区间锁是性能和并发之间权衡的一部分，用于某些事务隔离级别而不是其他级别。

使用唯一索引（unique index ）锁定行以搜索唯一行的语句不需要区间锁。（这不包括搜索条件仅包括多列唯一索引的一些列的情况; 在这种情况下，确实会发生区间锁定。）例如，如果`id`列具有唯一索引，则以下语句仅对 `id=100`的行使用索引记录锁，并且其他会话是否在前一个间隙中插入行无关紧要：
```sql
SELECT * FROM child WHERE id = 100;
```
如果 `id` 未编入索引或具有非唯一索引，则该语句会锁定前一个区间。

这里还值得注意的是，不同的事务在相同区间上可以存在相互冲突的锁类型。 例如，事务A可以在区间上持有共享区间锁（区间S锁），而事务B在同一区间上持有排他区间锁（区间X锁）。 允许区间锁冲突的原因是，如果从索引中清除记录，则必须合并由不同事务保留在记录上的区间锁。

在 InnoDB中区间锁被“抑制”了，这意味着它们的唯一目的是防止其他事务插入区间。区间锁可以共存。一个事务占用的区间锁定不会阻止另一个事务在同一个区间上进行区间锁定。 共享和排他区间锁之间没有区别。它们彼此不冲突，它们执行相同的功能。

如果将事务隔离级别更改为`READ COMMITTED`或启用系统变量`innodb_locks_unsafe_for_binlog`，就可以明确禁用区间锁。此时，搜索和索引扫描会禁用区间锁定，只能用于外键约束检查和重复键检查。

使用 [READ COMMITTED](https://docs.oracle.com/cd/E17952_01/mysql-5.5-en/innodb-transaction-isolation-levels.html#isolevel_read-committed) 隔离级别或启用 [innodb_locks_unsafe_for_binlog](https://docs.oracle.com/cd/E17952_01/mysql-5.5-en/innodb-parameters.html#sysvar_innodb_locks_unsafe_for_binlog) 还有其他影响。 MySQL评估 `WHERE` 条件后，将释放非匹配行的记录锁。对于 `UPDATE` 语句，InnoDB 执行“半一致（semi-consistent）”读取，以便将最新提交的版本返回给 MySQL，以便 MySQL 可以确定该行是否与 `UPDATE` 的 [`WHERE`](https://docs.oracle.com/cd/E17952_01/mysql-5.5-en/update.html) 条件匹配。

## Next-Key Locks
Next-Key锁是索引记录上的记录锁和索引记录之前的区间上的区间锁的组合。

InnoDB用以下方式执行行级锁定：当它搜索或扫描表索引时，它会在遇到的索引记录上设置共享锁或排它锁。 因此，**行级锁实际上是索引记录锁**。索引记录上的Next-Key锁也会影响该索引记录之前的“区间”。也就是说，Next-Key 锁是索引记录锁加上索引记录之前的区间上的区间锁。如果一个会话在索引记录R上具有共享锁或排他锁，则另一个会话不能在索引顺序中的R之前的区间中插入新的索引记录。

假设索引包含值10,11,13和20。此索引的可能的 Next-Key 锁定包括以下间隔，其中圆括号表示排除区间端点，方括号表示包含端点：
```bash
(-∞, 10]
(10, 11]
(11, 13]
(13, 20]
(20, +∞)
```
对于最后一个区间，Next-Key 锁将区间锁定在索引中最大值之上，而“supremum”伪记录的值高于索引中实际的任何值。supremum不是真正的索引记录，因此，实际上，此Next-Key锁仅锁定最大索引值之后的间隙。

默认情况下，InnoDB 在 [`REPEATABLE READ (RR)`](https://docs.oracle.com/cd/E17952_01/mysql-5.5-en/innodb-transaction-isolation-levels.html#isolevel_repeatable-read) 事务隔离级别运行，并禁用系统变量[`innodb_locks_unsafe_for_binlog`](https://docs.oracle.com/cd/E17952_01/mysql-5.5-en/innodb-parameters.html#sysvar_innodb_locks_unsafe_for_binlog) 。在这种情况下，InnoDB 使用 Next-Key 锁进行搜索和索引扫描，从而防止幻像行（参见 [Section 14.8.4, “Phantom Rows”](https://docs.oracle.com/cd/E17952_01/mysql-5.5-en/innodb-next-key-locking.html "14.8.4 Phantom Rows")）。

Next-Key 锁的事务数据与 [SHOW ENGINE INNODB STATUS](https://docs.oracle.com/cd/E17952_01/mysql-5.5-en/show-engine.html) 和 [InnoDB监视器](https://docs.oracle.com/cd/E17952_01/mysql-5.5-en/innodb-standard-monitor.html) 输出中的以下内容类似：

```bash
RECORD LOCKS space id 58 page no 3 n bits 72 index `PRIMARY` of table `test`.`t` 
trx id 10080 lock_mode X
Record lock, heap no 1 PHYSICAL RECORD: n_fields 1; compact format; info bits 0
 0: len 8; hex 73757072656d756d; asc supremum;;

Record lock, heap no 2 PHYSICAL RECORD: n_fields 3; compact format; info bits 0
 0: len 4; hex 8000000a; asc     ;;
 1: len 6; hex 00000000274f; asc     'O;;
 2: len 7; hex b60000019d0110; asc        ;;
```

## Insert Intention Locks
待翻译

## AUTO-INC Locks
*AUTO-INC* 锁是由插入到具有 `AUTO_INCREMENT` 列的表中的事务所采用的特殊表级锁*。在最简单的情况下，如果一个事务正在向表中插入值，则任何其他事务必须等待对该表执行自己的插入，以便第一个事务插入的行接收连续的主键值。

可以通过配置项 [`innodb_autoinc_lock_mode`](https://docs.oracle.com/cd/E17952_01/mysql-5.5-en/innodb-parameters.html#sysvar_innodb_autoinc_lock_mode) 调整自增锁算法，例如：调整自增序列和插入操作的最大并发。

请参考：[Section 14.11.1.5, “AUTO_INCREMENT Handling in InnoDB”](https://docs.oracle.com/cd/E17952_01/mysql-5.5-en/innodb-auto-increment-handling.html "14.11.1.5 AUTO_INCREMENT Handling in InnoDB").



> 原文 地址：https://docs.oracle.com/cd/E17952_01/mysql-5.5-en/innodb-locking.html