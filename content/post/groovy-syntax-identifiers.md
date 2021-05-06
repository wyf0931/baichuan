---
title: Groovy 语法 - 标识符
author: Scott
tags:
  - Groovy
categories:
  - Groovy
  - 技术
date: 2019-06-28 17:49:00
---
### 普通标识符
标识符以字母、$ 或下划线开头，不能以数字开头。字符必须在以下范围之内：

* 'a' ~ 'z'（小写 ascii 字符）
* 'A' ~ 'Z'（大写 ascii 字符）
* '\u00C0' ~ '\u00D6'
* '\u00D8' ~ '\u00F6'
* '\u00F8' ~ '\u00FF'
* '\u0100' ~ '\uFFFE'

后续字符可以是字母或数字。

这是一些有效的标识符示例（这些是变量名）：
```groovy
def name
def item3
def with_underscore
def $dollarStart
```

以下是无效的标识符：
```groovy
def 3tier
def a+b
def a#b
```
点号后的所有关键字也都是有效的标识符：
```groovy
foo.as
foo.assert
foo.break
foo.case
foo.catch
```

### 带引号的标识符
带引号的标识符出现在虚线表达式的点后面。 例如，`person.name` 表达式的 `name` 部分可以用 `person."name"` 或 `person.'name'`。 当某些标识符包含 Java语言规范禁止但在引用时 Groovy 允许的非法字符时，这一点尤其有趣。 例如，短划线、空格、感叹号等字符。
```groovy
def map = [:]

map."an identifier with a space and double quotes" = "ALLOWED"
map.'with-dash-signs-and-single-quotes' = "ALLOWED"

assert map."an identifier with a space and double quotes" == "ALLOWED"
assert map.'with-dash-signs-and-single-quotes' == "ALLOWED"
```

正如我们将在[下面的字符串部分](http://groovy-lang.org/syntax.html#all-strings)中看到的，Groovy 提供了不同的字符串文字。点后实际允许所有类型的字符串：
```groovy
map.'single quote'
map."double quote"
map.'''triple single quote'''
map."""triple double quote"""
map./slashy string/
map.$/dollar slashy string/$
```

普通字符串和 Groovy 的 GStrings（插值字符串）之间存在差异，因为在后一种情况下，插值将插入到最终字符串中以评估整个标识符：
```groovy
def firstname = "Homer"
map."Simpson-${firstname}" = "Homer Simpson"

assert map.'Simpson-Homer' == "Homer Simpson"
```

> 原文地址：http://groovy-lang.org/syntax.html