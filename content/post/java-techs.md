---
title: Java 常用技术总结
author: Scott
tags:
  - Java
categories: []
date: 2019-06-29 00:00:00
---

* Java 构建线程：Runable、Callable 、Thread
* Java 并发安全：synchronized、Lock（ReentrantLock、ReadWriteLock）
* Java 关键词：volatile、synchronized
* Java 常用集合（ConcurrentHashMap、HashMap、HashSet、HashTable、TreeMap、List、LinkedBlockingQueue）
* Java concurrent 包实现原理：CAS、AQS
* Java 线程协同：管道通信、Fork/Join、CountDownLatch、CyclicBarrier
* Java IO相关：BIO、NIO、AIO
* Java 位图（Bitmap）：BitSet
* Java 线程池：ThreadExecutorPool
* JVM 垃圾回收算法：标记、复制、清理
* JVM 垃圾回收器：CMS、G1（分区块）
* JVM 内存模型：堆、栈、程序计数器、本地方法栈、方法栈
---

* Linux：Epoll 方法实现
* TCP/IP：三次握手、滑动窗口、时间窗口、FD 默认值1024（File Description）
* 常用协议：http、https、http2、websockect
* HttpDns实现：ip转int（255进制）、 二分查找
* 池：线程池（ThreadPool）、连接池（ConnectionPool）
---

* 倒排索引：Lucene
* LBS算法：Google S2算法、GeoHash
* 树型数据结构：前缀（字典）树、B 树、B+树、红黑树
* 加密算法：对称加密（DES、3DES、RC2、RC4、AES、BlowFish）、非对称加密（RSA、ECC）
* 摘要算法：SHA1、SHA128、MD5、CRC
* 一致性 Hash：MurmurHash
* 位图（Bitmap）：大数据量的统计、去重、排序
* 分布式BASE模型：基本可用、软状态（异步）、最终一致
* 分布式CAP理论：一致性、可用性、可靠性（分区容错），三选二
---

* 常用缓存中间件：redis、MongoDB、memcached（支持的数据结构有差异）
* 常用NIO框架：Netty、Mina
* 图像处理中间件：GraphicsMagic、ImageMagic、OpenCV
* 常用消息队列：RocketMQ、Kafka、ActiveMQ、rabbitMQ
* 常用文本搜索引擎：Lucene、Elasticsearch、Solr
* 常用中文分词器：IK Analyzer、ansj、jcseg、[Stanford分词器](https://nlp.stanford.edu/software/segmenter.shtml) 

---
* Token 生成策略：[JSON Web Token（JWT）](https://jwt.io/)
* Feed 流实现：基于 Timestamp
* 设备认证：x509 证书 
* 文件上传：分块、分片并发上传、秒传、断点续传
* 分布式锁：zookeeper（Apache Curator InterProcessMutex 类）、redis（setnx + expire）
* 全局唯一ID：Twitter  Snowflake 算法

---
* Database：Mysql、SQLite、Oracle、MongoDB、Redis、HBase、Neo4j/cayley、influxDB
* 集中式日志：ELK、Flume、Grafana、Kafka
* RPC ： thrift、[dubbo](http://dubbo.io/)、dubboX