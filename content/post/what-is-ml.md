---
title: 什么是机器学习？
author: Scott
tags:
  - 机器学习
categories:
  - 技术
date: 2019-07-30 17:29:00
---
机器学习是一种数据分析技术，让计算机执行人和动物与生俱来的活动：从经验中学习。机器学习算法使用计算方法直接从数据中“学习”信息，而不依赖于预定方程模型。当可用于学习的样本数量增加时，这些算法可自适应提高性能。

<!--more-->

机器学习算法能够更好地制定决策和做出预测。医疗诊断、股票交易、能量负荷预测及更多行业每天都在使用这些算法制定关键决策。例如，媒体网站依靠机器学习算法从数百万种选项中筛选出为您推荐的歌曲或影片。零售商利用这些算法深入了解客户的购买行为。

### 机器学习为什么重要？
随着大数据应用增加，机器学习已成为解决以下领域问题的一项关键技术：

* 计算金融学，用于[信用评估](https://ww2.mathworks.cn/discovery/credit-scoring-model.html)和[算法交易](https://ww2.mathworks.cn/discovery/algorithmic-trading.html)
* 图像处理和计算机视觉，用于[人脸识别](https://ww2.mathworks.cn/discovery/face-recognition.html)、运动检测和[对象检测](https://ww2.mathworks.cn/discovery/object-detection.html)
* 计算生物学，用于肿瘤检测、药物发现和 DNA 序列分析
* 能源生产，用于预测价格和[负载](https://ww2.mathworks.cn/discovery/load-forecasting.html)
* 汽车、航空航天和制造业，用于[预见性维护](https://ww2.mathworks.cn/solutions/predictive-maintenance.html)
* 自然语言处理，用于语音识别应用

### 何时应该使用机器学习？
当遇到涉及大量数据和许多变量的复杂任务或问题，但没有现成的处理公式或方程式时，可以考虑使用机器学习。例如，如果需要处理以下情况，使用机器学习是一个很好的选择：
* 手写规则和方程式太过复杂——例如人脸识别和语音识别。
* 任务的规则始终在变化——例如通过交易记录进行欺诈检测。
* 数据本身在不断变化，程序也必须适应这种变化——例如自动交易、能量需求预测和购物趋势预测等。

### 机器学习的工作原理
机器学习采用两种技术：**监督式学习** 和 **无监督学习**。监督式学习根据已知的输入和输出训练模型，让模型能够预测未来输出；无监督学习从输入数据中找出隐藏模式或内在结构。

![图 1：机器学习技术包括监督式学习和无监督学习](/images/pasted-18.png)

##### 监督式学习
[监督式机器学习](https://ww2.mathworks.cn/discovery/supervised-learning.html)能够根据已有的包含不确定性的数据建立一个预测模型。监督式学习算法接受已知的输入数据集（包含预测变量）和对该数据集的已知响应（输出，响应变量），然后训练模型，使模型能够对新输入数据的响应做出合理的预测。如果您尝试去预测已知数据的输出，则使用监督式学习。

**监督式学习通过分类或回归技术来实现预测模型。**

**分类技术可预测离散的响应** — 例如，电子邮件是不是垃圾邮件，肿瘤是恶性还是良性的。分类模型可将输入数据划分成不同类别。典型的应用包括医学成像、语音识别和信用评估。

如果您的数据能进行标记、分类或分为特定的组或类，则使用分类。例如，笔迹识别的应用程序使用分类来识别字母和数字。在图像处理和计算机视觉中，[无监督模式识别](https://ww2.mathworks.cn/discovery/pattern-recognition.html)技术用于对象检测和图像分割。

常用分类算法包括：[支持向量机 (SVM)](https://ww2.mathworks.cn/help/stats/support-vector-machine-classification.html)、[提升 (boosted) 决策树](https://ww2.mathworks.cn/help/stats/classification-ensembles.html)和[袋装 (bagged)](https://ww2.mathworks.cn/help/stats/classification-ensembles.html)、[决策树](https://ww2.mathworks.cn/help/stats/classification-trees.html)、[k-最近邻](https://ww2.mathworks.cn/help/stats/classification-nearest-neighbors.html)、[朴素贝叶斯 (Naïve Bayes)](https://ww2.mathworks.cn/help/stats/classification-naive-bayes.html)、[判别分析](https://ww2.mathworks.cn/help/stats/classification-discriminant-analysis.html)、[逻辑回归](https://ww2.mathworks.cn/help/stats/generalized-linear-regression-1.html)和[神经网络](https://ww2.mathworks.cn/help/deeplearning/pattern-recognition-and-classification.html)。

**回归技术可预测连续的响应** — 例如，温度的变化或电力需求中的波动。典型的应用包括电力系统负荷预测和算法交易。

如果您在处理一个数据范围，或您的响应性质是一个实数（比如温度，或一件设备发生故障前的运行时间），则使用回归方法。

常用回归算法包括：[线性模型](https://ww2.mathworks.cn/help/stats/multiple-linear-regression-1.html)、[非线性模型](https://ww2.mathworks.cn/help/stats/nonlinear-models.html)、[规则化](https://ww2.mathworks.cn/help/stats/regularization-1.html)、[逐步回归](https://ww2.mathworks.cn/help/stats/stepwise-regression-1.html)、[提升 (boosted)](https://ww2.mathworks.cn/help/stats/classification-ensembles.html) 和[袋装 (bagged)](https://ww2.mathworks.cn/help/stats/classification-ensembles.html)、[决策树](https://ww2.mathworks.cn/help/stats/classification-trees.html)、[神经网络](https://ww2.mathworks.cn/help/deeplearning/function-approximation-and-nonlinear-regression.html)和[自适应神经模糊学习](https://ww2.mathworks.cn/help/fuzzy/anfis.html)。

##### 无监督学习
[无监督学习](https://ww2.mathworks.cn/discovery/unsupervised-learning.html)可发现数据中隐藏的模式或内在结构。这种技术可根据未做标记的输入数据集得到推论。

聚类是一种最常用的无监督学习技术。这种技术可通过探索性数据分析发现数据中隐藏的模式或分组。[聚类分析](https://ww2.mathworks.cn/discovery/cluster-analysis.html)的应用包括基因序列分析、市场调查和对象识别。

例如，如果移动电话公司想优化他们手机信号塔的建立位置，则可以使用机器学习来估算依赖这些信号塔的人群数量。一部电话一次只能与一个信号塔通信，所以，该团队使用聚类算法设计蜂窝塔的最佳布局，优化他们的客户群组或集群的信号接收。

用于执行聚类的常用算法包括：[k-均值和 k-中心点（k-medoids）](https://ww2.mathworks.cn/help/stats/k-means-clustering-12.html)、[层次聚类](https://ww2.mathworks.cn/help/stats/hierarchical-clustering-12.html)、[高斯混合模型](https://ww2.mathworks.cn/help/stats/gaussian-mixture-models-1.html)、[隐马尔可夫模型](https://ww2.mathworks.cn/help/stats/hidden-markov-models.html)、[自组织映射](https://ww2.mathworks.cn/help/deeplearning/self-organizing-maps.html)、[模糊 c-均值聚类法](https://ww2.mathworks.cn/help/fuzzy/fcm.html)和[减法聚类](https://ww2.mathworks.cn/help/fuzzy/subclust.html)。


![图 2：聚类可找出数据中隐藏的模式](/images/pasted-19.png)

##### 如何确定使用哪种机器学习算法？

选择正确的算法看似难以驾驭——需要从几十种监督式和无监督机器学习算法中选择，每种算法又包含不同的学习方法。

没有最佳方法或万全之策。找到正确的算法只是试错过程的一部分——即使是经验丰富的数据科学家，也无法说出某种算法是否无需试错即可使用。但算法的选择还取决于您要处理的数据的大小和类型、您要从数据中获得的洞察力以及如何运用这些洞察力。

![图 3：机器学习技术](/images/pasted-20.png)

下面是选择监督式或者无监督机器学习的一些准则：

* 监督式学习：需要训练模型进行预测（例如温度和股价等连续变量的值）或者分类（例如根据网络摄像头的录像片段确定汽车的技术细节）。
* 无监督学习：需要深入了解数据并希望训练模型找到好的内部表示形式，例如将数据拆分到集群中。