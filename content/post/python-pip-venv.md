---
title: "Python pip 和虚拟环境的安装与使用"
date: 2020-12-22T18:03:35+08:00
author: Scott
tags:
  - Python
categories:
  - 技术
---

在开发 Python 项目时经常会依赖第三方的软件包，通常我们会用 `pip` 命令来安装和管理这些包。与此同时，为了避免项目之间的包冲突问题，我们需要用虚拟环境来做项目之间的环境隔离。下面就来介绍 `pip` 命令和虚拟环境的安装与使用。

<!--more-->

**名词解释：**

| 名词                         | 说明                       | 备注              |
| ---------------------------- | -------------------------- | ----------------- |
| pip                          | Python 包安装与管理工具    |                   |
| venv                         | 创建独立 Python 环境的工具 | Python 3          |
| virtualenv                   | 创建独立 Python 环境的工具 | Python 2+         |
| PyPI（Python Package Index） | Python 包索引仓库          | https://pypi.org/ |

### 一、安装或升级 pip 

#### 1.1 Windows 环境下查看 & 升级 pip

Windows 环境下只要安装了Python，一般都自带了 `pip`，可以通过如下命令来查看 `pip` 版本：

```powershell
py -m pip --version
pip 9.0.1 from c:\python36\lib\site-packages (Python 3.6.1)
```

可以通过以下命令来升级 `pip` 版本:

```powershell
py -m pip install --upgrade pip
```

#### 1.2 Linux and macOS 环境下查看 & 升级

Debian 和大多数其他 Linux 发行版都包含 [python pip](https://packages.debian.org/stable/python-pip)。如果不想用系统自带的 pip ，你可以自己安装或升级 `pip` :

```shell
python3 -m pip install --user --upgrade pip
```

通过以下命令来查看 `pip` 版本信息：

```shell
python3 -m pip --version
pip 9.0.1 from $HOME/.local/lib/python3.6/site-packages (python 3.6)
```

### 二、虚拟环境管理

Python 虚拟环境管理一般有两个常用软件，在 Python 3.3 以后的版本中，可以使用 Python 自带的 [venv](https://docs.python.org/3/library/venv.html#module-venv) 模块来创建和管理虚拟环境；但在 Python 3.3 以前的版本中，可以使用 [Virtualenv](https://virtualenv.pypa.io/en/latest/index.html) 来管理虚拟环境。

#### 2.1 安装 virtualenv

Virtualenv 用于管理不同项目的 Python 包。使用 virtualenv 可以让您避免在全球范围内安装 Python 包，这可能会破坏系统工具或其他项目。您可以使用 pip 安装 virtualenv。

**在 macOS 和 Linux 上安装：**

```shell
python3 -m pip install --user virtualenv
```

**在 Windows 上安装：**

```powershell
py -m pip install --user virtualenv
```

#### 2.2 创建虚拟环境

进入项目根目录并运行 `venv` 或 `virtualenv` 来创建虚拟环境 。Python 2 环境将下面的命令中的 `venv` 替换为 `virtualenv` 。

**在 macOS 和 Linux 上创建虚拟环境：**

```shell
python3 -m venv env
```

**在 Windows 上创建虚拟环境：**

```powershell
py -m venv env
```

第二个参数是创建虚拟环境的目录，一般都会命名为 `env`。

> 注意：
>
> - 一般会通过 `.gitignore` 或类似的方法从版本控制系统中排除虚拟环境目录。

#### 2.3 激活虚拟环境

在使用虚拟环境之前需要先激活，激活后通过 pip 命令安装的依赖包都会在此虚拟环境中。

**在 macOS 和 Linux 上激活虚拟环境：**

```shell
source env/bin/activate
```

**在 Windows上激活虚拟环境：**

```powershell
.\env\Scripts\activate
```

可以通过检查 Python 解释器的位置来确认是否在虚拟环境中，解释器应该指向 `env` 目录。

**在 macOS 和 Linux 上检查 Python 解释器的位置:**

```shell
which python
.../env/bin/python
```

**在 Windows上检查 Python 解释器的位置:**

```powershell
where python
.../env/bin/python.exe
```

#### 2.4 退出虚拟环境

切换项目或者离开虚拟环境：

```shell
deactivate
```

如果想重新进入虚拟环境，只需重新激活虚拟环境即可，无需重新创建虚拟环境。

### 三、通过 pip 安装软件包

经过上述操作，我们已经在虚拟环境中了，以安装 [Requests](https://pypi.org/project/requests/) 库为例：

```shell
pip install requests
```

pip 会下载 requests 及其所有依赖项并安装它们：

```shell
Collecting requests
  Using cached requests-2.18.4-py2.py3-none-any.whl
Collecting chardet<3.1.0,>=3.0.2 (from requests)
  Using cached chardet-3.0.4-py2.py3-none-any.whl
Collecting urllib3<1.23,>=1.21.1 (from requests)
  Using cached urllib3-1.22-py2.py3-none-any.whl
Collecting certifi>=2017.4.17 (from requests)
  Using cached certifi-2017.7.27.1-py2.py3-none-any.whl
Collecting idna<2.7,>=2.5 (from requests)
  Using cached idna-2.6-py2.py3-none-any.whl
Installing collected packages: chardet, urllib3, certifi, idna, requests
Successfully installed certifi-2017.7.27.1 chardet-3.0.4 idna-2.6 requests-2.18.4 urllib3-1.22
```

#### 3.1 安装指定的版本

pip 支持指定版本的安装方式。例如：

```shell
pip install requests==2.18.4
```

安装最新的 2.x 版本的请求:

```shell
pip install requests>=2.0.0,<3.0.0
```

要安装预发布版本，使用 `--pre` 标志:

```shell
pip install --pre requests
```

#### 3.2 安装扩展功能

有些包有可选的[附加项](https://setuptools.readthedocs.io/en/latest/setuptools.html#declaring-extras-optional-features-with-their-own-dependencies)，你可以通过在括号中指定扩展的内容来告诉 `pip` 安装这些附加项:

```shell
pip install requests[security]
```

#### 3.3 从源代码安装

pip 可以直接从源代码安装包，例如:

```shell
cd google-auth
pip install .
```

此外，pip 可以在[开发模式](https://setuptools.readthedocs.io/en/latest/setuptools.html#development-mode)下从源代码安装包（源代码目录的更改会立即影响已安装的包，无需重新安装）:

```shell
pip install --editable .
```

#### 3.4 从版本控制系统安装

pip 可以直接从版本控制系统安装软件包，例如，你可以直接从 git 仓库安装:

```shell
git+https://github.com/GoogleCloudPlatform/google-auth-library-python.git#egg=google-auth
```

已支持的版本控制系统和语法信息请查看：[VCS 支持](https://pip.pypa.io/en/latest/reference/pip_install/#vcs-support)。

#### 3.5 从本地归档文件安装

如果你有一个本地的[分发包](https://packaging.python.org/glossary/#term-Distribution-Package)的归档文件(zip、 wheel 或 tar 文件) ，你可以用 `pip` 直接安装它:

```shell
pip install requests-2.18.4.tar.gz
```

如果你在一个文件目录下有多个归档文件包，可以给 `pip` 指定找包的路径，`pip` 将不会去 [Python Package Index (PyPI)](https://packaging.python.org/glossary/#term-Python-Package-Index-PyPI) 下载，例如：

```shell
pip install --no-index --find-links=/local/dir/ requests
```

#### 3.6 使用其他包索引

如果你不想从  [Python Package Index (PyPI)](https://packaging.python.org/glossary/#term-Python-Package-Index-PyPI) 索引下载包，可以通过 `--Index-url` 来指定索引：

```shell
pip install --index-url http://index.example.com/simple/ SomeProject
```

如果你想扩展 [Python Package Index (PyPI)](https://packaging.python.org/glossary/#term-Python-Package-Index-PyPI) ，可以用 `--extra-Index-url` 来指定扩展索引：

```shell
pip install --extra-index-url http://index.example.com/simple/ SomeProject
```

#### 3.7 升级软件包

`pip` 可以用 `--upgrade` 参数来升级包。例如安装 requests 的最新版本及其所有依赖项：

```shell
pip install --upgrade requests
```

#### 3.8 使用 requirements 文件

pip 支持在 [Requirements File](https://pip.pypa.io/en/latest/user_guide/#requirements-files) 中声明所有依赖项。例如可以创建一个 `requirements.txt` 文件，其中包含：

```shell
requests==2.18.4
google-auth==1.1.0
```

`pip` 可以用 `-r` 参数来指定 requirements 文件：

```shell
pip install -r requirements.txt
```

#### 3.9 冻结依赖关系

`pip` 可以用 `freeze` 命令导出所有已安装的软件包及其版本的列表:

```shell
pip freeze > requirements.txt
```

它将所有以来的包和版本信息导出到 `requirements.txt` 文件中：

```shell
cachetools==2.0.1
certifi==2017.7.27.1
chardet==3.0.4
google-auth==1.1.1
idna==2.6
pyasn1==0.3.6
pyasn1-modules==0.1.4
requests==2.18.4
rsa==3.4.2
six==1.11.0
urllib3==1.22
```

这个文件对重建环境并准确安装所有包非常有用。

### 相关链接

- [Virtualenv：https://virtualenv.pypa.io/en/latest/](https://virtualenv.pypa.io/en/latest/)
- [安装和使用pip、虚拟环境](https://packaging.python.org/guides/installing-using-pip-and-virtual-environments/#creating-a-virtual-environment)
- [virtualenvwrapper：https://virtualenvwrapper.readthedocs.io/en/latest/ ](https://virtualenvwrapper.readthedocs.io/en/latest/)