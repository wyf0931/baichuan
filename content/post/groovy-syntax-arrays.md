---
title: Groovy 语法 - 数组
author: Scott
tags:
  - Groovy
categories:
  - Groovy
  - 技术
date: 2019-06-28 11:27:00
---
Groovy 复用了列表的方括号作为数组的符号，但是为了制作这样的文字数组，你需要通过强制或类型声明来明确地定义数组的类型。
```groovy
// 使用显式变量类型声明定义字符串数组
String[] arrStr = ['Ananas', 'Banana', 'Kiwi']  

// 断言我们创建了一个字符串数组
assert arrStr instanceof String[]    
assert !(arrStr instanceof List)

// 使用 as 运算符创建一个 int 数组
def numArr = [1, 2, 3] as int[]      

// 断言我们创建了一个原始 int 数组
assert numArr instanceof int[]       
assert numArr.size() == 3
```

创建多维数组：
```groovy
// 定义新数组的边界
def matrix3 = new Integer[3][3]         
assert matrix3.size() == 3

// 声明一个数组而不指定其边界
Integer[][] matrix2                     
matrix2 = [[1, 2], [3, 4]]
assert matrix2 instanceof Integer[][]
```

对数组元素的访问遵循与列表相同的表示法：
```groovy
// 检索数组的第一个元素
String[] names = ['Cédric', 'Guillaume', 'Jochen', 'Paul']
assert names[0] == 'Cédric'     

// 将数组的第三个元素的值设置为新值
names[2] = 'Blackdrag'          
assert names[2] == 'Blackdrag'
```
**Groovy 中是不支持 Java 数组花括号的初始化方式**，因为花括号可能与Groovy闭包的符号含义有冲突。

> 原文地址：http://groovy-lang.org/syntax.html