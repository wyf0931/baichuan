---
title: Linux 生成 SSH Key
author: Scott
tags:
  - Linux
  - ''
categories: []
date: 2019-06-28 14:17:00
---
在命令行输入以下命令（把 `your_email@example.com` 替换为自己的邮箱），然后按下回车键：
```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

系统会提示：
```
Generating public/private rsa key pair.
Enter a file in which to save the key (/home/ubuntu/.ssh/id_rsa):
```
按回车键，表示接受默认生成文件路径 `/home/ubuntu/.ssh/id_rsa`

然后系统提示输入安全码，以及确认安全码：
```
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
```
此处可以不用输入，直接按回车键就行，然后系统提示如下：
```
Your identification has been saved in /home/ubuntu/.ssh/id_rsa.
Your public key has been saved in /home/ubuntu/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:7Uj7e+wxqNhsXjd/q+zhnxPSfesbFaVt9fiWNcsmgvE your_email@example.com
The key's randomart image is:
+---[RSA 4096]----+
|           .o. .=|
|           .. .o=|
|             E.++|
|         .    o.*|
|        S . .  =o|
|       . + o o ..|
|        o +.B....|
|       +.+ .=Bo.+|
|      .o= o++B=*=|
+----[SHA256]-----+
```

到此，ssh key 生成完毕，可以在用户目录下的 `.ssh` 文件夹中查看。