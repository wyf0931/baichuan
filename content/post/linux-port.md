---
title: 查看Linux端口使用情况
author: Scott
tags:
  - Linux
categories: []
date: 2019-08-05 16:35:00
---
本文将会介绍如何根据端口号来查找对应的进程。

<!--more-->
需要用到的Linux 命令：`netstat`、`lsof`、`ps`

1、查看本地 TCP 与 UDP 监听信息：

```bash
netstat -ltu
```
参数解释：

* -l 显示监听信息
* -t 表示 TCP
* -u 表示 UDP

输出类似如下：
```bash
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State
tcp        0      0 *:34727                 *:*                     LISTEN
tcp        0      0 *:sunrpc                *:*                     LISTEN
tcp        0      0 *:http                  *:*                     LISTEN
tcp        0      0 *:ssh                   *:*                     LISTEN
tcp6       0      0 [::]:sunrpc             [::]:*                  LISTEN
tcp6       0      0 [::]:http               [::]:*                  LISTEN
tcp6       0      0 [::]:43537              [::]:*                  LISTEN
tcp6       0      0 [::]:ssh                [::]:*                  LISTEN
tcp6       0      0 [::]:4000               [::]:*                  LISTEN
udp        0      0 *:bootpc                *:*
udp        0      0 *:sunrpc                *:*
udp        0      0 *:767                   *:*
udp6       0      0 [::]:sunrpc             [::]:*
udp6       0      0 [::]:767                [::]:*
```

2、此处以端口 `4000` 为例，使用 `lsof` 查看对应的进程，命令如下：
```bash
lsof  -iTCP:4000
```
输出信息如下：
```bash
COMMAND   PID   USER   FD   TYPE   DEVICE SIZE/OFF NODE NAME
hexo    13210 ubuntu   19u  IPv6 26630814      0t0  TCP *:4000 (LISTEN)
```

3、可以发现监听 `4000` 端口的进程 PID 是 `13210`，我们通过 `ps` 命令来查看对应的进程：
```bash
ps -ef|grep 13210
```
输出如下：
```bash
ubuntu    8938  8024  0 18:33 pts/1    00:00:00 grep --color=auto 13210
ubuntu   13210     1  0 Jul22 ?        00:03:29 hexo
```

此时就已经能找到对应的进程了，也就是我后台启动的 `hexo` 服务端。



> 扩展阅读：
> 
> * https://linux.die.net/man/8/lsof
> * https://www.jianshu.com/p/a3aa6b01b2e1

