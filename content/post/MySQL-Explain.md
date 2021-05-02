---
title: "MySQL Explain 执行计划"
date: 2021-04-30T17:54:04+08:00
author: Scott
tags:
  - MySQL
categories:
  - 技术
draft: false
---

在日常工作中，我们都会开启 MySQL [慢查询日志（Slow Query Log）](https://dev.mysql.com/doc/refman/5.7/en/slow-query-log.html) 来记录一些执行时间比较长的 SQL 语句，然后用 `explain` 命令来查看一个该 SQL 语句的执行计划，查看该 SQL 语句有没有使用索引，有没有全表扫描等，在分析清楚问题根因后做进一步优化。

<!--more-->

以下面的 SQL 为例：

```mysql
-- 实际SQL，查找用户名为张三的员工
select * from emp where name = '张三';
-- 查看SQL是否使用索引，前面加上explain即可
explain select * from emp where name = '张三';
```

![img](https://blog-1252438081.cos.ap-shanghai.myqcloud.com/img/512541-20180803142201303-545775900.png)

`expain` 的结果会有 10 列，分别是：id、select_type、table、type、possible_keys、key、key_len、ref、rows、Extra。

当使用 `FORMAT = JSON` 时，第二列在输出中显示的等效属性名。

| Column          | **JSON Name**   | **含义**                           |
| --------------- | --------------- | ---------------------------------- |
| `id`            | `select_id`     | `SELECT`  标识符                   |
| `select_type`   | `None`          | `SELECT`  类型                     |
| `table`         | `table_name`    | 输出行所对应的表                   |
| `partitions`    | `partitions`    | 匹配的分区                         |
| `type`          | `access_type`   | 连接（`join`）类型                 |
| `possible_keys` | `possible_keys` | 可以选择的可能索引                 |
| `key`           | `key`           | 实际上选择的索引                   |
| `key_len`       | `key_length`    | 所选 `key` 的长度                  |
| `ref`           | `ref`           | 与索引相比较的列                   |
| `rows`          | `rows`          | 要检查的行的估计数                 |
| `filtered`      | `filtered`      | 按表条件过滤的行占全表数据的百分比 |
| `Extra`         | `None`          | 执行情况的描述和补充说明           |



### 概要描述：

- **id**：选择标识符；
- **select_type**：表示查询的类型；
- **table**：输出结果集的表；
- **partitions**：匹配的分区；
- **type**：表示表的连接类型；
- **possible_keys**：表示查询时，可能使用的索引；
- **key**：表示实际使用的索引；
- **key_len**：索引字段的长度；
- **ref**：列与索引的比较；
- **rows**：扫描出的行数(估算的行数)；
- **filtered**：按表条件过滤的行百分比；
- **Extra**：执行情况的描述和说明；

下面会对这些字段出现的可能进行解释。

#### 一、 id

id 列表示 `select` 识别符，这是 `select` 的查询序列号，也是顺序标识，SQL 从大到小的执行。

1. `id` 相同时，执行顺序由上至下；

2. 如果是子查询，`id` 的序号会递增，`id` 值越大优先级越高，越先被执行；

3. `id` 如果相同，可以认为是一组，从上往下顺序执行；在所有组中，`id` 值越大，优先级越高，越先执行；

```mysql
-- 查看在研发部并且名字以Jef开头的员工，经典查询
explain select e.no, e.name from emp e left join dept d on e.dept_no = d.no where e.name like '张%' and d.name = '研发部';
```

![img](https://blog-1252438081.cos.ap-shanghai.myqcloud.com/img/512541-20180803143413064-173136748.png)

#### 二、select_type

select_type 列表示查询中每个 `select` 子句的类型：

- **SIMPLE**：简单 `select`，不使用 `union` 或子查询等；

- **PRIMARY**：子查询中最外层查询，查询中若包含任何复杂的子部分，最外层的 `select` 被标记为 `PRIMARY`；

- **UNION**：`union` 中的第二个或后面的 `select` 语句；

- **DEPENDENT UNION**：`union` 中的第二个或后面的 `select` 语句，取决于外面的查询；

- **UNION RESULT**：`union` 的结果，`union` 语句中第二个 `select` 开始后面所有 `select`；

- **SUBQUERY**：子查询中的第一个 `select`，结果不依赖于外部查询；

- **DEPENDENT SUBQUERY**：子查询中的第一个 `select`，依赖于外部查询；

- **DERIVED**：派生表的 `select`，`from` 子句的子查询；

- **UNCACHEABLE SUBQUERY**：一个子查询的结果不能被缓存，必须重新评估外链接的第一行。

#### 三、table

table 列表示这一步所访问数据库中表名称（显示这一行的数据是关于哪张表的），有时不是真实的表名字，可能是简称，例如上面的e，d，也可能是第几步执行的结果的简称。 

#### 四、type

type 列表示 MySQL 在表中找到所需行的方式，又称“访问类型”。

**常用的类型有： ALL、index、range、 ref、eq_ref、const、system、NULL（从左到右，性能从差到好）。** 

- **ALL**：Full Table Scan， MySQL 将遍历全表以找到匹配的行；

- **index**： Full Index Scan，index 与 ALL 区别为 index 类型只遍历索引树；

- **range**：只检索给定范围的行，使用一个索引来选择行；

- **ref**： 表示上述表的连接匹配条件，即哪些列或常量被用于查找索引列上的值；

- **eq_ref**： 类似 ref，区别就在使用的索引是唯一索引，对于每个索引键值，表中只有一条记录匹配，简单来说，就是多表连接中使用primary key 或者 unique key 作为关联条件；

- **const**、**system**： 当 MySQL 对查询某部分进行优化，并转换为一个常量时，使用这些类型访问。如将主键置于 `where` 列表中，MySQL就能将该查询转换为一个常量，system 是 const 类型的特例，当查询的表只有一行的情况下，使用 system；

- **NULL**： MySQL 在优化过程中分解语句，执行时甚至不用访问表或索引，例如从一个索引列里选取最小值可以通过单独索引查找完成。

#### 五、possible_keys

possible_keys  列表示 MySQL 能使用哪个索引在表中找到记录，查询涉及到的字段上若存在索引，则该索引将被列出，但不一定被查询使用（该查询可以利用的索引，如果没有任何索引显示 NULL）。

该列完全独立于 `explain` 输出所示的表的次序。这意味着在 possible_keys 中的某些键实际上不能按生成的表次序使用。
如果该列是 NULL，则没有相关的索引。在这种情况下，可以通过检查 `where` 子句看是否它引用某些列或适合索引的列来提高你的查询性能。如果是这样，创造一个适当的索引并且再次用 `explain` 检查查询。

#### 六、Key

key 列表示 MySQL 实际决定使用的键（索引），必然包含在 possible_keys 中。

如果没有选择索引，key 是 NULL。要想强制 MySQL 使用或忽视 possible_keys 列中的索引，在查询中使用 `force index`、`use index` 或者 `ignore index`。

#### 七、key_len

key_len 列表示索引中使用的字节数，可通过该列计算查询中使用的索引的长度（key_len 显示的值为索引字段的最大可能长度，并非实际使用长度，即 key_len 是根据表定义计算而得**，**不是通过表内检索出的）。

不损失精确性的情况下，长度越短越好。

#### 八、ref

ref 列与索引的比较，表示上述表的连接匹配条件，即哪些列或常量被用于查找索引列上的值。

#### 九、rows

 rows 列表示估算出结果集行数，表示 MySQL 根据表统计信息及索引选用情况，估算的找到所需的记录所需要读取的行数。

#### 十、Extra

Extra 列表示列包含MySQL解决查询的详细信息,有以下几种情况：

- **Using where**：不用读取表中所有信息，仅通过索引就可以获取所需数据，这发生在对表的全部的请求列都是同一个索引的部分的时候，表示 MySQL 服务器将在存储引擎检索行后再进行过滤；

- **Using temporary**：表示 MySQL 需要使用临时表来存储结果集，常见于排序和分组查询，常见 `group by` 、`order by`；

- **Using filesort**：当 Query 中包含 `order by` 操作，而且无法利用索引完成的排序操作称为“文件排序”；

```mysql
-- 测试Extra的filesort
explain select * from emp order by name;
```

- **Using join buffer**：改值强调了在获取连接条件时没有使用索引，并且需要连接缓冲区来存储中间结果。如果出现了这个值，那应该注意，根据查询的具体情况可能需要添加索引来改进能；

- **Impossible where**：这个值强调了`where` 语句会导致没有符合条件的行（通过收集统计信息不可能存在结果）；

- **Select tables optimized away**：这个值意味着仅通过使用索引，优化器可能仅从聚合函数结果中返回一行；

- **No tables used**：Query 语句中使用 `from dual` 或不含任何 `from` 子句。

```mysql
-- explain select now() from dual;
```

#### 总结：

- `explain` 不会告诉你关于触发器、存储过程的信息或用户自定义函数对查询的影响情况；
- `explain` 不考虑各种 Cache；
- `explain` 不能显示 MySQL 在执行查询时所作的优化工作；
- 部分统计信息是估算的，并非精确值；
- `explain` 只能解释 `select` 操作，其他操作要重写为 `select` 后查看执行计划。

通过收集统计信息不可能存在结果 。