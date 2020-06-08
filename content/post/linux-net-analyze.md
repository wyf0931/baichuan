---
title: Linux实时查看网络带宽占用情况
author: Scott
tags:
  - AMQP
  - 协议
categories: []
date: 2020-06-08T17:24:28+08:00
---

Linux 中查看网卡流量工具有*iptraf*、*iftop* 以及 *nethogs* 等，iftop可以用来监控网卡的实时流量（可以指定网段）、反向解析IP、显示端口信息等。



## 场景

1. 用于分析异常流量；
2. 找到和当前主机交互的主机中谁占用的网络资源最多；

## 安装

Ubuntu：

```bash
sudo apt-get install iftop
```

Centos:

```bash
yum install iftop -y
```

## 使用

```bash
ubuntu@VM-0-3-ubuntu:~$ iftop -h
iftop: display bandwidth usage on an interface by host

Synopsis: iftop -h | [-npblNBP] [-i interface] [-f filter code]
                [-F net/mask] [-G net6/mask6]

   -h                  display this message
   -n                  don't do hostname lookups
   -N                  don't convert port numbers to services
   -p                  run in promiscuous mode (show traffic between other
        hosts on the same network segment)
   -b                  don't display a bar graph of traffic
   -B                  Display bandwidth in bytes
   -i interface        listen on named interface
   -f filter code      use filter code to select packets to count
        (default: none, but only IP packets are counted)
   -F net/mask         show traffic flows in/out of IPv4 network
   -G net6/mask6       show traffic flows in/out of IPv6 network
   -l                  display and count link-local IPv6 traffic (default: off)
   -P                  show ports as well as hosts
   -m limit            sets the upper limit for the bandwidth scale
   -c config file      specifies an alternative configuration file
   -t                  use text interface without ncurses

   Sorting orders:
   -o 2s                Sort by first column (2s traffic average)
   -o 10s               Sort by second column (10s traffic average) [default]
   -o 40s               Sort by third column (40s traffic average)
   -o source            Sort by source address
   -o destination       Sort by destination address

   The following options are only available in combination with -t
   -s num              print one single text output afer num seconds, then quit
   -L num              number of lines to print

iftop, version 1.0pre4
copyright (c) 2002 Paul Warren <pdw@ex-parrot.com> and contributors
```

第一步：通过 `ifconfig` 命令查看本地网卡名称；

第二步：通过 `iftop` 命令查看指定某个网卡的流量，此处以 `eth0` 为例：

```
ubuntu@VM-0-3-ubuntu:~$ sudo iftop -i eth0
```

命令行输出如下：

```bash
VM-0-3-ubuntu    => 183.134.211.54    5.22Kb  12.0Kb  7.41Kb
                 <=                   2.03Kb  3.33Kb  1.79Kb
VM-0-3-ubuntu    => server-185-153-196-230.cloudedic.net             160b   2.58Kb  1.57Kb
                 <=                    672b   2.15Kb  1.41Kb
VM-0-3-ubuntu    => 169.254.0.4          0b   2.70Kb  3.04Kb
                 <=                      0b   1.19Kb  1.41Kb
VM-0-3-ubuntu    => 197.85.209.222.broad.cd.sc.dynamic.163data.com  7.94Kb  1.59Kb   407b
                 <=                   4.44Kb   910b    227b
VM-0-3-ubuntu    => 169.254.0.55         0b    194b    845b
                 <=                      0b    196b    305b
VM-0-3-ubuntu    => 169.254.128.2      112b     90b     73b
                 <=                    112b     90b     73b
VM-0-3-ubuntu    => 169.254.128.3      112b     67b     73b
                 <=                    112b     67b     73b
VM-0-3-ubuntu    => 111.231.215.244      0b      0b    678b
                 <=                      0b      0b    292b
VM-0-3-ubuntu    => 182.254.52.17        0b      0b    683b
                 <=                      0b      0b    112b
VM-0-3-ubuntu    => 95x78x251x116.static-business.oren.ertelecom.r     0b      0b    451b
                 <=                      0b      0b    290b
VM-0-3-ubuntu    => 183.60.83.19         0b      0b    111b
                 <=                      0b      0b    184b
VM-0-3-ubuntu    => 169.254.0.2          0b      0b     61b
                 <=                      0b      0b     46b
VM-0-3-ubuntu    => 119.29.230.78        0b      0b     55b
                 <=                      0b      0b     42b
────────────────────────────────────────────────────────────────────────────────────────────────────────────────
TX:             cum:    185KB   peak:   39.3Kb      rates:   13.5Kb  19.2Kb  15.4Kb
RX:                    79.8KB           12.6Kb               7.35Kb  7.89Kb  6.21Kb
TOTAL:                  265KB           49.4Kb               20.9Kb  27.1Kb  21.6Kb
```

输出参数说明：

| 参数  | 说明                              |
| ----- | --------------------------------- |
| =>    | 发送流量                          |
| <=    | 接收流量                          |
| TX    | 从网卡发出的流量                  |
| RX    | 网卡接收流量                      |
| TOTAL | 网卡发送接收总流量                |
| cum   | iftop开始运行到当前时间点的总流量 |
| peak  | 网卡流量峰值                      |

