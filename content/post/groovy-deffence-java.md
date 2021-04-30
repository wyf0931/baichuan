---
title: Groovy 与 Java 的区别
author: Scott
tags:
  - Java
  - Groovy
categories:
  - 技术
date: 2019-07-03 15:13:00
---
在 Groovy 语言设计之初，就遵从了 Least Surprise 原则，可以让 Java 程序员更快适应 Groovy。

我们列出了 Java 和 Groovy 之间的所有主要区别。

<!-- more -->

### 默认导入
Groovy 默认情况下导入以下包和类，可以不用显式的以 `import` 语句来导入它们：

* java.io.*
* java.lang.*
* java.math.BigDecimal
* java.math.BigInteger
* java.net.*
* java.util.*
* groovy.lang.*
* groovy.util.*

### 多方法（Multi-methods）
在 Groovy 中，将在运行时选择将调用的方法，称为运行时调度或多方法。这意味着将根据运行时参数的类型选择方法。在 Java 中是相反的：在编译时根据声明的类型选择方法。

下面的代码，编写为 Java 代码，可以在 Java 和 Groovy 中编译，但它的行为会有所不同：
```groovy
int method(String arg) {
    return 1;
}
int method(Object arg) {
    return 2;
}
Object o = "Object";
int result = method(o);
```
在 Java 中会有：
```java
assertEquals(2, result);
```
在 Groovy 中：
```groovy
assertEquals(1, result);
```
这是因为 Java 使用静态信息类型，即 `o` 被声明为 `Object`，而 Groovy 将在运行时选择实际调用方法。由于它是用 `String` 调用的，因此调用 `String` 版本。

### 数组初始化
在 Groovy 中，`{...}` 块保留用于闭包。这意味着您无法使用以下语法创建数组文字：
```java
int[] array = { 1, 2, 3}
```
你实际上必须使用：
```groovy
int[] array = [1,2,3]
```

### 包范围可见性
在 Groovy 中，省略字段上的修饰符不会导致像 Java 一样的包私有字段：
```java
class Person {
    String name
}
```
相反，它用于创建属性，即私有字段，关联的 getter 和关联的 setter。  
可以通过使用 `@PackageScope` 注释来创建包私有字段：
```groovy
class Person {
    @PackageScope String name
}
```

### ARM块
Groovy 不支持 Java 7 中的 ARM（自动资源管理，Automatic Resource Management）块。相反，Groovy 提供了依赖于闭包的各种方法，这些方法具有相同的效果，同时更具惯用性。例如：
```java
Path file = Paths.get("/path/to/file");
Charset charset = Charset.forName("UTF-8");
try (BufferedReader reader = Files.newBufferedReader(file, charset)) {
    String line;
    while ((line = reader.readLine()) != null) {
        System.out.println(line);
    }

} catch (IOException e) {
    e.printStackTrace();
}
```
可以像这样写：
```groovy
new File('/path/to/file').eachLine('UTF-8') {
   println it
}
```
或者，如果你想要一个更像 Java 的版本：
```groovy
new File('/path/to/file').withReader('UTF-8') { reader ->
   reader.eachLine {
       println it
   }
}
```
### 内部类
匿名内部类和嵌套类的实现遵循 Java 规范，但是您不应该删除 Java 语言规范并且不断地讨论不同的事情。完成的实现看起来很像我们为 `groovy.lang.Closure` 做的，有一些好处和一些差异。例如，访问私有字段和方法可能会成为一个问题，但另一方面，局部变量不一定是最终的。

##### 静态内部类
这是静态内部类的一个例子：
```groovy
class A {
    static class B {}
}

new A.B()
```
静态内部类的使用是最好的支持。如果你绝对需要一个内部类，你应该把它变成一个静态类。
##### 匿名内部类
```groovy
import java.util.concurrent.CountDownLatch
import java.util.concurrent.TimeUnit

CountDownLatch called = new CountDownLatch(1)

Timer timer = new Timer()
timer.schedule(new TimerTask() {
    void run() {
        called.countDown()
    }
}, 0)

assert called.await(10, TimeUnit.SECONDS)
```
##### 创建非静态内部类的实例
在 Java 中，可以这样做：
```java
public class Y {
    public class X {}
    public X foo() {
        return new X();
    }
    public static X createX(Y y) {
        return y.new X();
    }
}
```
Groovy 不支持 `y.new X()` 语法。相反，你必须编写新的 `X(y)`，如下面的代码所示：
```groovy
public class Y {
    public class X {}
    public X foo() {
        return new X()
    }
    public static X createX(Y y) {
        return new X(y)
    }
}
```
但是请注意，Groovy 支持使用一个参数调用方法而不提供参数。然后该参数的值为 `null`。基本上相同的规则适用于调用构造函数。例如，您可能会编写新的 `X()` 而不是新的 `X(this)`。由于这也可能是常规方式，我们尚未找到防止此问题的好方法。

### Lambda表达式
Java 8 支持 lambda 和方法引用：
```java
Runnable run = () -> System.out.println("Run");
list.forEach(System.out::println);
```

Java 8 lambda 可以或多或少地被视为匿名内部类。 Groovy 不支持该语法，但可以通过闭包代替：
```groovy
Runnable run = { println 'run' }
list.each { println it } // or list.each(this.&println)
```

### 字符串和字符
Groovy 中单引号文字用于 `String`，而双引号结果用于 `String` 或 `GString`，具体取决于文字中是否有插值。
```groovy
assert 'c'.getClass()==String
assert "c".getClass()==String
assert "c${1}".getClass() in GString
```
只有在分配给 char 类型的变量时，Groovy 才会自动将单字符 String 转换为 char。当使用 char 类型的参数调用方法时，我们需要显式转换或确保已提前转换值。
```groovy
char a='a'
assert Character.digit(a, 16)==10 : 'But Groovy does boxing'
assert Character.digit((char) 'a', 16)==10

try {
  assert Character.digit('a', 16)==10
  assert false: 'Need explicit cast'
} catch(MissingMethodException e) {
}
```

Groovy 支持两种类型的转换，在转换为 char 时，在转换多字符串时存在细微差别。 Groovy 样式转换更宽松，将采用第一个字符，而 `C` 样式转换将失败并抛异常。
```groovy
// for single char strings, both are the same
assert ((char) "c").class==Character
assert ("c" as char).class==Character

// for multi char strings they are not
try {
  ((char) 'cx') == 'c'
  assert false: 'will fail - not castable'
} catch(GroovyCastException e) {
}
assert ('cx' as char) == 'c'
assert 'cx'.asType(char) == 'c'
```

### 原始类型与包装
因为 Groovy 将 Object 用于所有内容，所以它会自动对基元进行引用。因此，它不遵循 Java 的扩展行为优先于包装。这是一个使用 int 的例子：
```groovy
int i
m(i)

// 这是 Java 可以调用的方法，因为扩展优先于取消装箱。
void m(long l) {
  println "in m(long)"
}

// 这是 Groovy 实际调用的方法，因为所有原始引用都使用它们的包装类。
void m(Integer i) {
  println "in m(Integer)"
}
```

### `==` 的定义
在 Java 中 `==` 表示基本类型或对象标识的相等性。在 Groovy 中 `==` 转换为 `a.compareTo(b)== 0`，如果它们是 Comparable，则转换为 `a.equals(b)`。可以用 `is` 关键字来检查身份，例如： `a.is(b)`。

### 扩展关键字
Groovy 中的关键字比 Java 中的更多。不要将它们用于变量名称等。

* `as`
* `def`
* `in`
* `trait`

> 原文地址：http://www.groovy-lang.org/differences.html