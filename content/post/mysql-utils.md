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

查询结果说明：
- Table：
- Non_unique
- Key_name：
- Seq_in_index：
- Column_name：
- Collation：
- Cardinality：
- Sub_part：
- Packed：
- Index_type：

**5、删除 table_xxx 表中的 idx_hhh 索引：**

```mysql
ALTER TABLE table_xxx DROP INDEX idx_hhh;
```

> 说明：
>
> MySQL中没有修改索引的逻辑，需要删除后重新建索引。

