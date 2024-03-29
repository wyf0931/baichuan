---
title: MySQL 整数类型介绍
author: Scott
tags:
  - MySQL
categories:
  - 技术
date: 2019-08-01 14:43:00
---
MySQL 支持 SQL 标准整数类型 `INTEGER`（`INT`）和 `SMALLINT`。作为标准的扩展，MySQL 还支持整数类型`TINYINT`、`MEDIUMINT` 和 `BIGINT`。

<!--more-->

下表显示了每种整数类型所需的存储空间和取值范围。

MySQL 支持的整数类型所需的存储和范围：

| 类型| 存储空间 (字节) | 最小值（有符号） | 最小值（无符号） | 最大值（有符号） | 最大值（无符号） |
| --- | ------ | -------- | -------- | ------- | ------|
| `TINYINT`| 1| -128| 0| 127| 255|
| `SMALLINT`  | 2| -32768| 0| 32767| 65535|
| `MEDIUMINT` | 3| -8388608| 0| 8388607| 16777215|
| `INT`| 4| -2147483648| 0| 2147483647| 4294967295|
| `BIGINT`| 8| -2<sup>63<sup>| 0 | 2<sup>63<sup>-1| 2<sup>64<sup>-1|

