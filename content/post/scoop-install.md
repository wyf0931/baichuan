---
title: Scoop 安装指南
author: Scott
date: 2019-07-02 14:41:32
draft: false
tags:
  - 工具
categories:
  - 技术
---
Scoop 是 Windows 系统下的一个开源的包管理器，类似于Mac 上的 brew。
<!--more-->

官网地址：[https://github.com/lukesampson/scoop](https://github.com/lukesampson/scoop)

### 环境准备

* Windows 7 SP1+ / Windows Server 2008+

* [PowerShell 5](https://aka.ms/wmf5download) (或以上, 包含 [PowerShell Core](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-windows?view=powershell-6)) 并且 [.NET Framework 4.5](https://www.microsoft.com/net/download) (或以上)
* 用户账号必须启用 PowerShell，例如：`Set-ExecutionPolicy-ExecutionPolicy remoteseable-Scope CurrentUser`

### 安装步骤

在 PowerShell 中执行以下命令，将 `scoop` 安装到默认位置（`C:\Users\<user>\scoop` ）：

```powershell
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')

# or shorter
iwr -useb get.scoop.sh | iex
```

一旦安装完毕，运行 `scoop help` 获取指令帮助信息。

默认配置如下： 

* 所有用户安装的程序和 Scoop 本身都在 `C:\Users\<user>\scoop` 中；
* 全局安装的程序（`--global`）使用 `C:\ProgramData\scoop`；

可以通过环境变量更改上述配置：

#### 将 `SCOOP` 安装到自定义目录

```powershell
$env:SCOOP='D:\Applications\Scoop'
[Environment]::SetEnvironmentVariable('SCOOP', $env:SCOOP, 'User')
# 然后执行安装命令
```

#### 将 `SCOOP` 全局程序安装到自定义目录

```powershell
$env:SCOOP_GLOBAL='F:\GlobalScoopApps'
[Environment]::SetEnvironmentVariable('SCOOP_GLOBAL', $env:SCOOP_GLOBAL, 'Machine')
# 然后执行安装命令
```

