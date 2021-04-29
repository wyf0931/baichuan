---
title: Groovy 语法 - Boolean
author: Scott
tags:
  - Groovy
categories:
  - 技术
date: 2019-06-28 17:05:00
---


Boolean 是一种特殊的数据类型，用于表示真值：`true` 和 `false`。将此数据类型用于跟踪真/假[条件](http://groovy-lang.org/syntax.html#_conditional_operators)的简单标志。

布尔值可以存储在变量中，分配到字段中，就像任何其他数据类型一样：
```groovy
def myBooleanVariable = true
boolean untypedBooleanVar = false
booleanField = true
```
`true` 和 `false`是唯一的两个原始布尔值。但是更复杂的布尔表达式可以使用[逻辑运算符](http://groovy-lang.org/syntax.html#_bitwise_and_logical_operators)表示。

此外，Groovy 有[特殊规则（通常称为 *Groovy Truth*）](http://docs.groovy-lang.org/latest/html/documentation/core-semantics.html#Groovy-Truth)，用于将非布尔对象强制转换为布尔值。



> 原文地址：http://groovy-lang.org/syntax.html