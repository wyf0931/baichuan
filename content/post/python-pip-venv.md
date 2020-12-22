---
title: "使用 pip 和虚拟环境来安装Package"
date: 2020-12-22T18:03:35+08:00
author: Scott
tags:
  - Python
categories:
  - 技术
---


本指南讨论如何使用 pip 和虚拟环境管理器安装Package : [venv](https://packaging.python.org/key_projects/#venv) for python3 或 [virtualenv](https://packaging.python.org/key_projects/#virtualenv) for python2。这些是用于管理 Python Package的最低级别的工具，如果较高级别的工具不适合您的需要，则建议使用这些工具。

<!--more-->

注意：这个文档使用术语 Package 来指代一个[分发包](https://packaging.python.org/glossary/#term-Distribution-Package)，它不同于用于导入 Python 源代码中的模块的 [Import Package](https://packaging.python.org/glossary/#term-Import-Package)。

## 安装 pip

[pip](https://packaging.python.org/key_projects/#pip) 是引用的 Python Package 管理器。它用于安装和更新软件包。您需要确保安装了最新版本的 pip。

### Windows

Windows 的 Python 安装程序包括 pip。您应该能够使用以下命令访问 pip:

```powershell
py -m pip --version
pip 9.0.1 from c:\python36\lib\site-packages (Python 3.6.1)
```

通过运行以下命令，可以确保 pip 是最新的:

```powershell
py -m pip install --upgrade pip
```

### Linux and macOS

Debian 和大多数其他发行版包含 [python-pip](https://packages.debian.org/stable/python-pip) Package ，如果您想使用 Linux 发行版提供的 pip 版本，请参见[使用 Linux 包管理器安装 pip/setuptools/wheel](https://packaging.python.org/guides/installing-using-linux-tools/)。

您还可以自己安装 pip，以确保拥有最新版本。建议使用系统 pip 引导用户安装 pip:

```shell
python3 -m pip install --user --upgrade pip
```

然后，你应该在你的用户站点安装最新的 pip:

```shell
python3 -m pip --version
pip 9.0.1 from $HOME/.local/lib/python3.6/site-packages (python 3.6)
```

### 安装 virtualenv

> 注意：如果您使用的是 Python 3.3或更新版本，[venv](https://docs.python.org/3/library/venv.html#module-venv) 模块是创建和管理虚拟环境的首选方法。Venv 包含在 Python 标准库中，不需要额外的安装。如果你使用 venv，你可以跳过这一部分。

Virtualenv 用于管理不同项目的 Python 包。使用 virtualenv 可以让您避免在全球范围内安装 Python 包，这可能会破坏系统工具或其他项目。您可以使用 pip 安装 virtualenv。

在 macOS 和 Linux 上:

```shell
python3 -m pip install --user virtualenv
```

在 Windows上:

```powershell
py -m pip install --user virtualenv
```

## 创建虚拟环境

[venv](https://packaging.python.org/key_projects/#venv) (用于 Python 3)和 [virtualenv](https://packaging.python.org/key_projects/#virtualenv) (用于 Python 2)允许您为不同的项目管理单独的包安装。它们实际上允许您创建一个“虚拟”独立的 Python 安装，并将包安装到该虚拟安装中。当您切换项目时，您可以简单地创建一个新的虚拟环境，而不必担心破坏安装在其他环境中的包。总是建议在开发 Python 应用程序时使用虚拟环境。

要创建虚拟环境，请转到项目的目录并运行 `venv`。如果您使用的是 Python 2，请在下面的命令中使用 `virtualenv` 替换 `venv`。

在 macOS 和 Linux 上:

```shell
python3 -m venv env
```

在 Windows上:

```powershell
py -m venv env
```

第二个参数是创建虚拟环境的位置。一般来说，您可以在项目中创建它并将其命名为 `env`。

venv 将在 env 文件夹中创建一个虚拟 Python 安装。

> 注意：您应该使用 `.gidignore` 或类似的方法从版本控制系统中排除虚拟环境目录。

## 激活虚拟环境

在开始在虚拟环境中安装或使用软件包之前，您需要激活它。激活虚拟环境将把特定于虚拟环境的 `python` 和 `pip` 可执行文件放入 shell 的 `PATH` 中。

在 macOS 和 Linux 上:

```shell
source env/bin/activate
```

在 Windows上:
```powershell
.\env\Scripts\activate
```

您可以通过检查 Python 解释器的位置来确认您在虚拟环境中，它应该指向 `env` 目录。

在 macOS 和 Linux 上:

```shell
which python
.../env/bin/python
```

在 Windows上:

```powershell
where python
.../env/bin/python.exe
```

只要您的虚拟环境被激活，pip 就会将包安装到特定的环境中，您就能够在 Python 应用程序中导入和使用包。

## 退出虚拟环境

如果你想切换项目或者离开你的虚拟环境，只需运行:

```shell
deactivate
```

如果您想重新进入虚拟环境，只需按照上面关于激活虚拟环境的相同说明进行操作。没有必要重新创建虚拟环境。

## 安装软件包

现在您已经在虚拟环境中了，您可以安装包了。让我们从 [Python Package Index (PyPI)](https://packaging.python.org/glossary/#term-Python-Package-Index-PyPI) 中安装 [Requests](https://pypi.org/project/requests/) 库:

```shell
pip install requests
```

pip 应该下载请求及其所有依赖项并安装它们:

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

## 安装特定的版本

pip 允许使用版本说明符指定要安装的包的版本。例如，安装一个特定版本的请求:

```shell
pip install requests==2.18.4
```

安装最新的2.x 版本的请求:

```shell
pip install requests>=2.0.0,<3.0.0
```

要安装软件包的预发布版本，使用 `--pre` 标志:

```shell
pip install --pre requests
```

## 安装额外功能

有些软件包有可选的[附加项](https://setuptools.readthedocs.io/en/latest/setuptools.html#declaring-extras-optional-features-with-their-own-dependencies)，你可以通过在括号中指定额外的内容来告诉 pip 安装这些附加项:

```shell
pip install requests[security]
```

## 从源代码安装

Pip 可以直接从源代码安装包，例如:

```shell
cd google-auth
pip install .
```

此外，pip 可以在[开发模式](https://setuptools.readthedocs.io/en/latest/setuptools.html#development-mode)下从源代码安装包，这意味着对源代码目录的更改会立即影响已安装的包，而无需重新安装:

```shell
pip install --editable .
```

## 从版本控制系统安装

pip 可以直接从版本控制系统安装软件包，例如，你可以直接从 git 仓库安装:

```shell
git+https://github.com/GoogleCloudPlatform/google-auth-library-python.git#egg=google-auth
```

有关支持的版本控制系统和语法的更多信息，请参见关于 [VCS 支持](https://pip.pypa.io/en/latest/reference/pip_install/#vcs-support)的 pip 文档。

## 从当地归档文件安装

如果你有一个本地的[分发包](https://packaging.python.org/glossary/#term-Distribution-Package)的归档文件(zip、 wheel 或 tar 文件) ，你可以用 pip 直接安装它:

```shell
pip install requests-2.18.4.tar.gz
```

如果您有一个包含多个包的归档文件的目录，您可以告诉 pip 在那里寻找包，而根本不要使用 [Python Package Index (PyPI)](https://packaging.python.org/glossary/#term-Python-Package-Index-PyPI):

```shell
pip install --no-index --find-links=/local/dir/ requests
```

如果您要在连接性有限的系统上安装软件包，或者如果您想严格控制分发包的起源，那么这是非常有用的。

## 使用其他包索引

如果您希望从不同于 [Python Package Index (PyPI)](https://packaging.python.org/glossary/#term-Python-Package-Index-PyPI) 的索引下载包，可以使用 `--Index-url` 标志:

```shell
pip install --index-url http://index.example.com/simple/ SomeProject
```

如果希望同时允许来自 [Python Package Index (PyPI)](https://packaging.python.org/glossary/#term-Python-Package-Index-PyPI) 和单独索引的包，可以使用 `--extra-Index-url` 标志代替:

```shell
pip install --extra-index-url http://index.example.com/simple/ SomeProject
```

## 升级软件包

pip 可以使用 `--upgrade` 标志就地升级包。例如，要安装请求的最新版本及其所有依赖项:

```shell
pip install --upgrade requests
```

## 使用 requirements 文件

pip 允许您在 [Requirements File](https://pip.pypa.io/en/latest/user_guide/#requirements-files) 中声明所有依赖项，而不是单独安装包。例如，你可以创建一个 `requirements.txt` 文件，其中包含:

```shell
requests==2.18.4
google-auth==1.1.0
```

并告诉 pip 使用 `-r` 标志安装该文件中的所有软件包:

```shell
pip install -r requirements.txt
```

## 冻结依赖关系

pip 可以使用 `freeze` 命令导出所有已安装的软件包及其版本的列表:

```shell
pip freeze
```

它将输出一个包说明符列表，如:

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

这对于创建能够重新创建环境中安装的所有包的精确版本的 [Requirements Files](https://pip.pypa.io/en/latest/user_guide/#requirements-files) 非常有用。



原文地址：https://packaging.python.org/guides/installing-using-pip-and-virtual-environments/#creating-a-virtual-environment