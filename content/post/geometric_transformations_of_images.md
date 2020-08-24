---
title: 使用 OpenCV 对图像进行几何变换
author: Scott
tags:
  - OpenCV
categories:
  - 技术
date: 2019-07-14 13:20:00
---
本文介绍如何使用 OpenCV 对图像进行平移、旋转、仿射变换等几何变换操作。

<!--more-->

OpenCV 提供了两个图像变换的操作函数 [`cv.warpAffine`](https://docs.opencv.org/3.4.5/da/d54/group__imgproc__transform.html#ga0203d9ee5fcd28d40dbc4a1ea4451983) 和 [`cv.warpPerspective`](https://docs.opencv.org/3.4.5/da/d54/group__imgproc__transform.html#gaf73673a7e8e18ec6963e3774e6a94b87), 用它们可以进行各种转换。 `cv.warpAffine` 的参数是一个 `2x3` 的转换矩阵，`cv.warpPerspective`的参数是一个`3x3` 的转换矩阵。

### 缩放

缩放就是调整图像的大小，OpenCV 用 [`cv.resize()`](https://docs.opencv.org/3.4.5/da/d54/group__imgproc__transform.html#ga47a974309e9102f5f08231edc7e7529d) 函数来调整图像大小。图像大小可以自己指定，或者也可以指定缩放比例。也可以指定插值方法，对缩放操作来说，最好的插值方法是 [`cv.INTER_AREA`](https://docs.opencv.org/3.4.5/da/d54/group__imgproc__transform.html#gga5bb5a1fea74ea38e1a5445ca803ff121acf959dca2480cc694ca016b81b442ceb)、[`cv.INTER_CUBIC`](https://docs.opencv.org/3.4.5/da/d54/group__imgproc__transform.html#gga5bb5a1fea74ea38e1a5445ca803ff121a55e404e7fa9684af79fe9827f36a5dc1)（慢一些）和 [`cv.INTER_LINEAR`](https://docs.opencv.org/3.4.5/da/d54/group__imgproc__transform.html#gga5bb5a1fea74ea38e1a5445ca803ff121ac97d8e4880d8b5d509e96825c7522deb)（快一些），若不指定插值方法，则默认是 `cv.INTER_LINEAR`。可以参考以下代码来调整你的图像：

```python
import numpy as np
import cv2 as cv

img = cv.imread('messi5.jpg')
res = cv.resize(img, None, fx=2, fy=2, interpolation=cv.INTER_CUBIC)
# OR
height, width = img.shape[:2]
res = cv.resize(img, (2 * width, 2 * height), interpolation=cv.INTER_CUBIC)
```

### 平移
平移是对象位置的转换。如果你知道要从 (x,y) 移到 (t<sub>x</sub>,t<sub>y</sub>)，你可以创建变换矩阵M，如下所示：

$$M = \begin{bmatrix} 1 & 0 & t_x \\\\ 0 & 1 & t_y \end{bmatrix}$$

将 **M** 作为 `np.float32` 类型的 Numpy 数组传入 `cv.warpAffine()` 函数。如下所示偏移量为 `(100,50)`：

```python
import numpy as np
import cv2 as cv

img = cv.imread('messi5.jpg', 0)
rows, cols = img.shape
M = np.float32([[1, 0, 100], [0, 1, 50]])
dst = cv.warpAffine(img, M, (cols, rows))
cv.imshow('img', dst)
cv.waitKey(0)
cv.destroyAllWindows()
```
{%note warning%}
` cv.warpAffine()` 函数的第三个参数是输出图像的大小，参数的数据结构为 *(width, height)*，其实 width 就是 columns，height 就是 rows 。
{%endnote%}

![代码运行结果](/images/pasted-13.png)

### 旋转
通过下面的转换矩阵实现图像角度 `θ` 的变换：

$$
M = \begin{bmatrix} cos\theta & -sin\theta \\\\ sin\theta & cos\theta \end{bmatrix}
$$

OpenCV 提供了可调节旋转中心的缩放旋转，因此，你可以在任意位置进行旋转操作。修改后的变换矩阵为：

$$
\begin{bmatrix} \alpha & \beta & (1- \alpha ) \cdot center.x - \beta \cdot center.y \\\\ - \beta & \alpha & \beta \cdot center.x + (1- \alpha ) \cdot center.y \end{bmatrix}
$$

条件如下：

$$
\begin{array}{l} \alpha = scale \cdot \cos \theta , \\\\ \beta = scale \cdot \sin \theta \end{array}
$$

为了找到这个转换矩阵，OpenCV 提供了一个函数 `cv.getRotationMatrix2D`。以下示例，将图像相对于中心旋转 `90` 度而不进行任何缩放。

```python
img = cv.imread('messi5.jpg', 0)
rows, cols = img.shape

# cols-1 and rows-1 are the coordinate limits.
M = cv.getRotationMatrix2D(((cols - 1) / 2.0, (rows - 1) / 2.0), 90, 1)
dst = cv.warpAffine(img, M, (cols, rows))
```

![代码运行结果](/images/pasted-14.png)

### 仿射变换

在仿射变换中，原始图像中的所有平行线在输出图像中仍然是平行的。为了找到变换矩阵，我们需要输入图像中的三个点及其在输出图像中的相应位置，用 `cv.getAffineTransform` 创建一个 `2x3` 矩阵，作为 `cv.warpAffine` 的参数。请看以下示例，仔细看我用绿色标记的点：
```python
img = cv.imread('drawing.png')
rows, cols, ch = img.shape
pts1 = np.float32([[50, 50], [200, 50], [50, 200]])
pts2 = np.float32([[10, 100], [200, 50], [100, 250]])
M = cv.getAffineTransform(pts1, pts2)
dst = cv.warpAffine(img, M, (cols, rows))
plt.subplot(121), plt.imshow(img), plt.title('Input')
plt.subplot(122), plt.imshow(dst), plt.title('Output')
plt.show()
```
![代码运行结果](/images/pasted-15.png)

### 透视变换

透视变换在转换之后，直线依旧保持笔直。你需要一个 `3x3` 的变换矩阵，要找到这个变换矩阵，需要输入图像上的 4 个点和输出图像上的相应点。在这四点中，有三点不应该共线。然后通过函数 `cv.getPerspectiveTransform` 找到变换矩阵，将这个`3x3` 的变换矩阵作为 `cv.warpPerspective` 的参数。代码如下：
```python
img = cv.imread('sudoku.png')
rows, cols, ch = img.shape
pts1 = np.float32([[56, 65], [368, 52], [28, 387], [389, 390]])
pts2 = np.float32([[0, 0], [300, 0], [0, 300], [300, 300]])
M = cv.getPerspectiveTransform(pts1, pts2)
dst = cv.warpPerspective(img, M, (300, 300))
plt.subplot(121), plt.imshow(img), plt.title('Input')
plt.subplot(122), plt.imshow(dst), plt.title('Output')
plt.show()
```

![代码运行结果](/images/pasted-16.png)


> 原文地址：https://docs.opencv.org/3.4.5/da/d6e/tutorial_py_geometric_transformations.html