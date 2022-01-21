---
title: 代码设计原则
identifier: code-design-principle
author: Scott
date: 2022-01-21T12:04:31.174Z
tags:
  - 架构设计
categories:
  - 技术
---
在编程中有6个常见的代码设计原则：单一职责、开闭、里氏替换、迪米特、接口隔离、依赖倒置。

<!--more-->

## 简述

设计模式的六大原则有：

* Single Responsibility Principle：单一职责原则
* Open Closed Principle：开闭原则
* Liskov Substitution Principle：里氏替换原则
* Law of Demeter：迪米特法则
* Interface Segregation Principle：接口隔离原则
* Dependence Inversion Principle：依赖倒置原则

把这六个原则的首字母联合起来（两个 L 算做一个）就是 SOLID （solid，稳定的），其代表的含义就是这六个原则结合使用的好处：建立稳定、灵活、健壮的设计。

### 一、单一职责原则（Simple Responsibility Principle，SRP）

**原文：**

> There should never be more than one reason for a class to change.

**解释：** 

一个类应该只有一个发生变化的原因。

**优点：**

* 降低类的复杂度。提高类的可读性；
* 提高系统的可维护性。降低变更引起的风险。

### 二、开闭原则（Open-Close Principle，OCP）

**原文：**

> Software entities like classes, modules and functions should be open for extension but closed for modification

**解释：**

一个软件实体，如类、模块和函数应该对扩展开放，对修改关闭。

**优点：**

* 提高软件系统的可复用性及可维护性。

### 三、里氏替换原则（Liskov Substitution Principle，LSP）

**原文：**

> Functions that use use pointers or references to base classes must be able to use objects of derived classes without knowing it.

**解释：**

所有引用基类的地方必须能透明地使用其子类的对象

**扩展：**

一个软件实体如果适用一个父类的话，那一定适用于其子类，所有引用父类的地方必须能透明地使用其子类的对象，子类对象能够替换父类对象，而程序逻辑不变。

**引申：**

子类可以扩展父类的功能，但不能改变父类原有的功能。

* 含义1：子类可以实现父类的抽象方法，但不能覆盖父类的非抽象方法。
* 含义2：子类中可以增加自己特有的方法。
* 含义3：当子类的方法重载父类的方法时，方法的前置条件（即方法的输入、入参）要比父类方法的输入参数更宽松。
* 含义4：当子类的方法实现父类的方法时（重写、重载或实现抽象方法），方法的后置条件（即方法的输出、返回值）要比父类更严格或相等。

优点：

* 约束继承泛滥，开闭原则的一种体现；
* 加强程序的健壮性，同时变更时也可以做到非常好的兼容性；
* 提高程序的维护性、扩展性，降低需求变更时引入的风险。

## 四、迪米特法则（Law of Demeter，LoD）

又叫最少知道原则，其目的是降低类之间的耦合度，提高模块的相对独立性。

**原文：**

> Talk only to your immediate friends and not to strangers

**解释：**

只与你的直接朋友交谈，不跟“陌生人”说话。

**含义：**

如果两个软件实体无须直接通信，那么就不应当发生直接的相互调用，可以通过第三方转发该调用。

**优点**：

* 降低类之间的耦合。

## 五、接口隔离原则（Interface Segregation Principle，ISP）

1、客户端不应该依赖它不需要的接口。
2、类间的依赖关系应该建立在最小的接口上。

**原文：**

> Clients should not be forced to depend upon interfaces that they don`t use.
> The dependency of one class to another one should depend on the smallest possible.

**注意：**

该原则中的接口，是一个泛泛而言的接口，不仅仅指Java中的接口，还包括其中的抽象类。

## 六、依赖倒置原则（Dependence Inversion Principle，DIP）

1、上层模块不应该依赖底层模块，它们都应该依赖于抽象。
2、抽象不应该依赖于细节，细节应该依赖于抽象。

**原文：**

> High level modules should not depend upon low level modules. Both should depend upon abstractions.
> Abstractions should not depend upon details. Details should depend upon abstractions.

**优点：**

可以减少类间的耦合性、提高系统稳定性，提高代码可读性和可维护性，可降低修改程序所造成的风险。