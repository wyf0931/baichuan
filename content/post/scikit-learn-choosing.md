---
title: Scikit-learn 选择合适的评估算法
author: Scott
tags:
  - scikit-learn
  - 机器学习
categories:
  - 技术
date: 2019-07-11 17:11:00
---
机器学习最麻烦的问题是找到合适的评估器（estimator）。评估器的选择依赖于数据类型和问题本身。针对不同数据集和问题类型，下图可以作为评估器选择的一个参考指南：


![upload successful](/images/pasted-12.png)

从 `START` 开始，首先看数据的样本是否大于 `50`，小于则需要收集更多的数据。

由图中可以看到，有四类算法：

* 分类（Classification）
* 回归（Regression）
* 聚类（Clustering）
* 降维（Dimensionality reduction）

其中 **分类和回归是监督式学习**，即每个数据对应一个标签。 **聚类是非监督式学习**，即没有标签。 另外一类是降维，**当数据集有很多很多属性的时候，可以通过降维算法把属性归纳起来**。例如 20 个属性只变成 2 个，注意，这不是挑出 2 个，而是压缩成为 2 个，它们集合了 20 个属性的所有特征，相当于把重要的信息提取的更好，不重要的信息就不要了。

然后看问题属于哪一类问题，是分类、回归还是聚类，就选择相应的算法。 当然还要考虑数据的大小，例如 `100K` 是一个阈值。

可以发现有些方法是既可以作为分类，也可以作为回归，例如 `SGD`。

> 原文地址：https://scikit-learn.org/stable/tutorial/machine_learning_map/index.html