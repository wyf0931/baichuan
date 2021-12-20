---
title: Maven密码加密功能
identifier: maven-password-encrypt
author: Scott
date: 2021-12-20T11:09:12.546Z
tags:
  - Maven
categories:
  - 技术
---

Maven 本身就支持密码加密功能，这里做个系统性的介绍。

<!--more-->



## 背景

Maven 服务端需要支持密码加密，主要业务场景有：

1、多个用户共享同一个构建（build）机器；

2、有些用户有将 Maven 构件（artifact）部署到存储库（repository）的权限，其他人可能没有；

3、用户共享 `settings.xml` 文件；

## 解决方案

### 2.1 概述

给已经授权的用户在  `${user.home}/.m2` 目录下增加了一个 `settings-security.xml` 文件：

- 这个文件需要包含  **master password**，用来给其他密码加密；或者可以包含一个 `relocation` 引用指向其他文件（可以保存在可移动设备上）；
- 密码通过 CLI 创建；

`settings.xml` 文件中的 `server` 列表包含加密过的密码或者 keystore 口令。

### 2.2 怎么创建 master password？

使用以下命令创建：

```bash
mvn --encrypt-master-password <password>
```

**注意：**从Maven 3.2.1开始，不再使用 password 参数(更多信息参见[下面的提示](https://maven.apache.org/guides/mini/guide-encryption.html#Tips))，Maven 会提示输入密码。较早版本的 Maven 不会提示输入密码，因此必须在命令行上以明文输入密码。

这个命令将生成密码的密文类似这样：

```bash
{jSMOWnoPFgsHVpMvz5VrIt5kRbzGpI8u+9EF1iFQyJQ=}
```

密码会存储在 `${user.home}/.m2/settings-security.xml` ，大概长这样：

```xml
<settingsSecurity>
  <master>{jSMOWnoPFgsHVpMvz5VrIt5kRbzGpI8u+9EF1iFQyJQ=}</master>
</settingsSecurity>
```

到此，master password 已经创建完成，可以给其他密码加密了。

### 2.3 怎么给服务器的密码加密？

使用以下命令行：

```bash
mvn --encrypt-password <password>
```

**注意： **就像 `--encrypt-master-password` 一样，自从 Maven 3.2.1 以后，password 参数就不再使用了(更多信息请参见[下面的提示](https://maven.apache.org/guides/mini/guide-encryption.html#Tips))。

这个命令生成的密文类似于这样：

```bash
{COQLCE6DU6GtcS5P=}
```

复制并粘贴到 `settings.xml` 文件的 `server` 部分：

```xml
<settings>
...
  <servers>
...
    <server>
      <id>my.server</id>
      <username>foo</username>
      <password>{COQLCE6DU6GtcS5P=}</password>
    </server>
...
  </servers>
...
</settings>
```

注意，密码可以包含大括号之外的任何信息，因此以下内容仍然有效：

```xml
<settings>
...
  <servers>
...
    <server>
      <id>my.server</id>
      <username>foo</username>
      <password>Oleg reset this password on 2009-03-11, expires on 2009-04-11 {COQLCE6DU6GtcS5P=}</password>
    </server>
...
  </servers>
...
</settings>
```

然后你可以使用，比如通过 deploy 插件写到这个服务器上：

```bash
mvn deploy:deploy-file -Durl=https://maven.corp.com/repo \
                       -DrepositoryId=my.server \
                       -Dfile=your-artifact-1.0.jar \
```

### 2.4 怎么将master password 保存到移动硬盘上？

还是按照上述创建 master password 的方式来创建主密码，当并将其存储在一个移动硬盘上，例如在 OSX 上，我的 USB 驱动器安装为 `/volume/mySecureUsb`，因此我 `/Volumes/mySecureUsb/secure/settings-security.xml` 文件内容如下：

```xml
<settingsSecurity>
  <master>{jSMOWnoPFgsHVpMvz5VrIt5kRbzGpI8u+9EF1iFQyJQ=}</master>
</settingsSecurity>
```

然后 `${user.home}/.m2/settings-security.xml` 文件中的内容如下：

```xml
<settingsSecurity>
  <relocation>/Volumes/mySecureUsb/secure/settings-security.xml</relocation>
</settingsSecurity>
```

这样可以保障只有在插入 usb 移动硬盘时才能正常加解密。解决了部分人有部署权限的问题。

## 常见问题

### 1、密码中的大括号字符转义（Maven 2.2.0）

有时密文中会包含大括号，例如："{"，"}"。如果在 `settings.xml` 中加了这种密码，Maven会将 "{" 、"}" 前后的字符串当作注释信息。

可以通过反斜杠 "\\" 来转义字符，比如，你的密文是这个：

```bash
jSMOWnoPFgsHVpMvz5VrIt5kRbzGpI8u+{EF1iFQyJQ=
```

在 `settings.xml` 中可以这样写（注意转义字符）：

```bash
{jSMOWnoPFgsHVpMvz5VrIt5kRbzGpI8u+\{EF1iFQyJQ=}
```

### 2、不同平台间密码转义

在某些平台上，如果密码包含特殊字符（如% 、!、$） ，则可能需要用双引号将密码% 、!、$等包起来。例如，在 Windows 系统中下面的命令是行不通的：

```bash
mvn --encrypt-master-password a!$%^b
```

正确的方式如下：

```bash
mvn --encrypt-master-password "a!$%^b"
```

**如果你用的是 linux/unix 平台，那么上面的 master password 应该使用单引号**。

### 3、提示输入密码

在 3.2.1 版本之前的 Maven 中，必须在命令行上给出 password 参数，此时可能需要转义密码原文。此外，shell 通常存储输入的命令的完整历史记录，因此任何能够访问您的计算机的人都可以从 shell 的历史记录中恢复密码。

从 Maven 3.2.1开始，password 是一个可选参数。如果省略了 password，系统会提示您输入密码，以防止出现密码泄漏、原文转义的问题。

强烈建议使用 Maven 3.2.1及以上版本，以防止特殊字符转义问题，当然还有与 bash 历史或与 password 参数相关的环境问题和安全问题。

### 4、密码安全

编辑 settings.xml 文件，并执行上述命令，可能会让密码的原文保存在本地，你需要检查以下地方：

1、Shell 历史记录：（例如：执行 history），密码加密后记得清楚历史记录；

2、编辑器缓存：（例如：～/.viminfo）

还需要注意，密文可以由拥有 master password 和安全文件的人解密。因此最好将 `settings.xml` 文件和 master password 密码存储隔离开。


