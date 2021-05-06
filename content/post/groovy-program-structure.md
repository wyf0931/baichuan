---
title: Groovy 程序结构
author: Scott
tags:
  - Groovy
categories:
  - Groovy
  - 技术
date: 2019-06-27 19:15:00
---
本章主要讲 Groovy 编程语言的程序结构。

### 包（package）
包名称与 Java 中的角色完全相同。它们允许我们在没有任何冲突的情况下分离代码库。Groovy 类必须在类定义之前指定它们的包，否则假定使用默认包。
包的定义与 Java 非常相似：
```groovy
// defining a package named com.yoursite
package com.yoursite
```
要在 `com.yoursite.com` 包中引用某个类 `Foo`，您需要使用全路径`com.yoursite.com.Foo`，或者您可以使用 `import` 语句，如下所示。

### 导入（import）
为了引用某个类，你得先引入它所在的包。Groovy 效仿 Java 的方式用 `import` 语句来解析类引用的概念。
例如，Groovy 提供了几个构造类，例如`MarkupBuilder`。 `MarkupBuilder`在`groovy.xml` 包中，所以为了使用这个类，你需要导入它，如下所示：
```groovy
// importing the class MarkupBuilder
import groovy.xml.MarkupBuilder

// using the imported class to create an object
def xml = new MarkupBuilder()

assert xml != null
```
### 默认导入
默认导入是 Groovy 语言默认提供的导入。例如，请查看以下代码：
```groovy
new Date()
```
Java 中的相同代码需要一个 `Date` 类的 import 语句，如下所示：`import java.util.Date`。默认情况下，Groovy 会为您导入这些类：
```groovy
import java.lang.*
import java.util.*
import java.io.*
import java.net.*
import groovy.lang.*
import groovy.util.*
import java.math.BigInteger
import java.math.BigDecimal
```
这样做是因为经常使用这些包中的类。通过导入这些样板代码来简化代码。

### 简单导入
一个简单的导入是一个 import 语句，您可以在其中完全定义类名和包。例如，下面代码中的 import 语句 `import groovy.xml.MarkupBuilder` 是一个简单的导入，它直接引用包内的类。
```groovy
// importing the class MarkupBuilder
import groovy.xml.MarkupBuilder

// using the imported class to create an object
def xml = new MarkupBuilder()

assert xml != null
```

### 全部导入（`*`）
与Java一样，Groovy提供了一种使用 `*`（即所谓的星型导入）从包导入所有类的特殊方法。 `MarkupBuilder` 是一个在`groovy.xml`包中的类，以及另一个名为`StreamingMarkupBuilder`的类。 如果您需要使用这两个类，您可以：
```groovy
import groovy.xml.MarkupBuilder
import groovy.xml.StreamingMarkupBuilder

def markupBuilder = new MarkupBuilder()

assert markupBuilder != null

assert new StreamingMarkupBuilder() != null
```

这是完全有效的代码。但是使用 `*` 导入，我们只用一行即可达到同样的效果。星号导入包 `groovy.xml` 下的所有类：
```groovy
import groovy.xml.*

def markupBuilder = new MarkupBuilder()

assert markupBuilder != null

assert new StreamingMarkupBuilder() != null
```

`*` 导入的一个问题是它们可能会混乱您的本地命名空间。但是由于 Groovy 提供了各种别名，这很容易解决。

### 静态导入（static）
Groovy 的静态导入功能允许您引用导入的类，就像它们是您自己的类中的静态方法一样：
```groovy
import static Boolean.FALSE

assert !FALSE // 直接使用，无需 Boolean 前缀！
```
这类似于 Java 的静态导入功能，但它比 Java 更具动态性，因为它允许您定义与导入方法同名的方法，只要您有不同的类型：
```groovy
// 静态导入方法
import static java.lang.String.format 

class SomeClass {

    // 与上面静态导入的方法同名的方法声明，但具有不同的参数类型
    String format(Integer i) { 
        i.toString()
    }

    static void main(String[] args) {
        // 在 java 中编译错误，但是groovy有效的代码
        assert format('String') == 'String' 
        assert new SomeClass().format(Integer.valueOf(1)) == '1'
    }
}
```
如果您具有相同的类型，则导入的类优先。

### Static import aliasing
待翻译

### Static star import
待翻译

### 导入别名
可以使用 `as` 关键字指定类型别名，我们可以使用我们选择的名称来引用全路径的类名。
例如我们可以导入 `java.sql.Date` 作为 `SQLDate` 并
例如，我们可以将`java.sql.Date`作为`SQLDate`导入，并在与`java.util.Date`相同的文件中使用它，而不必使用全路径名称：
```groovy
import java.util.Date
import java.sql.Date as SQLDate

Date utilDate = new Date(1000L)
SQLDate sqlDate = new SQLDate(1000L)

assert utilDate instanceof java.util.Date
assert sqlDate instanceof java.sql.Date
```


### 脚本与类

**public static void main 与脚本对比**

Groovy 支持脚本和类。如下所示：  
```groovy
// 定义一个Main类，名字可以随意
class Main {
    // public static void main(String[]) 作为类的 main 方法
    static void main(String... args) {
        println 'Groovy world!'
    }
}
```

这是您可以从Java中找到的典型代码，其中代码必须嵌入到可执行的类中。 Groovy使它更容易，以下代码是等效的：
```groovy
println 'Groovy world!'
```

脚本可以被视为一个类而不需要声明它，但有一些差异。

### 脚本类
[脚本](http://docs.groovy-lang.org/2.5.4/html/gapi/index.html?groovy/lang/Script.html)会被编译为类。Groovy 编译器会把脚本体中的代码复制到 `run` 方法中。因此，前面的示例被编译为如下所示：  
```groovy
import org.codehaus.groovy.runtime.InvokerHelper
// Main 类继承 groovy.lang.Script 类
class Main extends Script { 
    // groovy.lang.Script 需要一个 run 方法来返回值
    def run() {
        // 脚本体会放在 run 方法内
        println 'Groovy world!'                 
    }
    // main 方法会自动生成
    static void main(String[] args) {
        // 并在run方法上委托执行脚本
        InvokerHelper.runScript(Main, args)     
    }
}
```
如果脚本位于文件中，则使用该文件的基本名称来确定生成的脚本类的名称。在此示例中，如果文件的名称为 `Main.groovy`，则脚本类将为 `Main`。

### 方法
如下所示，在脚本中定义一个方法：
```groovy
int fib(int n) {
    n < 2 ? 1 : fib(n-1) + fib(n-2)
}
assert fib(10)==89
```

您还可以混合方法和代码。生成的脚本类将所有方法都包含在脚本类中，并将所有脚本体组装到`run`方法中：
```groovy
// 开始写脚本
println 'Hello'                                 

// 在脚本中定义方法
int power(int n) { 2**n }                       
// 继续写脚本
println "2^6==${power(6)}"   
```

上述代码在内部会被转换为：
```groovy
import org.codehaus.groovy.runtime.InvokerHelper
class Main extends Script {
    // 将power方法原样复制到生成的脚本类中
    int power(int n) { 2** n}                   
    def run() {
        // 第一、第二句被复制到了 run 方法中
        println 'Hello'                         
        println "2^6==${power(6)}"              
    }
    static void main(String[] args) {
        InvokerHelper.runScript(Main, args)
    }
}
```

即使 Groovy 从您的脚本创建了一个类，它对用户来说也是完全透明的。尤其是，脚本被编译为字节码，并保留行号。这意味着如果在脚本中抛出异常，堆栈跟踪将显示与原始脚本对应的行号，而不是显示我们生成的代号。

### 变量
脚本中的变量不需要类型定义。这意味着这个脚本：
```groovy
int x = 1
int y = 2
assert x+y == 3
```

与以下代码等效：
```groovy
x = 1
y = 2
assert x+y == 3
```

但是两者之间存在语义差异：
* 如果变量在第一个示例中声明，则它是局部变量。 它将在`run`方法中声明，编译器将生成并且在脚本主体外部不可见。 特别是，这样的变量在脚本的其他方法中是不可见的。
* 如果变量未声明，则进入[脚本绑定](http://docs.groovy-lang.org/2.5.4/html/gapi/index.html?groovy/lang/Script.html#getBinding())。 从方法中可以看到绑定，如果您使用脚本与应用程序交互并需要在脚本和应用程序之间共享数据，那么绑定尤为重要。 读者可参阅[集成指南](http://docs.groovy-lang.org/latest/html/documentation/guide-integrating.html#_integrating_groovy_in_a_java_application)获取更多信息。

如果您希望变量成为类的字段而不进入`Binding`，则可以使用[`@Field`注解](http://docs.groovy-lang.org/latest/html/documentation/core-metaprogramming.html#xform-Field)。

> 原文地址：http://groovy-lang.org/structure.html