---
title: Groovy 语法 - List
author: Scott
tags:
  - groovy
categories:
  - 技术
date: 2019-06-28 18:15:00
---
Groovy 用逗号分隔值，并用方括号括起来，用来表示列表（List）。Groovy 没有自己定义集合类，Groovy 列表本质是 JDK 的 `java.util.List`。List 默认的实现类是 `java.util.ArrayList`，你也可以自己指定其他实现类。
```groovy
// 定义一个由逗号分隔的数字型列表，并用方括号括起来，并将该列表指定给一个叫 numbers 的变量
def numbers = [1, 2, 3]         

// 该列表是 Java 的 java.util.List 接口的实例
assert numbers instanceof List  
// 可以使用 size() 方法查询列表的大小，并显示我们的列表包含3个元素
assert numbers.size() == 3 
```

在上面的示例中，我们使用了同类型列表，也可以创建包含不同类型值的列表：
```groovy
// 列表包含数字，字符串和布尔值
def heterogeneous = [1, "a", true]  
```
我们提到默认情况下，List 实际上是 `java.util.ArrayList` 的实例，但我们可以通过 `as` 类型强制运算符或显式类型声明的方式，指定 List 的其他实现类：
```groovy
def arrayList = [1, 2, 3]
assert arrayList instanceof java.util.ArrayList

// 使用 as 操作符指定实现类
def linkedList = [2, 3, 4] as LinkedList    
assert linkedList instanceof java.util.LinkedList

// 显式声明实现类的类型
LinkedList otherLinked = [3, 4, 5]          
assert otherLinked instanceof java.util.LinkedList
```
您可以使用 `[]` 下标运算符访问 List 的元素（包括读取和设定值）使用正索引或负索引来访问列表末尾的元素

您可以使用带有正索引或负索引的 `[]` 下标运算符（用于读取和设置值）访问 List 元素，以访问列表末尾的元素以及范围，并使用 `<<` 运算符将元素追加到列表：
```groovy
def letters = ['a', 'b', 'c', 'd']

// 访问列表的第一个元素（从0开始计数）
assert letters[0] == 'a'     
assert letters[1] == 'b'

// 使用负索引访问列表的最后一个元素：-1是列表末尾的第一个元素
assert letters[-1] == 'd'    
assert letters[-2] == 'c'

// 为列表的第三个元素设置新值
letters[2] = 'C'             
assert letters[2] == 'C'

// 使用 << 运算符在 List 的末尾附加元素
letters << 'e'               
assert letters[ 4] == 'e'
assert letters[-1] == 'e'

// 一次访问两个元素，返回包含这两个元素的新 List
assert letters[1, 3] == ['b', 'd']

// 可以通过指定范围从 List 中访问一段区间的值，从开始到结束元素位置
assert letters[2..4] == ['C', 'd', 'e'] 
```
由于 List 支持不同类型的元素，因此 List 还可以通过包含其他 List 来创建多维列表：
```groovy
// 定义数字List类型的列表
def multi = [[0, 1], [2, 3]]

// 访问最顶层列表的第二个元素，以及内部列表的第一个元素
assert multi[1][0] == 2
```

> 原文地址：http://groovy-lang.org/syntax.html