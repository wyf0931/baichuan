---
title: Java 整数类型与取值范围
author: Scott
tags:
  - Java
categories:
  - 技术
date: 2019-07-02 16:03:00
---
<style>
table th:nth-of-type(1){
width: 10%;
}
table th:nth-of-type(2){
width: 20%;
}
table th:nth-of-type(3){
width: 30%;
}
table th:nth-of-type(4){
width: 30%;
}
table th:nth-of-type(5){
width: 10%;
}
</style>

本文主要介绍JVM中整数类型以及各类型值的范围区间。
<!--more-->

|类型|值范围|最小值|最大值|字节|
|---|---|---|---|---|
|byte|[-2<sup>7</sup>, 2<sup>7</sup> -1]|-128|127|1|
|short|[-2<sup>15</sup>, 2<sup>15</sup> -1]|-32768|32767|2|
|int|[-2<sup>31</sup>, 2<sup>31</sup> -1]|-2147483648|2147483647|4|
|long|[-2<sup>63</sup>, 2<sup>63</sup> -1]|-9223372036854775808|9223372036854775807|8|
|char|[0, 2<sup>16</sup> -1]|0|65535|2|

> 原文地址：http://docs.oracle.com/javase/specs/jvms/se8/html/jvms-2.html