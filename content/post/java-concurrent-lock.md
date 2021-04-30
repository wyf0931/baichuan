---
title: Java 高级并发对象之 Lock 对象
author: Scott
tags:
  - 高并发
  - Java
categories:
  - 技术
date: 2019-07-01 15:25:00
---
本文主要介绍 Java 并发控制中常用的 `Lock` 对象。
<!--more-->

同步代码依赖于一种简单的可重入锁。这种锁很容易使用，但有很多限制。 `java.util.concurrent.locks` 包支持更复杂的锁定方式。我们不会详细的研究这个包，而是将重点放在它最基本的接口`Lock`上。

锁对象非常像 `synchronized` 代码使用的隐式锁。与隐式锁一样，一次只有一个线程拥有一个 `Lock` 对象。`Lock` 对象还通过其关联的 `Condition` 对象支持 `wait /notify` 机制。

`Lock` 对象比隐式锁好的一点是它能退出尝试获取锁。如果锁定不是立即可用或在超时  到期之前（如果指定的话），`tryLock` 方法将会退出。如果另一个线程在获取锁之前发出中断，`lockInterruptibly` 方法将会退出。

让我们使用 Lock 对象来解决我们在 [Liveness](https://docs.oracle.com/javase/tutorial/essential/concurrency/liveness.html) 中看到的死锁问题。Alphonse 和 Gaston 已经训练自己注意什么时候朋友要鞠躬。我们通过要求我们的 `Friend` 对象在继续前进之前必须获取两个参与者的锁来模拟这种改进。这里是改进的模型 `Safelock` 的源代码。为了证明这个习惯用法的多样性，我们假定 Alphonse 和Gaston 是如此迷恋他们的新的安全鞠躬能力，他们不能停的彼此鞠躬：

```java
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import java.util.Random;

public class Safelock {
    static class Friend {
        private final String name;
        private final Lock lock = new ReentrantLock();

        public Friend(String name) {
            this.name = name;
        }

        public String getName() {
            return this.name;
        }

        public boolean impendingBow(Friend bower) {
            Boolean myLock = false;
            Boolean yourLock = false;
            try {
                myLock = lock.tryLock();
                yourLock = bower.lock.tryLock();
            } finally {
                if (! (myLock && yourLock)) {
                    if (myLock) {
                        lock.unlock();
                    }
                    if (yourLock) {
                        bower.lock.unlock();
                    }
                }
            }
            return myLock && yourLock;
        }
            
        public void bow(Friend bower) {
            if (impendingBow(bower)) {
                try {
                    System.out.format("%s: %s has"
                        + " bowed to me!%n", 
                        this.name, bower.getName());
                    bower.bowBack(this);
                } finally {
                    lock.unlock();
                    bower.lock.unlock();
                }
            } else {
                System.out.format("%s: %s started"
                    + " to bow to me, but saw that"
                    + " I was already bowing to"
                    + " him.%n",
                    this.name, bower.getName());
            }
        }

        public void bowBack(Friend bower) {
            System.out.format("%s: %s has" +
                " bowed back to me!%n",
                this.name, bower.getName());
        }
    }

    static class BowLoop implements Runnable {
        private Friend bower;
        private Friend bowee;

        public BowLoop(Friend bower, Friend bowee) {
            this.bower = bower;
            this.bowee = bowee;
        }
    
        public void run() {
            Random random = new Random();
            for (;;) {
                try {
                    Thread.sleep(random.nextInt(10));
                } catch (InterruptedException e) {}
                bowee.bow(bower);
            }
        }
    }
            

    public static void main(String[] args) {
        final Friend alphonse =
            new Friend("Alphonse");
        final Friend gaston =
            new Friend("Gaston");
        new Thread(new BowLoop(alphonse, gaston)).start();
        new Thread(new BowLoop(gaston, alphonse)).start();
    }
}
```