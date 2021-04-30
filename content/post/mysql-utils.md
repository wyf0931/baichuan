---
title: "MySQL 常用语句"
date: 2021-04-29T16:53:21+08:00
draft: false
author: Scott
tags:
  - MySQL
categories:
  - 技术
---

**1、查看MySQL数据库版本：**

```mysql
select version();
```

**2、查看 table_xxx 表的建表语句：**

```mysql
show create table table_xxx;
```

**3、在 table_xxx 表中增加索引 idx_hhh：**

```mysql
ALTER TABLE `table_xxx` ADD INDEX `idx_hhh`(`col_a`, `col_b`, `col_c`);
```

**4、查看 table_xxx 表的 idx_hhh 索引详情：**

```mysql
show index from table_xxx where key_name = 'idx_hhh';
```

例如：

```mysql
mysql> SHOW INDEX FROM table_xxx
*************************** 1. row ***************************
        Table: table_xxx
   Non_unique: 0
     Key_name: height
 Seq_in_index: 1
  Column_name: height
    Collation: A
  Cardinality: 0
     Sub_part: NULL
       Packed: NULL
         Null: YES
   Index_type: BTREE
      Comment:
Index_comment:
1 row in set (0.03 sec)
```

查询结果字段说明：

| 字段名       | 说明                                                         |
| ------------ | ------------------------------------------------------------ |
| Table        | 表示创建索引的数据表名，这里是 table_xxx 数据表。            |
| Non_unique   | 表示该索引是否是唯一索引。若不是唯一索引，则该列的值为 1；若是唯一索引，则该列的值为 0。 |
| Key_name     | 表示索引的名称。                                             |
| Seq_in_index | 表示该列在索引中的位置，如果索引是单列的，则该列的值为 1；如果索引是组合索引，则该列的值为每列在索引定义中的顺序。 |
| Column_name  | 表示定义索引的列字段。                                       |
| Collation    | 表示列以何种顺序存储在索引中。在 MySQL 中，升序显示值“A”（升序），若显示为 NULL，则表示无分类。 |
| Cardinality  | 索引中唯一值数目的估计值。基数根据被存储为整数的统计数据计数，所以即使对于小型表，该值也没有必要是精确的。基数越大，当进行联合时，MySQL 使用该索引的机会就越大。 |
| Sub_part     | 表示列中被编入索引的字符的数量。若列只是部分被编入索引，则该列的值为被编入索引的字符的数目；若整列被编入索引，则该列的值为 NULL。 |
| Packed       | 指示关键字如何被压缩。若没有被压缩，值为 NULL。              |
| Null         | 用于显示索引列中是否包含 NULL。若列含有 NULL，该列的值为 YES。若没有，则该列的值为 NO。 |
| Index_type   | 显示索引使用的类型和方法（`BTREE`、`FULLTEXT`、`HASH`、`RTREE`）。 |
| Comment      | 显示备注信息。                                               |

**5、删除 table_xxx 表中的 idx_hhh 索引：**

```mysql
ALTER TABLE table_xxx DROP INDEX idx_hhh;
```

> 说明：
>
> MySQL中没有修改索引的逻辑，需要删除后重新建索引。

