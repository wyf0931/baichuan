---
author: Itamar Turner-Trauring
title: "深入了解 Python 官方 Docker 镜像"
date: 2020-08-30T16:51:44+08:00
tags:
  - Python
  - Docker
categories:
  - 技术
draft: false
---

Docker 的官方 Python 镜像非常流行，实际上我推荐其中一个变体作为基础镜像。但是许多人并不完全理解它的作用，这可能导致困惑。

因此，在这篇文章中，我将介绍它是如何构建的，为什么它是有用的，如何正确使用它，以及它的局限性。特别是，我将通读 `python: 3.8-slim-buster` 变体，截止到 2020年8月19日，并在我继续研究的时候解释它。

## 阅读 Dockerfile

### 基础镜像

我们从基础镜像开始：

``` dockerfile
FROM debian:buster-slim
```

也就是说，基础镜像是 Debian 10，目前稳定发布的 Debian 发行版，也被称为巴斯特（Buster），因为 Debian 的所有发行版会以玩具总动员中的人物命名。比如巴斯特（Buster）是安迪（Andy）的宠物狗。

因此，首先，这是一个 Linux 发行版，保证随着时间的推移稳定性，同时提供错误修复。slim 变体安装的软件包较少，因此没有编译器。

### 环境变量

接下来是一些环境变量，第一个确保 `/usr/local/bin` 在 `$PATH` 的前面:

```dockerfile
# 确保本地 python 优先于分发 python
ENV PATH /usr/local/bin:$PATH
```

通常 Python 镜像会将 Python 安装在 `/usr/local` 中。

接下来，设置语言环境:

```dockerfile
# http://bugs.python.org/issue19846
# > 目前，在 Linux 系统上设置 “LANG = c” 从根本上破坏了 Python 3，这是不对的。
ENV LANG C.UTF-8
```

据我所知，即使没有这个配置，Python 3 也会默认使用 `UTF-8`，所以我觉得没必要再配置。

还有一个指定 Python 版本的环境变量:
```dockerfile
ENV PYTHON_VERSION 3.8.5
```
还有一个带有 GPG 密钥的环境变量，用于在 Python 源代码下载时进行验证。

### 运行时依赖

为了运行，Python 需要一些额外的软件包:

```dockerfile
RUN apt-get update && apt-get install -y --no-install-recommends \
		ca-certificates \
		netbase \
	&& rm -rf /var/lib/apt/lists/*
```

第一个 ca-certificates 是标准证书认证机构的证书列表，与您的浏览器用于验证 https://url 的内容类似。这允许 Python、 wget 和其他工具验证服务器提供的证书。

第二个 netbase 在 `/etc` 中安装一些文件，这些文件需要将某些名称映射到相应的端口或协议。例如：`/etc/services` 将服务名称(比如 https)映射到相应的端口号(在本例中为：443/tcp)。

### 安装 Python

下一步，安装一个编译器工具链，下载 Python 源代码，编译 Python，然后卸载不需要的 Debian 包:

```dockerfile
RUN set -ex \
	\
	&& savedAptMark="$(apt-mark showmanual)" \
	&& apt-get update && apt-get install -y --no-install-recommends \
		dpkg-dev \
		gcc \
		libbluetooth-dev \
		libbz2-dev \
		libc6-dev \
		libexpat1-dev \
		libffi-dev \
		libgdbm-dev \
		liblzma-dev \
		libncursesw5-dev \
		libreadline-dev \
		libsqlite3-dev \
		libssl-dev \
		make \
		tk-dev \
		uuid-dev \
		wget \
		xz-utils \
		zlib1g-dev \
# as of Stretch, "gpg" is no longer included by default
		$(command -v gpg > /dev/null || echo 'gnupg dirmngr') \
	\
	&& wget -O python.tar.xz "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz" \
	&& wget -O python.tar.xz.asc "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz.asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "$GPG_KEY" \
	&& gpg --batch --verify python.tar.xz.asc python.tar.xz \
	&& { command -v gpgconf > /dev/null && gpgconf --kill all || :; } \
	&& rm -rf "$GNUPGHOME" python.tar.xz.asc \
	&& mkdir -p /usr/src/python \
	&& tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz \
	&& rm python.tar.xz \
	\
	&& cd /usr/src/python \
	&& gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
	&& ./configure \
		--build="$gnuArch" \
		--enable-loadable-sqlite-extensions \
		--enable-optimizations \
		--enable-option-checking=fatal \
		--enable-shared \
		--with-system-expat \
		--with-system-ffi \
		--without-ensurepip \
	&& make -j "$(nproc)" \
		LDFLAGS="-Wl,--strip-all" \
	&& make install \
	&& rm -rf /usr/src/python \
	\
	&& find /usr/local -depth \
		\( \
			\( -type d -a \( -name test -o -name tests -o -name idle_test \) \) \
			-o \( -type f -a \( -name '*.pyc' -o -name '*.pyo' -o -name '*.a' \) \) \
			-o \( -type f -a -name 'wininst-*.exe' \) \
		\) -exec rm -rf '{}' + \
	\
	&& ldconfig \
	\
	&& apt-mark auto '.*' > /dev/null \
	&& apt-mark manual $savedAptMark \
	&& find /usr/local -type f -executable -not \( -name '*tkinter*' \) -exec ldd '{}' ';' \
		| awk '/=>/ { print $(NF-1) }' \
		| sort -u \
		| xargs -r dpkg-query --search \
		| cut -d: -f1 \
		| sort -u \
		| xargs -r apt-mark manual \
	&& apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
	&& rm -rf /var/lib/apt/lists/* \
	\
	&& python3 --version
```

内容有很多，但基本的结果是:

1. Python 安装到 `/usr/local`；
2. 删除所有 `.pyc` 文件；
3. 删除 `gcc` 等编译时使用的包；

因为这一切都发生在一个 RUN 命令中，所以镜像不会将编译器存储在任何层中，从而使其更小。

您可能会注意到的一件事是 Python 需要 `libbluetooth-dev` 来编译。我发现了这个令人惊讶的地方，所以我问了，显然 Python 可以创建蓝牙套接字（Socket），但是只有在安装了这个包的情况下才能编译。

### 设置别名

接下来，给 `/usr/local/bin/python3` 配置一个别名 `/usr/local/bin/python`，如下所示：

```dockerfile
# 创建python相关符号链接
RUN cd /usr/local/bin \
	&& ln -s idle3 idle \
	&& ln -s pydoc3 pydoc \
	&& ln -s python3 python \
	&& ln -s python3-config python-config
```

### 安装pip

pip 包下载工具有自己的发布时间表，与 Python 的不同。例如，这个 Dockerfile 正在安装 Python 3.8.5，发布于2020年7月。pip 20.2.2在8月份发布，但 Dockerfile 确保包含新的 pip:

```dockerfile
# 如果这里写为 "PIP_VERSION"，pip 会抛出 "ValueError: invalid truth value '<VERSION>'" 异常
ENV PYTHON_PIP_VERSION 20.2.2
# https://github.com/pypa/get-pip
ENV PYTHON_GET_PIP_URL https://github.com/pypa/get-pip/raw/5578af97f8b2b466f4cdbebe18a3ba2d48ad1434/get-pip.py
ENV PYTHON_GET_PIP_SHA256 d4d62a0850fe0c2e6325b2cc20d818c580563de5a2038f917e3cb0e25280b4d1

RUN set -ex; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	apt-get update; \
	apt-get install -y --no-install-recommends wget; \
	\
	wget -O get-pip.py "$PYTHON_GET_PIP_URL"; \
	echo "$PYTHON_GET_PIP_SHA256 *get-pip.py" | sha256sum --check --strict -; \
	\
	apt-mark auto '.*' > /dev/null; \
	[ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*; \
	\
	python get-pip.py \
		--disable-pip-version-check \
		--no-cache-dir \
		"pip==$PYTHON_PIP_VERSION" \
	; \
	pip --version; \
	\
	find /usr/local -depth \
		\( \
			\( -type d -a \( -name test -o -name tests -o -name idle_test \) \) \
			-o \
			\( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
		\) -exec rm -rf '{}' +; \
	rm -f get-pip.py
```

同样，会删除所有 `.pyc` 文件。

### 入口点（entrypoint）

最后，Dockerfile 指定了入口点:

```dockerfile
CMD ["python3"]
```

运行镜像时默认情况下会执行 python 命令：

```bash
$ docker run -it python:3.8-slim-buster
Python 3.8.5 (default, Aug  4 2020, 16:24:08)
[GCC 8.3.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> 
```

但是，你也可以执行其他命令（以 `bash` 为例）：

```bash
$ docker run -it python:3.8-slim-buster bash
root@280c9b73e8f9:/# 
```

## 我们学到了什么？

我们再次聚焦到 slim-buster 变种上。

### Python 官方镜像包含 Python

虽然这一点似乎显而易见，但值得注意的是它是如何包含的：它是在 `/usr/local` 中自定义安装的。

使用这个基础镜像的人常犯的一个错误是使用 Debian 版本的 Python 再次安装 Python：

```dockerfile
FROM python:3.8-slim-buster

# 这是没有必要的：
RUN apt-get update && apt-get install python3-dev
```

这将在 `/usr` 中安装一个多余的 Python（镜像中自带的安装在 `/usr/local`） 。一般情况下安装的版本与镜像中已有的版本不一样，你肯定不希望在同一个镜像中使用两个不同版本的 Python吧？

如果你真的想使用 Debian 版本的 Python，那么可以使用 Debian: buster-slim 作为基础镜像。

### Python 官方镜像包含最新的 pip

例如，Python 3.5 的最后一次发布是在2019年11月，但 Python 的 Docker 镜像: 3.5-slim-buster 包含了2020年8月的 pip。这（通常）是一件好事，它意味着您得到了最新的错误修复、性能改进以及对更新的轮子变种的支持。

### Python 官方镜像删除所有 `.pyc` 文件

如果您想稍微加快启动速度，您可能希望将标准库源代码编译为。使用 `compileall` 模块在您自己的镜像中进行 .pyc。

### Python 官方镜像没有安装 Debian 安全更新

尽管经常会重新生成基本 Debian: buster-slim 和 python 镜像，但是有些窗口已经发布了新的 Debian 安全修复，但是镜像还没有重新生成。您应该安装基本 Linux 发行版的安全更新。

了解如何构建快速的、可投入生产的 Docker 镜像——阅读其余的针对 [Python 的 Docker 打包指南](https://pythonspeed.com/docker/)。