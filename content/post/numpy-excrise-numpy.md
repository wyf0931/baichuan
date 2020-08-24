---
title: "101 个 NumPy 数据分析练习（1～20）"
author: Scott
tags:
  - Python
  - Numpy
categories:
  - 技术
date: 2020-02-06T20:33:20+08:00
draft: false
---

此练习的目的是灵活应用 Numpy，成为一种参考。**练习题分为4个难度级别，其中 L1 最容易，L4 最困难。**
<!--more-->
Numpy 教程第2部分：数据分析的重要功能。 如果您想快速了解 numpy，最好使用以下教程：

* [Numpy Tutorial Part 1: Introduction](https://www.machinelearningplus.com/numpy-tutorial-part1-array-python-examples)
* [Numpy Tutorial Part 2: Advanced numpy tutorials](https://www.machinelearningplus.com/numpy-tutorial-python-part2)



## 难度级别：L1
1. 将 `numpy` 导入为 `np` 并查看版本
```python
import numpy as np
print(np.__version__)
#> 1.13.3
```
2. 创建一维数组
```python
# 创建一个从0到9的一维数字数组
# Desired output:
#> array([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
arr = np.arange(10)
arr
```

3. 创建布尔型数组
```python
# 创建所有 True 的 3×3 numpy 数组 

# Desired output:
#> array([[ True,  True,  True],
#>        [ True,  True,  True],
#>        [ True,  True,  True]], dtype=bool)

# Solution
# Method 1:
np.full((3, 3), True, dtype=bool)

# Method 2:
np.ones((3,3), dtype=bool)
```

4. 从一维数组中提取满足给定条件的元素
```python
# 从`arr` 提取所有奇数
# Input:
arr = np.array([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])

# Desired output:
#> array([1, 3, 5, 7, 9])

# Solution
arr[arr % 2 == 1]
```
5. 用 numpy 数组中的另一个值替换满足条件的元素
```python
# 将 arr中的所有奇数替换为 -1
# Input:
arr = np.array([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])

# Desired Output:
#> array([ 0, -1,  2, -1,  4, -1,  6, -1,  8, -1])

# Solution
arr[arr % 2 == 1] = -1
arr
```

6. 重塑数组

```python
# 将一维数组转换为2行的二维数组
# Input:
arr = np.arange(10)

# Desired Output:
#> array([[0, 1, 2, 3, 4],
#>        [5, 6, 7, 8, 9]])

# Solution
arr.reshape(2, -1)  # Setting to -1 automatically decides the number of cols
```




## 难度级别：L2

1. 如何在不影响原始数组的情况下替换满足条件的元素？

```python
# 将 arr 中的所有奇数替换为-1，而不更改 arr
# Input:
arr = np.array([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])

# Desired Output:
out
#>  array([ 0, -1,  2, -1,  4, -1,  6, -1,  8, -1])
arr
#>  array([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])

# Solution
arr = np.arange(10)
out = np.where(arr % 2 == 1, -1, arr)

print(arr)
out
```

2. 如何垂直堆叠两个数组？

```python
# 垂直堆叠数组 a 和 b 
# Input:
a = np.arange(10).reshape(2,-1)
b = np.repeat(1, 10).reshape(2,-1)

# Desired Output:
#> array([[0, 1, 2, 3, 4],
#>        [5, 6, 7, 8, 9],
#>        [1, 1, 1, 1, 1],
#>        [1, 1, 1, 1, 1]])

# Solution
# Method 1:
np.concatenate([a, b], axis=0)

# Method 2:
np.vstack([a, b])

# Method 3:
np.r_[a, b]
```

3. 如何水平堆叠两个数组？

```python
# 水平堆叠数组 a 和 b
# Input:
a = np.arange(10).reshape(2,-1)
b = np.repeat(1, 10).reshape(2,-1)

# Desired Output:
#> array([[0, 1, 2, 3, 4, 1, 1, 1, 1, 1],
#>        [5, 6, 7, 8, 9, 1, 1, 1, 1, 1]])

# Solution
# Method 1:
np.concatenate([a, b], axis=1)

# Method 2:
np.hstack([a, b])

# Method 3:
np.c_[a, b]
```

4. 如何在 numpy 中生成自定义序列（不能硬编码）？

```python
# 创建以下模式而不进行硬编码。仅使用numpy函数和下面的输入数组 a
# Input:
  a = np.array([1,2,3])
# Desired Output:
#> array([1, 1, 1, 2, 2, 2, 3, 3, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3])

# Solution:
np.r_[np.repeat(a, 3), np.tile(a, 3)]
```

5. 如何获取两个 numpy 数组之间的公共项？

```python
# 获取 a 和 b 之间的共同项
# Input:
a = np.array([1,2,3,2,3,4,3,4,5,6])
b = np.array([7,2,10,2,7,4,9,4,9,8])
# Desired Output:
array([2, 4])

# Solution:
np.intersect1d(a,b)
```

6. 如何从一个数组中删除存在于另一个数组中的那些项？

```python
# 从数组 a 删除数组 b 中存在的所有项目
# Input:
a = np.array([1,2,3,4,5])
b = np.array([5,6,7,8,9])

# Desired Output:
array([1,2,3,4])

# Solution:
# From 'a' remove all of 'b'
np.setdiff1d(a,b)
```

7. 如何获得两个数组的元素匹配的位置？

```python
# 获取 a 和 b 元素匹配的位置
# Input:
a = np.array([1,2,3,2,3,4,3,4,5,6])
b = np.array([7,2,10,2,7,4,9,4,9,8])

# Desired Output:
#> (array([1, 3, 5, 7]),)

# Solution:
np.where(a == b)
```

8. 如何从numpy数组中提取给定范围内的所有数字？

```python
# 从a获取5~10之间的所有元素
# Input:
a = np.array([2, 6, 1, 9, 10, 3, 27])

# Desired Output:
(array([6, 9, 10]),)

# Solution:
a = np.arange(15)

# Method 1
index = np.where((a >= 5) & (a <= 10))
a[index]

# Method 2:
index = np.where(np.logical_and(a>=5, a<=10))
a[index]

# Method 3: (thanks loganzk!)
a[(a >= 5) & (a <= 10)]
```

9. 如何使处理标量的python函数在numpy数组上工作？

```python
# 将对两个标量起作用的函数 maxx 转换为对两个数组起作用。
# Desired Output:
a = np.array([5, 7, 9, 8, 6, 4, 5])
b = np.array([6, 3, 4, 8, 9, 7, 1])

pair_max(a, b)
#> array([ 6.,  7.,  9.,  8.,  9.,  7.,  5.])

# Solution:
def maxx(x, y):
    """Get the maximum of two items"""
    if x >= y:
        return x
    else:
        return y

pair_max = np.vectorize(maxx, otypes=[float])

a = np.array([5, 7, 9, 8, 6, 4, 5])
b = np.array([6, 3, 4, 8, 9, 7, 1])

pair_max(a, b)
```

10. 如何在二维numpy数组中交换两列？

```python
# 交换数组 arr 中的列1和列2。
# Input:
arr = np.arange(9).reshape(3,3)

# Desired Output:
#> array([[1, 0, 2],
#>        [4, 3, 5],
#>        [7, 6, 8]])

# Solution:
arr[:, [1,0,2]]
```

11. 如何在二维numpy数组中交换两行？

```python
# 交换数组 arr 中的第1行和第2行
# Input:
arr = np.arange(9).reshape(3,3)

# Desired Output:
#> array([[3, 4, 5],
#>        [0, 1, 2],
#>        [6, 7, 8]])

# Solution:
arr[[1,0,2], :]
```
12.  如何反转二维数组的行？
```python
# 反转二维数组 arr 的行
# Input:
arr = np.arange(9).reshape(3,3)

# Desired Output:
#> array([[6, 7, 8],
#>        [3, 4, 5],
#>        [0, 1, 2]])

# Solution:
arr[::-1]
```
13.  如何反转二维数组的列？
```python
# 反转二维数组 arr 的列
# Input:
arr = np.arange(9).reshape(3,3)

# Desired Output:
#> array([[2, 1, 0],
#>        [5, 4, 3],
#>        [8, 7, 6]])

# Solution:
arr[:, ::-1]
```
14.  如何创建一个包含 `5~10` 之间的随机浮点数的二维数组？
```python
# 创建形状为5x3的二维数组，以包含5~10之间的随机十进制数
# Input:
arr = np.arange(9).reshape(3,3)

# Desired Output:
#> [[ 8.50061025  9.10531502  6.85867783]
#>  [ 9.76262069  9.87717411  7.13466701]
#>  [ 7.48966403  8.33409158  6.16808631]
#>  [ 7.75010551  9.94535696  5.27373226]
#>  [ 8.0850361   5.56165518  7.31244004]]

# Solution:
# Method 1:
rand_arr = np.random.randint(low=5, high=10, size=(5,3)) + np.random.random((5,3))
print(rand_arr)

# Method 2:
rand_arr = np.random.uniform(5,10, size=(5,3))
print(rand_arr)
```



原文地址：

https://www.machinelearningplus.com/python/101-numpy-exercises-python/

相关文章：

* [101 Practice exercises with pandas](https://www.machinelearningplus.com/python/101-pandas-exercises-python/)