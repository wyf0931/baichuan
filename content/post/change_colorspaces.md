---
title: 使用 OpenCV 转换图像颜色空间
author: Scott
tags:
  - OpenCV
categories:
  - 技术
date: 2019-07-15 16:23:00
---
本文介绍如何通过 opencv 来修改图像的色彩空间，比如：*BGR ↔ Gray,  BGR ↔ HSV*
<!--more-->

OpenCV 中有 150 多种颜色空间转换方法，但我们将只介绍两种使用最多的：*BGR↔Gray 和  BGR↔HSV*。

我们用 `cv.cvtColor(src, code)` 来转换颜色空间，其中 code 为要转换的类型。例如，BGR → Gray 时，`code` 为 [`cv.COLOR_BGR2GRAY`](https://docs.opencv.org/3.4.5/d8/d01/group__imgproc__color__conversions.html#gga4e0972be5de079fed4e3a10e24ef5ef0a353a4b8db9040165db4dacb5bcefb6ea)。同理，*BGR → HSV* 时，`code` 为 [`cv.COLOR_BGR2HSV`](https://docs.opencv.org/3.4.5/d8/d01/group__imgproc__color__conversions.html#gga4e0972be5de079fed4e3a10e24ef5ef0aa4a7f0ecf2e94150699e48c79139ee12)。可以用以下 Python 代码获取其他类型值：
```python
import cv2 as cv

flags = [i for i in dir(cv) if i.startswith('COLOR_')]
print(flags)
```


> 对于 HSV 来说，Hue 的范围是 `[0,179]`, Saturation 的范围是 `[0,255]`，Value 的范围是 `[0,255]`。 不同的软件使用不同的比例，因此，如果将 OpenCV 值与它们进行比较，则需要对这些范围进行 normalize 操作。

### 物体追踪

现在我们知道了如何将 BGR 图像转换为 HSV，我们可以使用它来提取彩色对象。在 HSV 中表示颜色比在 BGR 颜色空间中更容易。在我们的应用程序中，我们将尝试提取蓝色对象。所以方法如下：
* 从拍摄的视频中获取每一帧
* 颜色空间从  BGR 转为 HSV
* 对 HSV 图像的蓝色范围设定阈值
* 单独提取出蓝色，看看是不是我们想要的

```python
import cv2 as cv
import numpy as np

cap = cv.VideoCapture(0)
while (1):
    # Take each frame
    _, frame = cap.read()
    # Convert BGR to HSV
    hsv = cv.cvtColor(frame, cv.COLOR_BGR2HSV)
    # define range of blue color in HSV
    lower_blue = np.array([110, 50, 50])
    upper_blue = np.array([130, 255, 255])
    # Threshold the HSV image to get only blue colors
    mask = cv.inRange(hsv, lower_blue, upper_blue)
    # Bitwise-AND mask and original image
    res = cv.bitwise_and(frame, frame, mask=mask)
    cv.imshow('frame', frame)
    cv.imshow('mask', mask)
    cv.imshow('res', res)
    k = cv.waitKey(5) & 0xFF
    if k == 27:
        break
cv.destroyAllWindows()
```

![追踪到的蓝色物体](/images/pasted-17.png)

> 图像中有一些噪点，我们在以后的章节会介绍如何去除这些噪点。

### 如何找到要跟踪的 HSV 值？
这是 `stackoverflow.com` 中常见的问题，方法很简单，使用 `cv.cvtcolor()` 函数，参数传入 `BGR` 值，不要传图像。比如，要查找绿色的 `hsv`，Python 代码如下：
```python
green = np.uint8([[[0, 255, 0]]])
hsv_green = cv.cvtColor(green, cv.COLOR_BGR2HSV)
print(hsv_green)
```

我们取 `[H-10, 100,100]` 作为下限，取`[H+10, 255, 255]` 作为上限。除此之外，还可以用其他图像编辑工具（如 GIMP）或在线转换器来获取这些值（记得调整 HSV 范围）。


### 相关函数
* [`cv.VideoCapture(index)`](https://docs.opencv.org/3.4.5/d8/dfe/classcv_1_1VideoCapture.html#ad890d4783ff81f53036380bd89dd31aa) ：打开相机进行视频捕获
* [`cv.cvtColor(src, code[, dst[, dstCn]])`](https://docs.opencv.org/3.4.5/d8/d01/group__imgproc__color__conversions.html#ga397ae87e1288a81d2363b61574eb8cab) ：将图像从一个颜色空间转换为另一个颜色空间
* [`cv.inRange(src, lowerb, upperb[, dst])`](https://docs.opencv.org/3.4.5/d2/de8/group__core__array.html#ga48af0ab51e36436c5d04340e036ce981)  ：检查数组元素是否位于其他两个数组的元素之间
* [`cv.bitwise_and(src1, src2[, dst[, mask]])`](https://docs.opencv.org/3.4.5/d2/de8/group__core__array.html#ga60b4d04b251ba5eb1392c34425497e14) ：计算两个数组的位联合（dst=src1&src2）



> 原文地址：https://docs.opencv.org/3.4.5/df/d9d/tutorial_py_colorspaces.html