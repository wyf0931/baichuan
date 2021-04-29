---
title: "Java8 Nashorn教程（Javascript引擎）"
author: Scott
tags:
  - Java
categories:
  - 技术
date: 2020-07-09T11:58:00+08:00
draft: false
---

本文将通过简单易懂的代码示例来了解 Nashorn Javascript 引擎。Nashorn Javascript 引擎是 Java SE 8 的一部分，与其他独立的引擎如 Google V8 (为 Google Chrome 和 Node.js 提供动力的引擎) 竞争。Nashorn 通过在 JVM 上本地运行动态 javascript 代码来扩展 Java 功能。

在接下来的15分钟里，您将学习如何在运行时动态地执行  JVM 上的 Javascript。最新的 Nashorn 语言特性通过一些小的代码示例进行了演示。您将学习如何从 Java 代码调用 Javascript 函数，反之亦然。最后，您可以将动态脚本集成到您的日常 Java 业务中。



### 使用 Nashorn

Nashorn Javascript 引擎可以在 JAVA 中通过编程方式使用，也可以通过命令行工具 `jjs` 使用，`jjs` 位于 `$JAVA_HOME/bin` 中。如果你打算使用 `jjs`，你可能需要设置一个链接：

```shell
$ cd /usr/bin
$ ln -s $JAVA_HOME/bin/jjs jjs
$ jjs
jjs> print('Hello World');
```

本教程主要介绍如何在 Java 代码中使用 Nashorn，因此我们暂时跳过 `jjs`。一个简单的 Java 代码 `HelloWorld` 看起来像这样:

```java
ScriptEngine engine = new ScriptEngineManager().getEngineByName("nashorn");
engine.eval("print('Hello World!');");
```

为了评估来自 java 的 javascript 代码，首先利用 [Rhino](https://developer.mozilla.org/en-US/docs/Rhino) (来自 Mozilla 的 Javas legacy js engine)中已知的 `javax.script` 包创建一个遍布各个角落的脚本引擎。

Javascript 代码可以直接通过传递 Javascript 代码作为字符串进行计算，如上所示。或者你可以传递一个文件阅读器指向你的。脚本文件:

```java
ScriptEngine engine = new ScriptEngineManager().getEngineByName("nashorn");
engine.eval(new FileReader("script.js"));
```

Nashorn 的 javascript 基于 [ECMAScript 5.1](http://es5.github.io/)，但是未来版本的纳什霍恩将支持 ECMAScript 6:

> Nashorn 目前的战略是遵循 ECMAScript 规范。当我们发布 JDK 8时，我们将与 ECMAScript 5.1保持一致。Nashorn 的后续版本将与 [ECMAScript 第6版](http://wiki.ecmascript.org/doku.php?id=harmony:specification_drafts)保持一致。

Nashorn 为 ECMAScript 标准定义了许多语言和 API 扩展。但是首先让我们看看 java 和 javascript 代码之间的通信是如何工作的。

### 在 Java 中调用 Javascript 函数

Nashorn 支持直接从 java 代码调用脚本文件中定义的 javascript 函数。您可以将 java 对象作为函数参数传递，并将数据从函数返回给调用的 java 方法。

下面的 javascript 函数稍后将从 java 端调用:

```javascript
var fun1 = function(name) {
    print('Hi there from Javascript, ' + name);
    return "greetings from javascript";
};

var fun2 = function (object) {
    print("JS Class Definition: " + Object.prototype.toString.call(object));
};
```

为了调用一个函数，你首先需要将脚本引擎强制转换到 `Invocable`。可调用接口是由 `NashornScriptEngine` 实现实现的，并定义了一个方法 `invokeFunction` 来调用给定名称的 javascript 函数。

```java
ScriptEngine engine = new ScriptEngineManager().getEngineByName("nashorn");
engine.eval(new FileReader("script.js"));

Invocable invocable = (Invocable) engine;

Object result = invocable.invokeFunction("fun1", "Peter Parker");
System.out.println(result);
System.out.println(result.getClass());

// Hi there from Javascript, Peter Parker
// greetings from javascript
// class java.lang.String
```

执行代码将导致写入控制台的三行代码。调用函数 `print` 将结果通过管道传递给 `System.out`，因此我们首先看到 javascript 消息。

现在让我们通过传递任意的 java 对象来调用第二个函数:

```java
invocable.invokeFunction("fun2", new Date());
// [object java.util.Date]

invocable.invokeFunction("fun2", LocalDateTime.now());
// [object java.time.LocalDateTime]

invocable.invokeFunction("fun2", new Person());
// [object com.winterbe.java8.Person]
```

Java 对象可以在不丢失 javascript 端的任何类型信息的情况下传递。由于脚本本身在 JVM 上运行，我们可以充分利用 nashorn 上的 Java API 或外部库的能力。

### 在 Javascript 中调用 Java 方法

从 javascript 中调用 java 方法非常简单，我们首先定义一个静态 java 方法:

```java
static String fun1(String name) {
    System.out.format("Hi there from Java, %s", name);
    return "greetings from java";
}
```

可以通过 `Java.type` API 扩展从 javascript 引用 Java 类。它类似于用 java 代码导入类。一旦定义了 java 类型，我们自然地调用静态方法 `fun1()` 并将结果打印到 `sout`。因为该方法是静态的，所以我们不必先创建一个实例。

```java
var MyJavaClass = Java.type('my.package.MyJavaClass');

var result = MyJavaClass.fun1('John Doe');
print(result);

// Hi there from Java, John Doe
// greetings from java
```

当使用本地 javascript 类型调用 java 方法时，Nashorn 是如何处理类型转换的？让我们用一个简单的例子来说明。

下面的 java 方法只是打印方法参数的实际类型:

```java
static void fun2(Object object) {
    System.out.println(object.getClass());
}
```

为了理解类型转换是如何处理的，我们用不同的 javascript 类型来调用这个方法:

```javascript
MyJavaClass.fun2(123);
// class java.lang.Integer

MyJavaClass.fun2(49.99);
// class java.lang.Double

MyJavaClass.fun2(true);
// class java.lang.Boolean

MyJavaClass.fun2("hi there")
// class java.lang.String

MyJavaClass.fun2(new Number(23));
// class jdk.nashorn.internal.objects.NativeNumber

MyJavaClass.fun2(new Date());
// class jdk.nashorn.internal.objects.NativeDate

MyJavaClass.fun2(new RegExp());
// class jdk.nashorn.internal.objects.NativeRegExp

MyJavaClass.fun2({foo: 'bar'});
// class jdk.nashorn.internal.scripts.JO4
```

基本的 javascript 类型被转换为适当的 java 包装器类。相反，本地 javascript 对象由内部适配器类表示。请记住，来自 `jdk.nashorn.internal` 的类可能会发生更改，因此您不应该在客户机代码中针对这些类编程:

> 任何有内在标记的东西都可能会从你的内心发生改变。

### ScriptObjectMirror

当将本地 javascript 对象传递给 java 时，您可以利用类 `ScriptObjectMirror`，它实际上是基础 javascript 对象的 java 表示形式。`ScriptObjectMirror` 实现了映射接口，驻留在包 `jdk.nashorn.api` 中。此包中的类用于在客户机代码中使用。

下一个示例将参数类型从 `Object` 改为 `scriptjectmirror`，这样我们就可以从传递的 javascript 对象中提取一些信息:

```java
static void fun3(ScriptObjectMirror mirror) {
    System.out.println(mirror.getClassName() + ": " +
        Arrays.toString(mirror.getOwnKeys(true)));
}
```

当传递一个对象散列到这个方法时，属性在 java 端是可访问的:

```javascript
MyJavaClass.fun3({
    foo: 'bar',
    bar: 'foo'
});

// Object: [foo, bar]
```

我们也可以从 java 中调用 javascript 对象上的成员函数。让我们首先定义一个带有属性 `firstName` 和 `lastName` 的 javascript 类型 `Person` 和方法 `getFullName`。

```javascript
function Person(firstName, lastName) {
    this.firstName = firstName;
    this.lastName = lastName;
    this.getFullName = function() {
        return this.firstName + " " + this.lastName;
    }
}
```

Javascript 方法 `getFullName` 可以通过 `callMember() ` 在 `ScriptObjectMirror` 上调用。

```java
static void fun4(ScriptObjectMirror person) {
    System.out.println("Full Name is: " + person.callMember("getFullName"));
}
```

当将一个新人传递给 java 方法时，我们可以在控制台上看到想要的结果:

```javascript
var person1 = new Person("Peter", "Parker");
MyJavaClass.fun4(person1);

// Full Name is: Peter Parker
```

### 语言扩展

Nashorn 为 ECMAScript 标准定义了各种语言和 API 扩展，让我们来看看最新的特性:

#### 类型化数组（Typed Arrays）

原生的 javascript 数组是非类型化的，Nashorn 允许你在 javascript 中使用类型化的 java 数组:

```javascript
var IntArray = Java.type("int[]");

var array = new IntArray(5);
array[0] = 5;
array[1] = 4;
array[2] = 3;
array[3] = 2;
array[4] = 1;

try {
    array[5] = 23;
} catch (e) {
    print(e.message);  // Array index out of range: 5
}

array[0] = "17";
print(array[0]);  // 17

array[0] = "wrong type";
print(array[0]);  // 0

array[0] = "17.3";
print(array[0]);  // 17
```

`Int []` 数组的行为类似于真正的 java `int` 数组。但是另外，当我们试图向数组添加非整数值时，Nashorn 会在底层执行隐式类型转换。字符串将自动转换为 `int`，这非常方便。

#### Collections 和 foreach

与其在数组上浪费时间，我们可以使用任何 java 集合。首先通过 `Java.type` 定义 java 类型，然后根据需要创建新的实例。

```javascript
var ArrayList = Java.type('java.util.ArrayList');
var list = new ArrayList();
list.add('a');
list.add('b');
list.add('c');

for each (var el in list) print(el);  // a, b, c
```

为了遍历集合和数组 Nashorn 引入了 `for each` 语句。它的工作方式与 java 中的 foreach 循环类似。

下面是另一个使用 `HashMap` 的集合 foreach 示例:

```javascript
var map = new java.util.HashMap();
map.put('foo', 'val1');
map.put('bar', 'val2');

for each (var e in map.keySet()) print(e);  // foo, bar

for each (var e in map.values()) print(e);  // val1, val2
```

#### Lambda 表达式和 Streams

每个人都喜欢 lambdas 和 streams ——Nashorn 也是！虽然 ECMAScript 5.1缺少 Java 8 lambda 表达式中的箭头语法，但我们可以在接受 lambda 表达式的地方使用函数字面量。

```javascript
var list2 = new java.util.ArrayList();
list2.add("ddd2");
list2.add("aaa2");
list2.add("bbb1");
list2.add("aaa1");
list2.add("bbb3");
list2.add("ccc");
list2.add("bbb2");
list2.add("ddd1");

list2
    .stream()
    .filter(function(el) {
        return el.startsWith("aaa");
    })
    .sorted()
    .forEach(function(el) {
        print(el);
    });
    // aaa1, aaa2
```

#### 扩展类

可以使用 `Java.extend` 扩展简单地扩展 Java 类型。正如你在下一个例子中看到的，你甚至可以在你的脚本中创建多线程代码:

```javascript
var Runnable = Java.type('java.lang.Runnable');
var Printer = Java.extend(Runnable, {
    run: function() {
        print('printed from a separate thread');
    }
});

var Thread = Java.type('java.lang.Thread');
new Thread(new Printer()).start();

new Thread(function() {
    print('printed from another thread');
}).start();

// printed from a separate thread
// printed from another thread
```

#### 参数重载

方法和函数既可以用点符号调用，也可以用方括号符号调用。

```javascript
var System = Java.type('java.lang.System');
System.out.println(10);              // 10
System.out["println"](11.0);         // 11.0
System.out["println(double)"](12);   // 12.0
```

在调用具有重载参数的方法时，传递可选参数类型 `println (double)` 确定要调用的确切方法。

#### Java Beans

与显式地使用 `getter` 和 `setter` 不同，您可以只使用简单的属性名来从 javabean 获取或设置值。

```javascript
var Date = Java.type('java.util.Date');
var date = new Date();
date.year += 1900;
print(date.year);  // 2014
```

#### Function Literals

对于简单的一行函数，我们可以跳过大括号:

```javascript
function sqr(x) x * x;
print(sqr(3));    // 9
```

#### 属性绑定

两个不同对象的属性可以绑定在一起:

```javascript
var o1 = {};
var o2 = { foo: 'bar'};

Object.bindProperties(o1, o2);

print(o1.foo);    // bar
o1.foo = 'BAM';
print(o2.foo);    // BAM
```

#### Trimming strings

```javascript
print("   hehe".trimLeft());            // hehe
print("hehe    ".trimRight() + "he");   // hehehe
```

#### Whereis

万一你忘了自己在哪里:

```javascript
print(__FILE__, __LINE__, __DIR__);
```

#### Import Scopes

有时候一次导入许多 java 包是很有用的。我们可以将类 `JavaImporter` 与 `with` 语句一起使用。导入包中的所有类文件都可以在 `with` 语句的本地范围内访问:

```javascript
var imports = new JavaImporter(java.io, java.lang);
with (imports) {
    var file = new File(__FILE__);
    System.out.println(file.getAbsolutePath());
    // /path/to/my/script.js
}
```

#### Convert arrays

有些包，比如 `java.util`，可以直接访问而不需要使用 `Java.type` 或者 `JavaImporter`:

```javascript
var list = new java.util.ArrayList();
list.add("s1");
list.add("s2");
list.add("s3");
```

这段代码将 java 列表转换成一个本地 javascript 数组:

```javascript
var jsArray = Java.from(list);
print(jsArray);                                  // s1,s2,s3
print(Object.prototype.toString.call(jsArray));  // [object Array]
```

反之亦然:

```javascript
var javaArray = Java.to([3, 5, 7, 11], "int[]");
```

#### Calling Super

访问 javascript 中被重写的成员一般来说是很困难的，因为 java 的 `super` 关键字在 ECMAScript 中不存在。幸运的是 nashorn 可以解决。

首先，我们在 java 代码中定义一个超类型:

```java
class SuperRunner implements Runnable {
    @Override
    public void run() {
        System.out.println("super run");
    }
}
```

接下来我们从 javascript 中覆盖 `SuperRunner`。在创建一个新的 Runner 实例时，要注意扩展的 nashorn 语法: 重写成员的语法是从 java 匿名对象借来的。

```javascript
var SuperRunner = Java.type('com.winterbe.java8.SuperRunner');
var Runner = Java.extend(SuperRunner);

var runner = new Runner() {
    run: function() {
        Java.super(runner).run();
        print('on my run');
    }
}
runner.run();

// super run
// on my run
```

我们通过使用 `Java.super` 扩展调用重写的方法 `SuperRunner.run ()`。

#### 加载脚本

从 javascript 中执行附加的脚本文件非常简单。我们可以用 `load` 函数加载本地或远程脚本。

我经常使用 `Underscore.js` 作为我的 web 前端，所以让我们在 Nashorn 重用下划线:

```javascript
load('http://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.6.0/underscore-min.js');

var odds = _.filter([1, 2, 3, 4, 5, 6], function (num) {
    return num % 2 == 1;
});

print(odds);  // 1, 3, 5
```

外部脚本将在相同的 javascript 上下文中进行计算，因此我们可以直接访问下划线变量。请记住，当变量名相互重叠时，加载脚本可能会破坏您自己的代码。

这个问题可以通过将脚本文件加载到新的全局上下文来绕过:

```javascript
loadWithNewGlobal('script.js');
```

### 命令行脚本

如果您对使用 Java 编写命令行(shell)脚本感兴趣，可以尝试一下 Nake。是 Java 8 Nashorn 的简化版。在特定于项目的 Nakefile 中定义任务，然后通过在命令行中输入 `nake -- myTask` 来运行这些任务。任务是用 javascript 编写的，并以 Nashorns 脚本模式运行，因此您可以充分利用您的终端以及 JDK8 API 和任何 java 库的全部功能。

对于 Java 开发人员来说，编写命令行脚本比以往任何时候都要容易..。

### 总结

我希望这篇指南对你有所帮助，并且你喜欢我们的 Nashorn Javascript 引擎之旅。想了解更多关于 Nashorn 的信息，请阅读[这里](http://docs.oracle.com/javase/8/docs/technotes/guides/scripting/nashorn/)，[这里](http://www.oracle.com/technetwork/articles/java/jf14-nashorn-2126515.html)和[这里](https://wiki.openjdk.java.net/display/Nashorn/Nashorn+extensions)。使用 Nashorn 编写 shell 脚本的指南可以在[这里](http://docs.oracle.com/javase/8/docs/technotes/guides/scripting/nashorn/shell.html#sthref24)找到。

我最近[发表了一篇](https://winterbe.com/posts/2014/04/07/using-backbonejs-with-nashorn/)关于如何使用 Nashorn Javascript 引擎来使用 `Backbone.js` 模型的后续文章。如果你想了解更多关于 java 8的知识，请随时阅读我的 [Java 8教程](https://winterbe.com/posts/2014/03/16/java-8-tutorial/)和我的 [Java 8 Stream教程](https://winterbe.com/posts/2014/07/31/java8-stream-tutorial-examples/)。

本教程中的可运行源代码[托管在 GitHub 上](https://github.com/winterbe/java8-tutorial)。你可以通过 Twitter 发送你的反馈意见。

相关链接：

- [Stream.js](https://github.com/winterbe/streamjs) ：用 Javascript 浏览器的 Java8 streams API 实现。 

> 原文地址：https://winterbe.com/posts/2014/04/05/java8-nashorn-tutorial/

