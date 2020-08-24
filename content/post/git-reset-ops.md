---
title: "Git 代码回滚操作"
author: Scott
tags:
  - git
categories:
  - 技术
date: 2019-07-22 17:34:00
---
本文介绍在不同场景下回滚代码的常用命令。

<!--more-->

1、尚未进行 `git add` 操作

```bash
git checkout -- a.txt   # 恢复单个文件
git checkout -- .       # 恢复全部
```

2、已进行  `git add` 操作，但尚未进行 `git commit` 操作：

```bash
git reset HEAD a.txt  # 恢复单个文件
git reset HEAD .      # 恢复全部
```

3、已进行  `git commit` 操作，但尚未进行 `git push` 操作 ：

```bash
# 获取需要回退的 commit id
git log

# 回到其中想要的某个版
git reset --hard <commit_id>

# 回到上一个提交版本
git reset --hard HEAD^

# 保留代码，回到 git add 之前
git reset HEAD^
```

4、已进行 `git push` 操作：

1）通过 `git reset` 是直接删除指定的 commit

```bash
# 获取需要回退的 commit id
git log

# 回到其中想要的某个版
git reset --hard <commit_id>

# 强制提交一次，之前错误的提交就从远程仓库删除
git push origin HEAD --force 
```

2）通过 `git revert` 是用一次新的 commit 来回滚之前的 commit

```bash
# 获取需要回退的 commit id
git log

# 撤销指定的版本，撤销也会作为一次提交进行保存
git revert <commit_id> 
```

> `git revert`  和  `git reset ` 的区别：
>
> - `git revert` 是用一次新的 commit 来回滚之前的 commit，此次提交之前的 commit 都会被保留；
> - `git reset` 是回到某次提交，提交及之前的 commit 都会被保留，但是此 commit id 之后的修改都会被删除