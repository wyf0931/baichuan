---
title: 怎样修改 MySQL 中列大小或增删列？
author: Scott
tags:
  - MySQL
categories:
  - 技术
date: 2019-08-07 11:14:00
---
在系统运行过程中，经常会遇到实际数据长度超过预先设计的长度，此时就需要调整列大小。本文主要介绍如何在MySQL中调整列大小与列类型。

<!--more-->

### 调整列大小
SQL 语法：
```sql
ALTER TABLE table_name MODIFY col_name VARCHAR(size);
```
> 注：`VARCHAR` 类型是可变长度，所以`size` 指的是列长度的最大值；

例如：
```sql
ALTER TABLE students MODIFY name VARCHAR(30);
```

### 新增列
SQL 语法：
```sql
ALTER TABLE table_name ADD column_name datatype;
```
例如：
```sql
ALTER TABLE students ADD remark VARCHAR(100);
```

### 删除列
SQL 语法：
```sql
ALTER TABLE table_name DROP COLUMN column_name；
```

例如：
```sql
ALTER TABLE students DROP COLUMN remark;
```