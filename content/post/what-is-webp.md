---
title: WebP 是什么？
identifier: what-is-webp
author: Scott
date: 2022-01-07T13:23:56.869Z
tags:
  - 图像
  - 协议
categories:
  - 技术
---
WebP 是一种用于 Web 的图像格式。

<!--more-->

官网：<https://developers.google.com/speed/webp/>

源码仓库：<https://www.webmproject.org/code/#libwebp-webp-image-library>

### 一、简介

#### 1.1 基本功能

* 支持无损、有损数据压缩；
* 文件大小更小；
* 支持半透明；
* 增量解码；

#### 1.2 效果对比

* 无损图像：比 PNG 小26%；
* 相同SSIM质量指数：比 JPEG 小 25%～34%；
* 支持半透明（alpha 通道）：

  * 无损 + 半透明：相比于单纯的无损文件，大小只增加了 22%；
  * 有损 RGB 压缩 + 半透明：比 PNG 文件小 3倍左右；

> SSIM：structural similarity index，结构相似性指标。是一种用以衡量两张[数位影像](https://zh.wikipedia.org/wiki/%E6%95%B8%E4%BD%8D%E5%BD%B1%E5%83%8F)相似程度的指标。当两张影像其中一张为无[失真](https://zh.wikipedia.org/wiki/%E5%A4%B1%E7%9C%9F)影像，另一张为[失真](https://zh.wikipedia.org/wiki/%E5%A4%B1%E7%9C%9F)后的影像，二者的结构相似性可以看成是失真影像的影像品质衡量指标。相较于传统所使用的影像品质衡量指标，像是[峰值信噪比](https://zh.wikipedia.org/wiki/%E5%B3%B0%E5%80%BC%E4%BF%A1%E5%99%AA%E6%AF%94)（英语：PSNR），结构相似性在影像品质的衡量上更能符合人眼对影像品质的判断。
>
> 参考链接：<https://zh.wikipedia.org/wiki/%E7%B5%90%E6%A7%8B%E7%9B%B8%E4%BC%BC%E6%80%A7>

### 二、技术原理

#### 2.1 有损

WebP 压缩使用预测编码对图像进行编码，与 VP8 视频编解码器对视频关键帧进行压缩的方法相同。

**预测编码使用邻近像素块中的值来预测块中的值，然后仅对差值进行编码。**

#### 2.2 无损

WebP 压缩使用已经看到的图像片段，以便精确重建新的像素。如果没有找到有趣的匹配项，它也可以使用本地调色板。

详细技术细节参考：<https://developers.google.com/speed/webp/docs/compression>

WebP 文件由 [VP8](https://datatracker.ietf.org/doc/rfc6386/) 或 [VP8L](https://developers.google.com/speed/webp/docs/webp_lossless_bitstream_specification) 图像数据和基于 [RIFF](https://developers.google.com/speed/webp/docs/riff_container) 的容器组成。

独立的 `libwebp` 库充当 WebP 规范的参考案例，可以从 [Git仓库](https://www.webmproject.org/code/#libwebp-webp-image-library) 或 [tarball](https://developers.google.com/speed/webp/download) 中看源代码。

### 三、支持情况

目前大部分浏览器都已经支持Web P了。

WebP 包括以下部分：

1. 轻量级的编码库： [`libwebp`](https://developers.google.com/speed/webp/docs/api)
2. 命令行工具： [`cwebp`](https://developers.google.com/speed/webp/docs/cwebp) 、 [`dwebp`](https://developers.google.com/speed/webp/docs/dwebp)
3. 动画工具：<https://developers.google.com/speed/webp/download>

#### 3.1 支持有损Web

* Google Chrome (desktop) 17+
* Google Chrome for Android version 25+
* Microsoft Edge 18+
* Firefox 65+
* Opera 11.10+
* Native web browser, Android 4.0+ (ICS)

#### 3.2 支持WebP动画

* Google Chrome (desktop and Android) 32+
* Microsoft Edge 18+
* Firefox 65+
* Opera 19+

#### 3.3 支持有损+无损+alpha通道

* Google Chrome (desktop) 23+
* Google Chrome for Android version 25+
* Microsoft Edge 18+
* Firefox 65+
* Opera 12.10+
* Native web browser, Android 4.2+ (JB-MR1)
* Pale Moon 26+

### 四、文件转换

[Linux, Windows or macOS](https://developers.google.com/speed/webp/docs/precompiled) 平台下可以下载 `cwebp` ，将 PNG 和 JPEG 文件批量转换为 WebP 文件。

### 五、常见问题

#### 5.1 WebP 最大尺寸是多少？

WebP 是位流兼容（bitstream-compatible） VP8，并使用 14位的宽度和高度。WebP 图像的最大像素尺寸为 16383 x 16383。

#### 5.2 WebP 格式支持什么颜色空间？

有损 WebP 只使用8位 Y'CbCr 4:2:0 （通常称为 YUV420）格式的图像，与 VP8 位流一致。详情参考 RFC 6386、 [VP8 数据格式和解码指南](https://datatracker.ietf.org/doc/html/rfc6386) 第2节 “[格式概述](https://datatracker.ietf.org/doc/html/rfc6386#section-2)”。

无损耗 WebP 用的是 RGBA 格式，参考 [无损位流规范](https://developers.google.com/speed/webp/docs/webp_lossless_bitstream_specification)；

#### 5.3 转为 WebP 图像后，有没有可能文件大小比原图像大？

有可能。通常在从有损格式转换为无损格式时，或者反之亦然。这主要是由于色彩空间的差异 （YUV420与 ARGB）和这些之间的转换。有三种典型场景：

1. 如果源图像是无损的 ARGB 格式，空间下采样到 YUV420 将引入新的颜色，比原来的颜色更难压缩，一般这种情况下原图是 PNG 格式，只有几种颜色时：转换为有损的 WebP （或者类似于有损的 JPEG）；
2. 如果原图是有损格式，然后转换成了无损的WebP 图像。例如，将 JPEG 原图转换为无损的 WebP 或 PNG 格式。
3. 如果原图格式为有损格式，并且你想将其压缩为有损的 WebP，并设置更高的质量。例如，试图将以 quality 80 保存的 JPEG 文件转换为以 quality 95 保存的 WebP 文件，这样可能会产生更大的文件。

   一般情况下是无法评估原图 quality 的，如果发现文件比较大，可以下调 WebP quality 值；或者不要去设置 quality 值，而是用 `cwebp` 工具中 `-size` 参数来设定文件大小。

#### 5.4 WebP 支持渐进显示还是隔行显示？

WebP 不提供 JPEG 或 PNG 意义上的渐进或隔行解码刷新。这可能会给解码机器的 CPU 和内存带来较大压力，因为每次刷新都需要完整的解压缩过程。

平均来说，解码一个渐进的 JPEG 图像相当于解码基线（*baseline*）13次。

**WebP 提供增量解码功能**，这既节省了客户端的内存、 CPU，又能动态展示下载过程。增量解码特性可以通过[高级解码 API 实现](https://developers.google.com/speed/webp/docs/api#advanced_decoding_api)。