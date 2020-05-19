---
title: Groovy 语法 - Map
author: Scott
tags:
  - groovy
categories: []
date: 2019-06-28 17:00:00
---
Map 有时在其他语言中称为字典或关联数组，Groovy 也有 Map 功能。

Map 将键与值相关联，**用冒号分隔键和值，使用逗号分隔每个键/值对，以及用方括号括起的整个键和值**。

```groovy
// 我们定义了一个颜色名称的 map，与它们的十六进制编码的 html 色值相映射
def colors = [red: '#FF0000', green: '#00FF00', blue: '#0000FF']   

// 我们使用下标符号来检查与 red 键相关联的内容
assert colors['red'] == '#FF0000'    
// 我们还可以使用属性表示法来断言颜色 green 的十六进制表示
assert colors.green  == '#00FF00'    

// 我们可以使用下标符号来添加新的键/值对
colors['pink'] = '#FF00FF' 
// 或者属性表示法，添加 yellow 
colors.yellow  = '#FFFF00'           

assert colors.pink == '#FF00FF'
assert colors['yellow'] == '#FFFF00'

assert colors instanceof java.util.LinkedHashMap
```
**当使用键的名称时，我们实际上在Map中定义了字符串键。Groovy创建的 map 实际上是`java.util.LinkedHashMap`的实例。**

**如果 map 中不存在对应的键，则返回 `null`**。例如：
```groovy
assert colors.unknown == null
```
在上面的例子中，我们用了字符串类型的键，你也可以使用其他类型的值作为键：
```groovy
def numbers = [1: 'one', 2: 'two']

assert numbers[1] == 'one'
```
在这里，我们使用数字作为键，因为数字可以明确地被识别为数字，因此Groovy不会像我们之前的例子那样创建字符串键。有种场景，你如果要传递一个变量代替键，让该变量的值成为键：
```groovy
// 与“Guillaume”名称关联的键实际上是“key”字符串，而不是与key变量关联的值
def key = 'name'
def person = [key: 'Guillaume']      

// map 不包含 'name' 键
assert !person.containsKey('name')   
// map 包含 'key' 键
assert person.containsKey('key')  
```
您还可以传递带引号的字符串以及键：` ["name": "Guillaume"]`。您的字符串键必需是有效的标识符，例如您想创建一个包含哈希的字符串键，如：`["street-name": "Main street"]`。

当您需要**在 map 定义中将变量值作为键传递时，必须用括号括起变量或表达式**：
```groovy
// 这一次，我们用括号括起key变量，让解析器传递变量而不是定义字符串的键
person = [(key): 'Guillaume']        

// map 包含 'name' 键
assert person.containsKey('name')    
// map 不包含 'key' 键
assert !person.containsKey('key')
```
> 原文链接：http://groovy-lang.org/syntax.html