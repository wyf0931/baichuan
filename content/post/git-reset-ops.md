---
title: "Git 常用操作"
author: Scott
tags:
  - git
categories:
  - 技术
date: 2019-07-22 17:34:00
---
本文记录了工作中常用的 Git 分支管理操作。

<!--more-->
### 一、代码回滚

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


### 二、分支管理

1. 查看所有分支（本地+远程）

```bash
git branch -a
```

2. 删除本地分支

```bash
# <branch-name> 为分支名称
git branch -d <branch-name>
```

3. 删除远程分支
```bash
# <branch-name> 为分支名称
git push origin --delete <branch-name>
```

4. 查看每个分支最后一次提交的版本
```bash
git branch -v
```
5. 复制分支
```bash
# <new-branch-name> 为新分支名称
# <old-branch> 为原分支名称。该参数可以省略，默认为当前分支。
git branch -c <old-branch> <new-branch-name>
```

6. 分支管理帮助文档

```bash
git branch -h
usage: git branch [<options>] [-r | -a] [--merged | --no-merged]
   or: git branch [<options>] [-l] [-f] <branch-name> [<start-point>]
   or: git branch [<options>] [-r] (-d | -D) <branch-name>...
   or: git branch [<options>] (-m | -M) [<old-branch>] <new-branch>
   or: git branch [<options>] (-c | -C) [<old-branch>] <new-branch>
   or: git branch [<options>] [-r | -a] [--points-at]
   or: git branch [<options>] [-r | -a] [--format]

Generic options
    -v, --verbose         show hash and subject, give twice for upstream branch
    -q, --quiet           suppress informational messages
    -t, --track           set up tracking mode (see git-pull(1))
    -u, --set-upstream-to <upstream>
                          change the upstream info
    --unset-upstream      Unset the upstream info
    --color[=<when>]      use colored output
    -r, --remotes         act on remote-tracking branches
    --contains <commit>   print only branches that contain the commit
    --no-contains <commit>
                          print only branches that don't contain the commit
    --abbrev[=<n>]        use <n> digits to display SHA-1s

Specific git-branch actions:
    -a, --all             list both remote-tracking and local branches
    -d, --delete          delete fully merged branch
    -D                    delete branch (even if not merged)
    -m, --move            move/rename a branch and its reflog
    -M                    move/rename a branch, even if target exists
    -c, --copy            copy a branch and its reflog
    -C                    copy a branch, even if target exists
    -l, --list            list branch names
    --create-reflog       create the branch's reflog
    --edit-description    edit the description for the branch
    -f, --force           force creation, move/rename, deletion
    --merged <commit>     print only branches that are merged
    --no-merged <commit>  print only branches that are not merged
    --column[=<style>]    list branches in columns
    --sort <key>          field name to sort on
    --points-at <object>  print only branches of the object
    -i, --ignore-case     sorting and filtering are case insensitive
    --format <format>     format to use for the output
```