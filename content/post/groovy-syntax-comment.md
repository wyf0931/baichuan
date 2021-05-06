---
title: Groovy 语法 - 注释
author: Scott
tags:
  - Groovy
categories:
  - Groovy
  - 技术
date: 2019-06-28 17:41:00
---
Groovy 的语法源自 Java 语法，但 Groovy 的特定构造对其进行了增强，并允许某些简化。

### 单行注释
单行注释以 `//` 开头，可以在行中的任何位置找到。`//` 直到行尾的字符被视为注释的一部分。
```groovy
// a standalone single line comment
println "hello" // a comment till the end of the line
```
### 多行注释
多行注释以 `/*` 开头，可以在行中的任何位置找到。`/*` 后面的字符将被视为注释的一部分，包括换行符，直到第一个 `*/` 结束注释。因此，多行注释可以放在语句的末尾，甚至可以放在语句中。
```groovy
/* a standalone multiline comment
   spanning two lines */
println "hello" /* a multiline comment starting
                   at the end of a statement */
println 1 /* one */ + 2 /* two */
```

### GroovyDoc 注释
与多行注释类似，GroovyDoc 注释也是多行的，但是以 `/**` 开头并且以 `*/` 结尾。第一个 GroovyDoc 注释行后面的行可以选择以星号 `*` 开头。这些注释与以下信息相关：
* 类型定义（类、接口、枚举、注解）
* 字段和属性定义
* 方法定义

虽然编译器不会抱怨 GroovyDoc 注释与上述语言元素没有关联，但是你应该在它之前添加注释的前缀。
```groovy
/**
 * A Class description
 */
class Person {
    /** the name of the person */
    String name

    /**
     * Creates a greeting method for a certain person.
     *
     * @param otherPerson the person to greet
     * @return a greeting message
     */
    String greet(String otherPerson) {
       "Hello ${otherPerson}"
    }
}
```
GroovyDoc 遵循与 Java 自己的 JavaDoc 相同的约定。因此，您将能够使用与JavaDoc 相同的标记。

### Shebang 行
除了单行注释之外，还有一个特殊的行注释，通常称为UNIX系统可以理解的 *shebang* 行，允许直接从命令行运行脚本，前提是您已经安装了 Groovy 发行版并且 `groovy` 命令可用于 `PATH`。
```bash
#!/usr/bin/env groovy
println "Hello from the shebang line"
```
`＃` 字符必须是文件的第一个字符。任何缩进都会产生编译错误。

> 原文地址：http://groovy-lang.org/syntax.html