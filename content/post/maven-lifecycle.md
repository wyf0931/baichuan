---
title: "Maven生命周期"
author: Scott
tags:
  - Maven
  - Java
categories:
  - 技术
date: 2021-04-18T16:17:25+08:00
---

### 一、Maven build 生命周期概要

Maven 从 build 生命周期的核心思想出发，内置了三个 build 生命周期：

- `default`：用于处理项目部署；
- `clean`：用于处理项目清理；
- `site`：用于处理项目站点文档的创建。



每个 build 生命周期都包含了不同的构建阶段（phases）清单，其中构建阶段代表生命周期中的一个阶段。

比如，`default` 生命周期包含以下阶段：

![maven_default_simple_lifecycle_v1](https://blog-1252438081.cos.ap-shanghai.myqcloud.com/img/maven_default_simple_lifecycle_v1.png)

- `validate` ：确认项目是正确的，并提供所有必要的信息
- `compile` ：编译项目中的源代码
- `test` ：使用合适的单元测试框架测试已编译的源代码。这些测试代码不要求打包或部署
- `package `：获取已编译的代码，并将其打包成可分发的格式，例如 JAR
- `verify` ：检查集成测试的结果，确保符合质量标准
- `install` ：将软件包安装到本地仓库（repository）中，用作本地其他项目的依赖项
- `deploy` ：在构建环境中完成，将最终包复制到远程仓库，用于与其他开发人员和项目共享

这些生命周期阶段（加上这里没有显示的其他生命周期阶段）按顺序执行，完成 `default` 的生命周期。

按照上面的生命周期阶段（phases），这意味着当使用 `default` 生命周期时，Maven 将首先验证（`validate`）项目，然后尝试编译（`compile`）源代码，运行测试（`test`）代码，打包（`package `）二进制文件(例如 jar) ，针对该包运行集成测试，验证集成测试（`verify`），将验证包安装（`install`）到本地仓库，然后将安装的包部署（`deploy`）到远程仓库。

#### 命令行调用

通常情况下，可以用命令行来调用各个阶段：

```shell
mvn clean deploy
```

#### 构建阶段由插件目标组成

然而，即使构建阶段负责构建生命周期中的特定步骤，它执行这些责任的方式可能会有所不同。这是通过声明插件目标绑定到这些构建阶段来实现的。

**一个插件目标（goal）代表一个特定的任务（比构建阶段更精细）**，它有助于构建和管理一个项目。它可能被绑定到零个或多个构建阶段。不绑定到任何构建阶段的目标可以通过直接调用在构建生命周期之外执行。执行的顺序取决于调用目标和构建阶段的顺序。例如，考虑下面的命令。`clean` 和 `package` 参数是构建阶段，而 `dependency: copy-dependencies` 是插件的目标。

```sh
mvn clean dependency:copy-dependencies package
```

如果这被执行，`clean` 段将首先执行（这意味着它将运行清洁生命周期的所有前期阶段，加上`clean` 阶段本身） ，然后是`dependency:copy-dependencies` 目标（goal），最后执行打包（`package`）阶段(以及`default`生命周期的所有前期构建阶段)。



此外，如果一个目标与一个或多个构建阶段绑定，那么该目标将在所有这些阶段中调用。

此外，构建阶段还可以有零个或多个与之绑定的目标。如果构建阶段没有绑定到它的目标，那么构建阶段将不会执行。但是，如果它有一个或多个目标，它将执行所有这些目标。



> **注意：**
>
> 在 Maven 2.0.5及以上版本中，绑定到一个阶段的多个目标按照 POM 中声明的相同顺序执行，但是不支持同一个插件的多个实例。同一个插件的多个实例被分组在一起执行，并在 Maven 2.0.11及以上版本中排序。

#### 有些阶段通常不从命令行调用

使用连字符(`pre-*` 、 post-* 或 `process-*`)命名的阶段通常不直接从命令行调用。这些阶段对构建进行排序，生成在构建之外没有用处的中间结果。在调用集成测试的情况下，环境可能处于悬挂状态。

代码覆盖工具(如 Jacoco)和执行容器插件(如 Tomcat、 Cargo 和 Docker)将目标绑定到 `pre-integration-test` 阶段，以准备集成测试容器环境。这些插件还将目标绑定到 `post-integration-test` 阶段，以收集覆盖率统计信息或者解除集成测试容器的运行。

Failsafe 和代码覆盖率插件将目标绑定到 `integration-test` 和 `verify` 阶段。最终的结果是在 `verify` 阶段之后可以得到测试和覆盖报告。如果从命令行调用 `integration-test` ，则不会生成报告。更糟糕的是，集成测试容器环境处于挂起状态；Tomcat webserver 或 Docker 实例处于运行状态，Maven 甚至可能不会自行终止。



### 二、生命周期参考手册

`clean` 生命周期：

<img src="https://blog-1252438081.cos.ap-shanghai.myqcloud.com/img/maven_clean_lifecycle.png" alt="maven_clean_lifecycle"  />

| Phase（阶段） | 描述 |
| ------------- | -------- |
| `pre-clean` | 在实际项目清理之前执行所需的流程 |
| `clean` | 删除前一版本生成的所有文件 |
| `post-clean` | 执行完成项目清理所需的流程 |

`default` 生命周期：

![maven_default_simple_lifecycle](https://blog-1252438081.cos.ap-shanghai.myqcloud.com/img/maven_default_simple_lifecycle.png)

| Phase（阶段）             | 描述                                                         |
| ------------------------- | ------------------------------------------------------------ |
| `validate`                | 验证项目是正确的，所有必要的信息是可用的                     |
| `initialize`              | 初始化构建状态，例如设置属性或创建目录                       |
| `generate-sources`        | 生成任何源代码以供编译时包含                                 |
| `process-sources`         | 处理源代码，例如过滤任何值                                   |
| `generate-resources`      | 生成包含在包中的资源                                         |
| `process-resources`       | 将资源复制并处理到目标目录中，以便进行打包                   |
| `compile`                 | 编译项目的源代码                                             |
| `process-classes`         | 对编译生成的文件进行后期处理，例如对 Java 类进行字节码增强   |
| `generate-test-sources`   | 生成编译中包含的任何测试源代码                               |
| `process-test-sources`    | 处理测试源代码，例如过滤任何值                               |
| `generate-test-resources` | 创建测试资源                                                 |
| `process-test-resources`  | 将资源复制并处理到测试目标目录中                             |
| `test-compile`            | 将测试源代码编译到测试目标目录中                             |
| `process-test-classes`    | 对测试编译生成的文件进行后期处理，例如对 Java 类进行字节码增强 |
| `test`                    | 使用合适的单元测试框架运行测试。这些测试不需要打包或部署代码 |
| `prepare-package`         | 执行任何必要的操作，准备包装之前，实际包装。这通常会导致包装的未打包、处理版本 |
| `package`                 | 获取已编译的代码，并将其打包成可分发的格式，例如 JAR         |
| `pre-integration-test`    | 在执行集成测试之前执行所需的操作。这可能涉及诸如设置所需的环境之类的事情 |
| `integration-test`        | 如果需要的话，将包部署到可以运行集成测试的环境中             |
| `post-integration-test`   | 执行完集成测试后所需的操作，包括清理环境                     |
| `verify`                  | 运行任何检查，以验证包是有效的，并符合质量标准               |
| `install`                 | 将包安装到本地存储库中，以便在本地其他项目中作为依赖项使用   |
| `deploy`                  | 在集成或发布环境中完成，将最终包复制到远程存储库，以便与其他开发人员和项目共享 |

`site` 生命周期：

![maven_site_lifecycle](https://blog-1252438081.cos.ap-shanghai.myqcloud.com/img/maven_site_lifecycle.png)

| Phase（阶段） | 描述                                             |
| ------------- | ------------------------------------------------ |
| `pre-site`    | 在实际项目现场生成之前，执行所需的流程           |
| `site`        | 生成项目的现场文档                               |
| `post-site`   | 执行完成站点生成所需的流程，并为站点部署做好准备 |
| `site-deploy` | 将生成的站点文档部署到指定的 web 服务器          |

Maven 的整个生命周期由 `maven-core` 模块中的 `components.xml` 文件定义，并提供[相关文档](http://maven.apache.org/ref/current/maven-core/lifecycles.html)作为参考。

默认生命周期绑定定义在单独的 [default-bindings.xml](https://github.com/apache/maven/blob/master/maven-core/src/main/resources/META-INF/plexus/default-bindings.xml) 描述符中。

参见[生命周期参考](http://maven.apache.org/ref/current/maven-core/lifecycles.html)和插件绑定，获得[默认的生命周期参考](http://maven.apache.org/ref/current/maven-core/default-bindings.html)，获得直接取自源代码的最新文档。



参考文章：http://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html

