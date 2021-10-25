---
title: Groovy下载与安装
author: Scott
tags:
  - Groovy
categories:
  - Groovy
  - 技术
date: 2019-06-28 17:13:00
---


获取 Apache Groovy 的方法有很多种，比如：下载二进制包、从Github仓库获取，或者从Docker中获取。

<!--more-->



## 一、下载

### 1.1 获取 Apache Groovy 的方法

- 下载源码或者二进制分发包：https://groovy.apache.org/download.html#distro；
- 通过操作系统自带的包管理器来安装：https://groovy.apache.org/download.html#osinstall；
- 从构建工具中引用 Apache Groovy jar 包：https://groovy.apache.org/download.html#buildtools；
- 在 IDE 的插件中安装：http://groovy-lang.org/ides.html；
- 在[Git仓库](https://git-wip-us.apache.org/repos/asf/groovy.git)（或者[GitHub镜像](https://github.com/apache/groovy)）中获取最新代码；
- 从 [Docker Hub](https://hub.docker.com/_/groovy/) 中获取Docker 镜像并使用；



### 1.2 版本说明

#### 1.2.1 Groovy 4.0

Groovy 4.0 是为 JDK8+ 设计的下一个Groovy [主版本](https://groovy.apache.org/versioning.html)，对 JPMS 的支持有了很大改进。

[4.0.0-beta-1 发行版](http://groovy-lang.org/changelogs/changelog-4.0.0-beta-1.html)：

- 二进制分发包：https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-binary-4.0.0-beta-1.zip
- 源码包：https://www.apache.org/dyn/closer.cgi/groovy/4.0.0-beta-1/sources/apache-groovy-src-4.0.0-beta-1.zip
- 文档包：https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-docs-4.0.0-beta-1.zip
- SDK包：https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-4.0.0-beta-1.zip
- Windows安装包：https://groovy.jfrog.io/artifactory/dist-release-local/groovy-windows-installer/groovy-4.0.0-beta-1/



#### 1.2.2 Groovy 3.0

Groovy 3.0 是 Groovy 的最新稳定[版本](https://groovy.apache.org/versioning.html)，专为 JDK8+ 设计，带有新的更灵活的解析器（又名 Parrot 解析器）。

[3.0.9 发行版](http://groovy-lang.org/changelogs/changelog-3.0.9.html)：

- [二进制分发包](https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-binary-3.0.9.zip)
- [源码](https://www.apache.org/dyn/closer.cgi/groovy/3.0.9/sources/apache-groovy-src-3.0.9.zip)
- [文档](https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-docs-3.0.9.zip)
- [SDK](https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-3.0.9.zip)
- [Windows安装包](https://groovy.jfrog.io/artifactory/dist-release-local/groovy-windows-installer/groovy-3.0.9/)



#### 1.2.3 Groovy 2.4

Groovy 2.4 是仍在广泛使用的 Groovy 的早期版本。

重要提示：**2.4.4 之前的版本不是在 Apache 软件基金会下完成的，只是为了方便而提供，没有任何保证。**

[2.4.21](http://groovy-lang.org/changelogs/changelog-2.4.21.html)：

- 二进制分发包：https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-binary-2.4.21.zip
- 源码：https://www.apache.org/dyn/closer.cgi/groovy/2.4.21/sources/apache-groovy-src-2.4.21.zip
- 文档：https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-docs-2.4.21.zip
- SDK：https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-2.4.21.zip
- Windows安装包：https://groovy.jfrog.io/artifactory/dist-release-local/groovy-windows-installer/groovy-2.4.21/

#### 1.2.4 历史版本

所有历史版本都可以通过以下方式下载（[所有版本](http://groovy-lang.org/changelogs.html)的变更日志）：

- Apache 的[发布镜像](http://www.apache.org/dyn/closer.cgi/groovy/)和[归档存储库](https://archive.apache.org/dist/groovy/)；
- Groovy 的[工件实例](https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/)（包括 ASF 之前的版本）；

#### 1.2.5 调用动态支持

如果您想启用 indy 支持并在 JDK 7+ 上使用 Groovy，可以参考：[调用动态支持信息](http://groovy-lang.org/indy.html)。



## 二、系统要求

| Groovy 版本 | JVM版本（非 indy） | JVM版本（indy） |
| ----------- | ------------------ | --------------- |
| 4.0+        | 不支持             | 1.8+            |
| 3.x         | 1.8+               | 1.8+            |
| 2.5～2.6    | 1.7+               | 1.7+            |
| 2.3～2.4    | 1.6+               | 1.7+            |
| 2.0～2.2    | 1.5+               | 1.7+            |
| 1.6～1.8    | 1.5+               | 不支持          |
| 1.5         | 1.4+               | 不支持          |
| 1.0         | 1.4～1.7           | 不支持          |

## 三、安装指南

### 2.1 通过操作系统包管理器安装

#### 2.1.1 Mac用户

[Homebrew](http://brew.sh/)：

```bash
brew install groovy
```

[MacPorts](http://www.macports.org/)：

```bash
sudo port install groovy
```

#### 2.1.2 Windows用户

[Scoop](http://scoop.sh/)：

```bash
scoop install groovy
```

[Chocolatey](https://chocolatey.org/)：

````bash
choco install groovy
````

备注：也可以在Windows 安装器中安装。

#### 2.1.3 Linux用户

[SDKMAN](http://sdkman.io/)：

```
sdk install groovy
```

备注：

也可以在 apt、dpkg、pacman 等渠道下载和安装；



### 2.2 通过构建工具安装

#### 2.2.1 Groovy 1.x ～ 3.x

| Gradle                                     | Maven                                                        | 说明                                                         |
| ------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| `org.codehaus.groovy:groovy:x.y.z`         | `<groupId>org.codehaus.groovy</groupId>`<br /> `<artifactId>groovy</artifactId>` <br />`<version>x.y.z</version>` | 只是 Groovy 的核心，没有模块。还包括 jar版本的 Antlr、ASM 和所需 CLI 实现类的内部副本。 |
| `org.codehaus.groovy:groovy-$module:x.y.z` | `<groupId>org.codehaus.groovy</groupId>` <br />`<artifactId>groovy-$module</artifactId>` <br />`<version>x.y.z</version>` | `"$module"` 代表不同的可选 groovy 模块。例如：`<artifactId>groovy-sql</artifactId>`。 |
| `org.codehaus.groovy:groovy-all:x.y.z`     | `<groupId>org.codehaus.groovy</groupId>`<br /> `<artifactId>groovy-all</artifactId>` <br />`<version>x.y.z</version>` <br />`<type>pom</type>` <br /><!-- required JUST since Groovy 2.5.0 --> | 核心加上所有模块（不包括可选模块）按照版本打包方案。         |

#### 2.2.2 Groovy 4.0+

和1.x～3.x 版本的引用方式类似，只是需要将`org.codehaus.groovy` 替换为 `org.apache.groovy` 。

> 模块：
>
> - *2.4.X:* ant、bsf、console、docgenerator、groovydoc、groovysh、jmx、json、jsr223、nio、servlet、sql、swing、test、templates、testng、xml；
>
> - *2.5.0:* 和上述相同，但不包括可选模块：bsf、cli-picocli、datetime、macro、test-junit5，可选模块：bsf、dateutil、cli-commons
>
> - *2.5.1+:* 和上述相同，只是将 groovy-jaxb 改为可选包；
> - *3.0.0+:* 和上述相同，只是将 groovy-yaml 改为可选包；
> - *4.0.0+:* 和上述相同，但将 groovy-contracts、groovy-typecheckers、groovy-macro-library 作为了新的可选模块，groovy-jaxb、groovy-bsf 不再长期支持；groovy-yaml 加入了 groovy-all；groovy-testng 也作为一个可选模块。
>
> 打包方案：
>
> *2.4.X：*核心加上所有模块合并为一个“fat jar”。可选的依赖被标记为可选的，所以你可能需要包含一些可选的依赖来使用 Groovy 的一些特性，例如 AntBuilder、GroovyMBeans...
> *2.5+：*一个“fat pom” `groovy-all-x.y.z.pom`指的是核心加上所有模块（不包括可选的）那些）。为了迎合Java 9+的模块系统，该`groovy-all-x.y.z.jar`文件被废弃。

您可以使用“indy”分类器访问核心或模块 jar 的 indy 版本。

#### 2.2.3 Maven 存储库

| Groovy 版本 | 存储仓库                                                     |
| ----------- | ------------------------------------------------------------ |
| 1.x～3.x    | Maven Central：https://repo1.maven.org/maven2/org/codehaus/groovy/<br/> Groovy 发布存储库：https://groovy.jfrog.io/artifactory/libs-release-local/org/codehaus/groovy |
| 4.x+        | Maven Central：https://repo1.maven.org/maven2/org/apache/groovy/<br /> Groovy发布仓库：https://groovy.jfrog.io/artifactory/libs-release-local/org/apache/groovy |

### 2.3 环境变量配置

1、将 `GROOVY_HOME` 环境变量设置为解压缩发行版文件的目录；

2、将 `GROOVY_HOME/bin` 添加到 `PATH` 环境变量中；

3、将 `JAVA_HOME` 环境变量指向你的 JDK。OS X 上是 `/Library/Java/Home`，其他 unix 环境通常是 `/usr/java` 。一般情况下，如果你已经装过 Ant 或 Maven 等工具，Java环境变量通常都已经配置过了。



此时，可以通过以下命令来测试：
```bash
groovysh
```
它会创建一个 groovy shell 交互会话，你可以在此处拼写 Groovy 语句。或者拼写以下命令来运行Swing 交互控制台： 
```bash
groovyConsole
```
运行指定的 Groovy 脚本：
```bash
groovy SomeScript
```

