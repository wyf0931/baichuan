---
title: Java 基础知识总结
author: Scott
tags:
  - Java
categories:
  - 技术
date: 2019-09-04 15:41:00
---
## 一、线程

### 1、新建线程

- 继承 `Thread` 类，重写  `run ` 方法；
- 实现 `Runnable` 接口；
- 实现 `Callable` 接口；

> **注意：**
>
> 由于 Java 不能多继承，所以推荐使用接口方式创建线程。

### 2、线程状态与转化

![线程状态转化图](/images/pasted-29.png)

- Java 中的 `RUNNABLE` 状态对应操作系统中的 `READY` 、`RUNNING` ；
- Java 中的 `synchronized` 方法或块代码会触发 `BLOCKED` 状态；
- 使用 `java.util.concurrent.locks` 加锁，会触发 `WAITING` 、`TIMED_WAITING` 状态；

### 3、线程间交互

#### 3.1 interrupted

`interrupted` 可以理解为线程的一个标志位，表示运行中的线程是否被其他线程进行了中断操作。

如果线程中调用了 `Object.wait()`、 `Object.wait(timeout)`、 `Thread.sleep(timeout)`、 `Thread.join()` 、`Thread.join(timeout)` 时会抛出 `InterruptedException` 异常，中断异常会清除中断标记位，因此，在调用 `isInterrupted` 方法时会返回 `false`。

- `public boolean isInterrupted()` ：可以测试该线程是否被中断，不会清除中断标记位；
- `public static boolean interrupted()` ：可以测试当前线程是否被中断，会清除中断标记位；

#### 3.2 join

一个线程的输入依赖于另一个线程的输出。

`join()` vs `join(long timeout)`：

- 如果一个线程实例 `A` 执行了 `threadB.join()` ，表示当前线程 `A` 会等待 `threadB` 线程终止后 `threadA` 才会继续执行。
- 如果一个线程实例 `A` 执行了 `threadB.join(long timeout)` 表示在超过等待时间后， `A` 会继续执行。

#### 3.3 sleep & wait

`wait()`  VS `sleep() `:

- `wait()` 是 `Object` 实例方法，`sleep()` 方法是 `Thread` 的静态方法；
- `wait()` 方法需要在  `synchronized` 方法或者代码块中调用，`sleep()` 可以在任何地方调用；
- `wait()` 方法会释放占有的对象锁，使该线程进入等待池中，等待下一次获取资源，`sleep()` 方法只会让出CPU并不会释放掉对象锁；
- `wait()` 方法必须等待 `Object.notift/Object.notifyAll` 通知后，才会离开等待池，并且再次获得CPU时间片才会继续执行，`sleep()` 方法在休眠时间达到后如果再次获得CPU时间片就会继续执行；

> **注意：**
>
> - `sleep` 只会让出当前的CPU时间片，不会释放已获得的锁。

#### 3.4 yield

`public static native void yield();` 是一个静态方法，一旦执行，它会是当前线程让出CPU。

> **注意：**
>
> - 让出CPU时间片并不是代表当前线程不再运行了，如果在下一次竞争中，又获得了CPU时间片当前线程依然会继续运行。
> - 让出的时间片只会分配给当前线程相同优先级的线程。
> - Java 中用一个整型成员变量 `Priority` 来控制优先级，优先级的范围从 `1~10`。在构建线程的时候可以通过 `setPriority(int)` 方法进行设置，**默认优先级为 `5`**，优先级高的线程相较于优先级低的线程优先获得CPU时间片。
> - 在不同 JVM 和操作系统上，线程规划存在差异，有些操作系统甚至会忽略线程优先级的设定；

`sleep()` vs  `yield()`：

- `sleep()` 方法让出来的CPU 时间片其他所有线程都可以通过竞争获得，`yield()` 方法只允许与当前线程具有相同优先级的线程能够获得释放出来的CPU时间片。

### 4、守护线程

通过在 `start()` 之前调用`setDaemon(true)` 来设定守护线程。

> **注意：**
>
> 守护线程在退出的时候并不会执行 `finnaly` 中的代码，所以将释放资源等操作不要放在 `finnaly` 中执行，这种操作是不安全的。



## 二、锁

### 1、`synchronized` 使用场景


![synchronized 使用场景](/images/pasted-30.png)

### 2、`synchronized` 实现原理

以 `SynchronizedDemo` 为例：

```java
public class SynchronizedDemo {
    public static void main(String[] args) {
        synchronized (SynchronizedDemo.class) {
        }
        method();
    }

    private static void method() {
    }
}
```

用 `javap -v SynchronizedDemo.class` 查看字节码文件：

```bash
Classfile /C:/Users/thinkpad/Documents/SynchronizedDemo.class
  Last modified 2019-8-25; size 477 bytes
  MD5 checksum c65c82d1774d83b0fd1b6b5e4e7bb6b0
  Compiled from "SynchronizedDemo.java"
public class SynchronizedDemo
  minor version: 0
  major version: 52
  flags: ACC_PUBLIC, ACC_SUPER
Constant pool:
{
  public SynchronizedDemo();
    descriptor: ()V
    flags: ACC_PUBLIC
    Code:
      stack=1, locals=1, args_size=1
         0: aload_0
         1: invokespecial #1                  // Method java/lang/Object."<init>":()V
         4: return
      LineNumberTable:
        line 1: 0

  public static void main(java.lang.String[]);
    descriptor: ([Ljava/lang/String;)V
    flags: ACC_PUBLIC, ACC_STATIC
    Code:
      stack=2, locals=3, args_size=1
         0: ldc           #2                  // class SynchronizedDemo
         2: dup
         3: astore_1
         4: monitorenter
         5: aload_1
         6: monitorexit
         7: goto          15
        10: astore_2
        11: aload_1
        12: monitorexit
        13: aload_2
        14: athrow
        15: invokestatic  #3                  // Method method:()V
        18: return
      Exception table:
         from    to  target type
             5     7    10   any
            10    13    10   any
      LineNumberTable:
        line 3: 0
        line 4: 5
        line 5: 15
        line 6: 18
      StackMapTable: number_of_entries = 2
        frame_type = 255 /* full_frame */
          offset_delta = 10
          locals = [ class "[Ljava/lang/String;", class java/lang/Object ]
          stack = [ class java/lang/Throwable ]
        frame_type = 250 /* chop */
          offset_delta = 4
}
SourceFile: "SynchronizedDemo.java"
```

使用 `synchronized` 进行同步，其关键就是获取对象的监视器（ `monitor` ），当线程获取 `monitor`  后才能继续往下执行，否则就只能等待。

![对象，对象监视器，同步队列以及执行线程状态之间的关系](/images/pasted-28.png)

**每个对象都有一个计数器，当线程获取该对象锁后，计数器就会加一，释放锁后就会将计数器减一。**

### 3、`synchronized` 优化

#### 3.1、CAS（compare and swap）操作

##### 3.1.1 什么是CAS？

CAS操作（又称为无锁操作）是一种**乐观锁策略**。

- 悲观锁策略：假设每一次执行临界区代码都会产生冲突，所以当前线程获取到锁的时候同时也会阻塞其他线程获取该锁。
- 乐观锁策略：假设所有线程访问共享资源的时候不会出现冲突，既然不会出现冲突自然而然就不会阻塞其他线程的操作。

##### 3.1.2 CAS操作过程

CAS比较交换的过程可以通俗的理解为CAS(V,O,N)，包含三个值分别为：V 内存地址存放的实际值；O 预期的值（旧值）；N 更新的新值。

##### 3.1.3 CAS的问题

- ABA问题
- 自旋时间过长
- 只能保证一个共享变量的原子操作

#### 3.2 Java对象头

在同步的时候是获取对象的`monitor`，即获取到对象的锁。

![32位JVM Mark Word默认存储结构](/images/pasted-25.png)

Java SE 1.6中，锁一共有4种状态，级别从低到高依次是：**无锁状态、偏向锁状态、轻量级锁状态、重量级锁状态**，这几个状态会随着竞争情况逐渐升级，但不能降级（目的是为了提高获得锁和释放锁的效率）。

![对象的MarkWord变化](/images/pasted-26.png)

锁的比较：
![锁的比较](/images/pasted-27.png)

### 4、ReentrantLock

类`ReentrantLock`具有完全互斥排他的效果，即同一时间只有一个线程在执行`ReentrantLock.lock()`方法后面的任务。这样做虽然保证了实例变量的线程安全性，但效率却是非常低下的。所以在JDK中提供了一种读写锁`ReentrantReadWriteLock`类，来提升该方法的代码运行速度。

读写锁表示也有两个锁，一个是读操作相关的锁，也称为共享锁；另一个是写操作相关的锁，也叫排他锁。

> 多个读锁之间不互斥，读锁与写锁互斥，写锁与写锁互斥。

`ReentrantReadWriteLock ` 使用示例如下：

```kotlin
class Service {
   private var lock: ReentrantReadWriteLock = ReentrantReadWriteLock()
   fun read() {
       try {
           try {
               lock.readLock().lock()
               println("获得此锁：${Thread.currentThread().name} ${System.currentTimeMillis()}")
               Thread.sleep(10000)
           } finally {
               lock.readLock().unlock()
           }
       } catch(e: InterruptedException) {
           e.printStackTrace()
       }
   }
}
```

上面代码显使用了读锁，相应的，写锁应该是：

```kotlin
lock.writeLock().lock()

lock.writeLock().unlock()
```

## 三、Java内存模型

出现线程安全的问题一般是因为**主内存和工作内存数据不一致性**和**重排序**导致的。

Java内存模型是**共享内存的并发模型**，线程之间主要通过读-写共享变量来完成隐式通信。

共享变量：所有**实例域，静态域和数组元素**都是放在堆内存中，而局部变量，方法定义参数和异常处理器参数不会在线程间共享。

JMM抽象结构模型：

![JMM抽象示意图](/images/pasted-23.png)

#### 重排序

##### 什么是重排序？

在执行程序时，**为了提高性能，编译器和处理器常常会对指令进行重排序**。

![重排序可以分为如下三种](/images/pasted-24.png)

如图，1属于编译器重排序，而2和3统称为处理器重排序。这些重排序会导致线程安全的问题，一个很经典的例子就是DCL问题。

- **编译器重排序**，JMM的编译器重排序规则会禁止一些**特定类型的编译器重排序**；
- **处理器重排序**，编译器在生成指令序列的时候会通过**插入内存屏障指令来禁止某些特殊的处理器重排序**。

##### 什么是数据依赖性？

如果两个操作访问同一个变量，且这两个操作有一个为写操作，此时这两个操作就存在数据依赖性

数据依赖性的三种情况：

1. 读后写；
2. 写后写；
3. 写后读；

> 编译器和处理器在重排序时，会遵守数据依赖性，编译器和处理器不会改变存在数据依赖性关系的两个操作的执行顺序。

##### as-if-serial语义

*as-if-serial* 语义的意思是：不管怎么重排序（编译器和处理器为了提供并行度），（单线程）程序的执行结果不能被改变。编译器，Runtime 和处理器都必须遵守 *as-if-serial* 语义。

遵守 *as-if-serial* 语义的编译器，Runtime和处理器共同为编写单线程程序的程序员创建了一个幻觉：单线程程序是按程序的顺序来执行的。

#### happens-before规则

*JSR-133* 使用 *happens-before* 的概念来指定两个操作之间的执行顺序。JMM 可以通过 *happens-before* 关系向程序员提供跨线程的内存可见性保证。

如果 A 线程的写操作 a 与 B 线程的读操作 b 之间存在 *happens-before* 关系，尽管 a 操作和 b 操作在不同的线程中执行，但 JMM 向程序员保证 a 操作将对 b 操作可见。

`volatile` 可以避免指令重排。