---
title: "Docker 安装与卸载指南 - Mac版"
date: 2021-01-17T17:07:23+08:00
draft: false
tags:
  - Python
  - Docker
categories:
  - 技术
---
Docker Desktop for Mac 是 Docker 的 Mac 社区版。
<!-- more -->

下载地址：[https://hub.docker.com/editions/community/docker-ce-desktop-mac](https://hub.docker.com/editions/community/docker-ce-desktop-mac)

## 一、安装 Docker Desktop

### 1.1 安装说明

**Docker Desktop for Mac 与 Docker Machine 的关系：**

在 Mac 上安装 Docker Desktop 不会影响你之前用 Docker Machine 创建的机器。你可以将容器（container）和镜像（image）从本地默认计算机（如果存在）复制到 Docker Desktop [HyperKit](https://github.com/docker/HyperKit/) VM。在运行 Docker Desktop 时，不需要在本地运行 Docker Machine 节点。使用 Docker Desktop，你将有一个新的、本地运行的虚拟化系统（HyperKit），将取代 VirtualBox 系统。

### 1.2 系统要求

你的 Mac 必须满足以下要求才能成功安装 Docker Desktop：

- **Mac 硬件必须是2010年或更新的型号且是英特尔（Intel）处理器版。** 

  > - 英特尔的硬件支持内存管理单元（MMU, memory management unit）虚拟化，包括扩展页面表(EPT, Extended Page Tables )和无限制模式。
  > 
  > - 可以在命令行终端中运行以下命令来检查你的机器是否支持: `sysctl kern.hv_support`。如果输出：`kern.hv_support: 1` 则表示该 Mac 支持 Hypervisor 框架。

- **macOS 必须是10.14或更新版本。** 也就是：Mojave、Catalina 或 Big Sur。推荐升级到最新版本。

- 至少 4GB 内存（RAM）。

- 不能安装 4.3.30 之前版本的 VirtualBox，它与 Docker Desktop 不兼容。

### 1.3 安装器（Installer）中包含的内容

Docker Desktop Installer 中包含的内容如下：

- [Docker Engine](https://docs.docker.com/engine/)
- Docker CLI 客户端
- [Docker Compose](https://docs.docker.com/compose/)
- [Notary](https://docs.docker.com/notary/getting_started/)
- [Kubernetes](https://github.com/kubernetes/kubernetes/)
- [Credential Helper](https://github.com/docker/docker-credential-helpers/)

### 1.4 安装并运行 Docker Desktop

1. 双击 `Docker.dmg` 打开安装程序，然后将 Docker 图标拖到 Applications 文件夹。

![Install Docker app](https://blog-1252438081.cos.ap-shanghai.myqcloud.com/img/docker-app-drag.png)

2. 双击 Applications 文件夹中的 `Docker.app` 启动 Docker。(在下图中，Applications 文件夹处于“ grid”视图模式。)

![Docker app in Hockeyapp](https://blog-1252438081.cos.ap-shanghai.myqcloud.com/img/docker-app-in-apps.png)

顶部状态栏中的 Docker 菜单表明 Docker Desktop 正在运行，并且可以从终端访问。

![Whale in menu bar](https://blog-1252438081.cos.ap-shanghai.myqcloud.com/img/whale-in-menu-bar.png)

如果你刚刚安装了这个应用程序，Docker Desktop 就会开启入门教程。本教程包括一个简单的练习，构建一个示例 Docker 镜像，将其作为一个容器运行，将镜像推送并保存到 Docker Hub。

![Docker Quick Start tutorial](https://blog-1252438081.cos.ap-shanghai.myqcloud.com/img/docker-tutorial-mac.png)

3. 单击 Docker 菜单(![whale menu](https://blog-1252438081.cos.ap-shanghai.myqcloud.com/img/whale-x.png))查看 **Preferences** 和其他选项。
4. 选择“关于 Docker（About Docker）”验证是否最新版本。

恭喜你！ 现在已经成功地运行了 Docker Desktop。

如果您想再学一次教程，可以在 Docker Desktop 菜单点击 **Learn**。

## 二、自动更新

从 Docker Desktop 3.0.0开始，Docker Desktop 的更新将作为以前版本的 delta 更新自动提供。

当有新的更新时，Docker Desktop 会自动将其下载到你的机器上，并显示一个图标来指示新版本的可用性。现在需要做的就是在 Docker 菜单栏单击 **Update and restart** 。这将安装最新更新并重新启动 Docker Desktop 使更新生效。

## 三、卸载 Docker Desktop

将 Docker Desktop 从你的 Mac 上卸载：

1. 从Docker 菜单中选择 `Troubleshoot` 然后选择 `Uninstall`；
2. 点击 `Uninstall` 进行二次确认；

> 注意：  
> 
> 卸载 Docker Desktop 将破坏本地的 Docker 容器（container）和镜像（image），并删除应用程序生成的文件。

## 四、保存和恢复数据

可以使用以下操作来保存和还原镜像和容器数据。例如重置 VM 磁盘：

1. 用 `docker save -o images.tar image1 [image2 ...]` 来保存你想保留的任何图像，请参阅 Docker Engine 命令行引用中的 [保存（save）](https://docs.docker.com/engine/reference/commandline/save)。
2. 用 `docker export -o myContainner1.tar container1` 来导出你想保存的容器（container），请参阅 Docker Engine 命令行参考中的 [导出（export）](https://docs.docker.com/engine/reference/commandline/export)。
3. 卸载当前版本的 Docker Desktop，并安装一个不同的版本（Stable 或 Edge） ，或重置您的 VM 磁盘。
4. 用 `docker load -i images.tar` 重新加载以前保存的镜像。
5. 用 `docker import -i myContainer1.tar` 创建与之前导出的容器对应的文件系统镜像。请参见 Docker Engine 的 [导入（import）](https://docs.docker.com/engine/reference/commandline/import)。

有关如何备份和还原数据卷的信息，请参阅[备份、还原、迁移数据](https://docs.docker.com/storage/volumes/#backup-restore-or-migrate-data-volumes)。