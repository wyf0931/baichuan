---
title: Java Enum 类型介绍
author: Scott
tags:
  - Java
categories:
  - 技术
date: 2019-07-03 10:24:00
---
本文主要介绍 Java 中枚举类型的定义及使用方法。
<!--more-->

枚举（`Enum`）类型是一种特殊的数据类型，这类型的值是一组预定义的常量。该变量值必须在预定义的值中。常见的案例包括方向枚举（NORTH，SOUTH，EAST、WEST值）和星期几。

因为它们是常量，所以**枚举类型的字段的名称一般都大写**。

**在 Java 编程语言中，可以使用 `enum` 关键字定义枚举类型。**例如，你可以将星期几指定为下面这种枚举类型：
```java
public enum Day {
    SUNDAY, MONDAY, TUESDAY, WEDNESDAY,
    THURSDAY, FRIDAY, SATURDAY 
}
```

**最好使用枚举类型来表示一组固定的常量**。包括自然枚举类型，例如太阳系中的行星和数据集，在编译时已知道所有可能的值，例如菜单上的选项，命令行标志等等。

下面的代码展示了上述中的 `Day` 枚举：
```java
public class EnumTest {
    Day day;
    
    public EnumTest(Day day) {
        this.day = day;
    }
    
    public void tellItLikeItIs() {
        switch (day) {
            case MONDAY:
                System.out.println("Mondays are bad.");
                break;
                    
            case FRIDAY:
                System.out.println("Fridays are better.");
                break;
                         
            case SATURDAY: case SUNDAY:
                System.out.println("Weekends are best.");
                break;
                        
            default:
                System.out.println("Midweek days are so-so.");
                break;
        }
    }
    
    public static void main(String[] args) {
        EnumTest firstDay = new EnumTest(Day.MONDAY);
        firstDay.tellItLikeItIs();
        EnumTest thirdDay = new EnumTest(Day.WEDNESDAY);
        thirdDay.tellItLikeItIs();
        EnumTest fifthDay = new EnumTest(Day.FRIDAY);
        fifthDay.tellItLikeItIs();
        EnumTest sixthDay = new EnumTest(Day.SATURDAY);
        sixthDay.tellItLikeItIs();
        EnumTest seventhDay = new EnumTest(Day.SUNDAY);
        seventhDay.tellItLikeItIs();
    }
}
```
输出为：
```bash
Mondays are bad.
Midweek days are so-so.
Fridays are better.
Weekends are best.
Weekends are best.
```

Java 的枚举类型比其他编程语言的类型更强大。枚举声明定义了一个类（称为枚举类型）。枚举类体可以包括方法和其他字段。编译器在创建枚举时自动添加一些特殊方法。例如，它们有一个静态 **`values`** 方法，可以按照声明的顺序返回一个包含枚举所有值的数组，此方法通常与 `for-each` 结构配合使用来遍历枚举类型的值。例如，下面的 `Planet` 类中代码遍历太阳系中的所有行星。

```java
for (Planet p : Planet.values()) {
    System.out.printf("Your weight on %s is %f%n", p, p.surfaceWeight(mass));
}
```

> 由于 Java 语言不支持多继承（请参阅 [Multiple Inheritance of State, Implementation, and Type](http://docs.oracle.com/javase/tutorial/java/IandI/multipleinheritance.html)），只能继承一个父类（请参阅 [Declaring Classes](http://docs.oracle.com/javase/tutorial/java/javaOO/classdecl.html)），而所有枚举隐式地继承了 `java.lang.Enum`，因此**枚举不能继承任何类**。

在下面的例子中，`Planet` 是一个枚举类型，表示太阳系中的行星。它们被定义为具有恒定的质量和半径属性。

每个枚举常量都用质量和半径参数的值声明。这些值在创建常量时传递给构造函数。 **Java 要求在任何字段或方法之前首先定义常量。此外，当有字段和方法时，枚举常量的列表必须以分号结尾。**

> 枚举类型的构造函数必须是 `package-private` 或 `private` 类型。它自动创建在枚举体开始的地方定义常量。你不能自己调用枚举构造函数。

除了它的属性和构造函数，`Planet` 具有允许你检索每个行星上的对象的表面重力和重量的方法。这里是一个示例程序来获取你在地球的重量（任意单位），并计算和打印你在所有的行星的重量（单位相同）：

```java
public enum Planet {
    MERCURY (3.303e+23, 2.4397e6),
    VENUS   (4.869e+24, 6.0518e6),
    EARTH   (5.976e+24, 6.37814e6),
    MARS    (6.421e+23, 3.3972e6),
    JUPITER (1.9e+27,   7.1492e7),
    SATURN  (5.688e+26, 6.0268e7),
    URANUS  (8.686e+25, 2.5559e7),
    NEPTUNE (1.024e+26, 2.4746e7);

    private final double mass;   // in kilograms
    private final double radius; // in meters
    Planet(double mass, double radius) {
        this.mass = mass;
        this.radius = radius;
    }
    private double mass() { return mass; }
    private double radius() { return radius; }

    // universal gravitational constant  (m3 kg-1 s-2)
    public static final double G = 6.67300E-11;

    double surfaceGravity() {
        return G * mass / (radius * radius);
    }
    double surfaceWeight(double otherMass) {
        return otherMass * surfaceGravity();
    }
    public static void main(String[] args) {
        if (args.length != 1) {
            System.err.println("Usage: java Planet <earth_weight>");
            System.exit(-1);
        }
        double earthWeight = Double.parseDouble(args[0]);
        double mass = earthWeight/EARTH.surfaceGravity();
        for (Planet p : Planet.values())
           System.out.printf("Your weight on %s is %f%n",
                             p, p.surfaceWeight(mass));
    }
}
```
如果从命令行运行 `Planet.class`，参数为 `175`，你将看到以下输出：
```bash
$ java Planet 175
Your weight on MERCURY is 66.107583
Your weight on VENUS is 158.374842
Your weight on EARTH is 175.000000
Your weight on MARS is 66.279007
Your weight on JUPITER is 442.847567
Your weight on SATURN is 186.552719
Your weight on URANUS is 158.397260
Your weight on NEPTUNE is 199.207413
```

> 原文地址：http://docs.oracle.com/javase/tutorial/java/javaOO/enum.html