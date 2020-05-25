---
title: "Inotify简介"
author: Scott
tags:
  - Linux
  - 工具
categories: []
date: 2020-05-25T19:49:39+08:00
draft: false
---

**Inotify 是一种强大的、细粒度的、异步的文件系统事件监控机制， Linux 内核从2.6.13起，加入了 Inotify 支持。**

<!--more-->

通过 *Inotify* 可以监控文件系统中添加、删除，修改、移动等各种事件，利用这个内核接口，第三方软件就可以监控文件系统下文件的各种变化情况，而` inotify-tools` 正是实施这样监控的软件。

*Inotify* 实际是一种事件驱动机制，它为应用程序监控文件系统事件提供了实时响应事件的机制，而无须通过诸如*cron* 等的轮询机制来获取事件。*cron* 等机制不仅无法做到实时性，而且消耗大量系统资源。相比之下，*inotify* 基于事件驱动，可以做到对事件处理的实时响应，也没有轮询造成的系统资源消耗，是非常自然的事件通知接口，也与自然世界事件机制相符合。

常见的实现 *inotify* 机制的软件有：

- `inotify-tools`
- `sersync`
- `lrsyncd`

### 一、安装 inotify-tools

CentOS:

```shell
yum install -y inotify-tools
```

Ubuntu:

```shell
apt-get install inotify-tools
```

### 二、inotify-tools 命令介绍

`inotify-tools` 主要包括两个命令：`inotifywait` 、`inotifywatch`。

- `inotifywait` 在被监控的文件或目录上等待特定文件系统事件（open close delete等）发生，执行后处于阻塞状态，适合在shell脚本中使用；
- `inotifywatch` 收集被监控的文件系统使用的统计数据，指文件系统事件发生的次数统计。

文件监控主要依赖 `inotifywatch`。以下是 `inotifywatch` 的help信息：

```shell
ubuntu@VM-0-3-ubuntu:~$ inotifywait -h
inotifywait 3.14
Wait for a particular event on a file or set of files.
Usage: inotifywait [ options ] file1 [ file2 ] [ file3 ] [ ... ]
Options:
	-h|--help     	Show this help text.
	@<file>       	Exclude the specified file from being watched.
	--exclude <pattern>
	              	Exclude all events on files matching the
	              	extended regular expression <pattern>.
	--excludei <pattern>
	              	Like --exclude but case insensitive.
	-m|--monitor  	Keep listening for events forever.  Without
	              	this option, inotifywait will exit after one
	              	event is received.
	-d|--daemon   	Same as --monitor, except run in the background
	              	logging events to a file specified by --outfile.
	              	Implies --syslog.
	-r|--recursive	Watch directories recursively.
	--fromfile <file>
	              	Read files to watch from <file> or `-' for stdin.
	-o|--outfile <file>
	              	Print events to <file> rather than stdout.
	-s|--syslog   	Send errors to syslog rather than stderr.
	-q|--quiet    	Print less (only print events).
	-qq           	Print nothing (not even events).
	--format <fmt>	Print using a specified printf-like format
	              	string; read the man page for more details.
	--timefmt <fmt>	strftime-compatible format string for use with
	              	%T in --format string.
	-c|--csv      	Print events in CSV format.
	-t|--timeout <seconds>
	              	When listening for a single event, time out after
	              	waiting for an event for <seconds> seconds.
	              	If <seconds> is 0, inotifywait will never time out.
	-e|--event <event1> [ -e|--event <event2> ... ]
		Listen for specific event(s).  If omitted, all events are
		listened for.

Exit status:
	0  -  An event you asked to watch for was received.
	1  -  An event you did not ask to watch for was received
	      (usually delete_self or unmount), or some error occurred.
	2  -  The --timeout option was given and no events occurred
	      in the specified interval of time.

Events:
	access		file or directory contents were read
	modify		file or directory contents were written
	attrib		file or directory attributes changed
	close_write	file or directory closed, after being opened in
	           	writable mode
	close_nowrite	file or directory closed, after being opened in
	           	read-only mode
	close		file or directory closed, regardless of read/write mode
	open		file or directory opened
	moved_to	file or directory moved to watched directory
	moved_from	file or directory moved from watched directory
	move		file or directory moved to or from watched directory
	create		file or directory created within watched directory
	delete		file or directory deleted within watched directory
	delete_self	file or directory was deleted
	unmount		file system containing file or directory unmounted
```

### 三、示例

监听`/opt/blog` 目录下的文件变化，在发生指定的事件时（`modify`, `create`, `move`, `delete`）调用 `hugo` 编译。

```shell
while true; do
    if [[ "$(inotifywatch -r -t 5 -e modify,create,move,delete /opt/blog 2>&1)" =~ filename ]]; then
	cd /opt/blog;
    	hugo;
    fi;
done
```

上述命令可以通过 `nohup xxx.sh &` 方式在后台长期执行。其中 `xxx.sh` 的内容就是上述命令。