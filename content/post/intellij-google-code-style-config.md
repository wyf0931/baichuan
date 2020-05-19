---
title: "Intellij IDEA 配置 Google Code Style"
date: 2019-12-20T12:56:52+08:00
author: Scott
tags: 
  - java
  - 工具
categories: []
---
本文介绍如何在 Intellij IDEA 中配置Google 开源的  Java Code Style。
<!--more-->

## 下载 Google Code Style

可以通过以下地址下载Intellij  Java Google Style：  
https://github.com/google/styleguide/blob/gh-pages/intellij-java-google-style.xml

## 配置 Code Style

导入配置：`Intellij IDEA` => `Preferences` => `Editor` => `Code Style` => `Import Scheme` => `Intellij IDEA code style XML`

<img src="/images/image-20191220115252368.png" alt="image-20191220115252368" style="zoom:50%;" />

## 安装 Save Actions 插件

通过 Save Actions 插件，可以在保存时自动格式化代码。

### 插件下载

根据自己IDEA 版本，在此页面 https://plugins.jetbrains.com/plugin/7642-save-actions/versions 选择合适的版本并下载。

### 插件安装
`Intellij IDEA` => `Preferences` => `Plugins` => `Install plugin from disk...`

<img src="/images/image-20191220114235142.png" alt="image-20191220114235142" style="zoom:50%;" />

### 插件配置

`Intellij IDEA` => `Preferences` => `Other Settings` => `Save Actions`

![intellij-save-actions-plugin-settings-page-java](/images/intellij-save-actions-plugin-settings-page-java.png)

## 代码格式化

* Mac 快捷键：`Command` + `Option` + `L`

## 相关资料

* Google Style Guide 官网：https://github.com/google/styleguide

