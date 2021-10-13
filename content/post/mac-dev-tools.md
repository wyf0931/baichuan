---
title: "Mac环境下的一些快捷方式配置"
date: 2021-09-22T11:00:02+08:00
author: Scott
tags:
  - 工具
categories:
  - 技术
draft: true
---

在日常开发时，经常会遇到 JDK版本切换、从命令行中打开一些开发软件等。

<!--more-->

## 安装说明

如果你用的是Mac自带的命令行工具（Terminal），则下文中的命令需要配置在 `~/.bashrc`  中，并通过 `source ~/.bashrc` 来使其生效。

如果你用的是zsh，可以在 `~/.zshrc` 中配置，并通过 `source  ~/.zshrc` 来使其生效。

下文中都以 zsh 的配置为例。



## 1、从命令行中打开 Intellij Idea

```bash
#!/bin/sh

# check for where the latest version of IDEA is installed
IDEA=`ls -1d /Applications/IntelliJ\ * | tail -n1`
wd=`pwd`

# were we given a directory?
if [ -d "$1" ]; then
#  echo "checking for things in the working dir given"
  wd=`ls -1d "$1" | head -n1`
fi

# were we given a file?
if [ -f "$1" ]; then
#  echo "opening '$1'"
  open -a "$IDEA" "$1"
else
    # let's check for stuff in our working directory.
    pushd $wd > /dev/null

    # does our working dir have an .idea directory?
    if [ -d ".idea" ]; then
#      echo "opening via the .idea dir"
      open -a "$IDEA" .

    # is there an IDEA project file?
    elif [ -f *.ipr ]; then
#      echo "opening via the project file"
      open -a "$IDEA" `ls -1d *.ipr | head -n1`

    # Is there a pom.xml?
    elif [ -f pom.xml ]; then
#      echo "importing from pom"
      open -a "$IDEA" "pom.xml"

    # can't do anything smart; just open IDEA
    else
#      echo 'cbf'
      open "$IDEA"
    fi

    popd > /dev/null
fi
```



## 2、从命令行中打开 VS Code

在 `~/.zshrc` 中配置以下内容，并通过 `source  ~/.zshrc` 来使其生效。

```bash
alias vscode='/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code'
```

然后进入你

## 3、从命令行中打开 Sublime Text

待补充

## 4、JDK 版本切换

此处以 Java 8、Java 7为例，需要先下载并安装对应版本的 JDK，

```bash
#add jdk
export JAVA_7_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_10.jdk/Contents/Home
export JAVA_8_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_231.jdk/Contents/Home

#add alias for jdk switch
alias jdk8='export JAVA_HOME=$JAVA_8_HOME'
alias jdk7='export JAVA_HOME=$JAVA_7_HOME'
```

