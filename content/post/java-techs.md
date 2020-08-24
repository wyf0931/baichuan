---
title: Java服务端开发常用技术总结
author: Scott
tags:
  - Java
categories: []
date: 2019-06-29 00:00:00
---

### 一、Java基础知识
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

### 二、框架&中间件&数据库
* RPC ： thrift、[dubbo](http://dubbo.io/)、[dubboX](https://github.com/dangdangdotcom/dubbox)、[gRPC](https://grpc.io/)
* 分布式缓存：[Redis](https://redis.io/)、MongoDB、memcached（支持的数据结构有差异）；
* 进程缓存：[Ehcache](http://www.ehcache.org/)；
* NIO框架：[Netty](https://netty.io/)、[Mina](http://mina.apache.org/)；
* 图像处理：[GraphicsMagic](http://www.graphicsmagick.org/)、ImageMagic、[OpenCV](https://opencv.org/)
* 消息队列：[RocketMQ（Java）](https://rocketmq.apache.org/)、[Kafka](http://kafka.apache.org/)、ActiveMQ、rabbitMQ
* 常用文本搜索引擎：[Lucene](https://lucene.apache.org/)、Elasticsearch、[Solr](https://lucene.apache.org/solr/)；
* 常用中文分词器：IK Analyzer、ansj、jcseg、[Stanford分词器](https://nlp.stanford.edu/software/segmenter.shtml) 
* 数据库：
  * 关系型
    * 常规：[MySQL](https://www.mysql.com/)、[Oracle](https://www.oracle.com/database/)；
    * 嵌入式数据库：[SQLite](https://sqlite.org/index.html)、[H2](http://h2database.com/html/main.html)；
  * 非关系型（NoSQL）
    * 时序数据库：[InfluxDB](https://www.influxdata.com/)
    * 图数据库：Neo4j/cayley
    * 其他：[MongoDB](https://www.mongodb.com/)、[HBase](http://hbase.apache.org/)；


### 三、算法
* 倒排索引：Lucene
* LBS算法：Google S2算法、GeoHash
* 树型数据结构：前缀（字典）树、B 树、B+树、红黑树
* 加密算法：对称加密（DES、3DES、RC2、RC4、AES、BlowFish）、非对称加密（RSA、ECC）
* 摘要算法：SHA1、SHA128、MD5、CRC
* 一致性 Hash：[MurmurHash](https://zh.wikipedia.org/wiki/Murmur%E5%93%88%E5%B8%8C)
* 位图（Bitmap）：大数据量的统计、去重、排序
* 全局唯一ID：[Twitter  Snowflake](https://github.com/twitter-archive/snowflake/releases/tag/snowflake-2010);
* 分布式一致性：Raft、Paxos；

### 四、方案设计
* Token 生成策略：[JSON Web Token（JWT）](https://jwt.io/)
* Feed 流实现：基于 Timestamp；
* 设备认证：x509 证书 
* 文件上传：分块、分片并发上传、秒传、断点续传
* 分布式锁：zookeeper（Apache Curator InterProcessMutex 类）、redis（setnx + expire）
* 日志三件套：ELK：Elasticsearch + Logstash（Flume）+ Kibana（Grafana），大流量时可以用 Kafka 做缓冲；
* HttpDns实现：ip转int（255进制）、 二分查找

---
### 网络 & 操作系统
* Linux：Epoll 方法实现
* TCP/IP：三次握手、滑动窗口、时间窗口、FD 默认值1024（File Description）
* 常用协议：http/https/http2、websockect、TCP、UDP、UDT

### 理论
---
* 分布式BASE模型：基本可用、软状态（异步）、最终一致
* 分布式CAP理论：一致性、可用性、可靠性（分区容错），三选二
* 池：线程池（ThreadPool）、连接池（ConnectionPool）
