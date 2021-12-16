---
title: "PlantUML 日常使用总结"
date: 2021-09-03T17:08:59+08:00
author: Scott
tags:
  - 工具
categories:
  - 技术
draft: false
---

[PlantUML](https://plantuml.com/zh/) 是一个开源项目，支持快速绘制：[时序图](https://plantuml.com/zh/sequence-diagram)、[用例图](https://plantuml.com/zh/use-case-diagram)、[类图](https://plantuml.com/zh/class-diagram)、[对象图](https://plantuml.com/zh/object-diagram)、[活动图](https://plantuml.com/zh/activity-diagram-beta)、[组件图](https://plantuml.com/zh/component-diagram)、[部署图](https://plantuml.com/zh/deployment-diagram)、[状态图](https://plantuml.com/zh/state-diagram)、[定时图](https://plantuml.com/zh/timing-diagram)等常规UML图，还支持一些非UML图：[JSON 数据](https://plantuml.com/zh/json)、[YAML 数据](https://plantuml.com/zh/yaml)、[网络图 (nwdiag)](https://plantuml.com/zh/nwdiag)、[线框图形界面](https://plantuml.com/zh/salt)、[架构图](https://plantuml.com/zh/archimate-diagram)、[规范和描述语言 (SDL)](https://plantuml.com/zh/activity-diagram-beta#sdl)、[Ditaa 图](https://plantuml.com/zh/ditaa)、[甘特图](https://plantuml.com/zh/gantt-diagram)、[思维导图](https://plantuml.com/zh/mindmap-diagram)、[WBS 工作分解图](https://plantuml.com/zh/wbs-diagram)、[以 AsciiMath 或 JLaTeXMath 符号的数学公式](https://plantuml.com/zh/ascii-math)、[实体关系图](https://plantuml.com/zh/ie-diagram)等。可以生成PNG，[SVG](https://plantuml.com/zh/svg) 或 [LaTeX](https://plantuml.com/zh/latex) 格式的图片。也可以生成 [ASCII艺术图](https://plantuml.com/zh/ascii-art)（仅限时序图）。



<!--more-->

## 常用样式

由于默认的样式比较单一，开源社区中有很多优化方案。

### 1、RedDress-PlantUML

使用方法：

定义主题风格（`LIGHTORANGE`），然后引入主题样式库。

```plantuml
@startuml
!define LIGHTORANGE
!includeurl https://gitee.com/dotions/RedDress-PlantUML/raw/master/style.puml
' 这里写自己的plantuml代码
@enduml
```

可选的主题风格：

- `DARKBLUE` （深蓝色）
- `LIGHTBLUE`（浅蓝色）
- `DARKRED`（深红色）
- `LIGHTRED`（浅红色）
- `DARKGREEN`（深绿色）
- `LIGHTGREEN`（浅绿色)
- `DARKORANGE`（深橙色)
- `LIGHTORANGE`（浅橙色）

案例：

```plantuml
@startuml
class Object << general >>
Object <|--- ArrayList : parent

note top of Object : In java, every class\nextends this one.

note "This is a floating note" as N1
note "This note is connected\nto several objects." as N2
Object .. N2
N2 .. ArrayList : a message

class Foo {
  -privateField
  +publicField
  #protectedField
  ~classProtected
  styled method01();
  void method02();
}
note bottom: On last defined class

Foo -[hidden]> Object
@enduml
```

效果：

![效果图](http://plantuml.zhizhiting.com/png/JP1FImCn4CNl-HIFUb5q5xl7MWfU2eAq7hnP3-bcsgPiPvPaN2p--UmcswuK0idyaZVlJUh6neZbUa-rOZh5bfY2RJ2RcG5-5qM1nn3iyTb7nGIj3SHg38iIL5h8PkWmmHDZRpjx1-ee757d_YkcJoLs4Rhp4S9KdjMZrmpIijWqOjNp5lbY11kn65y-wezfhuKvMP5RiGfYjabvfVUFvKbO3U7BCXUBAXykHx0uK8nsIyRq2J4NmPS1YZRupYhDFJKkrRVjnxhnzL1UjI75oEu3-UtrBmDE9Egn8PSCT2VkVdnzyv1W9_uVLHdzd6PRYweS9bWoKX-5eutdfEwx6fDZ5Myxxnpn--pyoty0)

### 2、PlantUML Icon-Font Sprites

使用方式：

导入sprites：

```
!define ICONURL https://gitee.com/dotions/plantuml-icon-font-sprites/raw/master/
!includeurl ICONURL/common.puml
!includeurl ICONURL/devicons/mysql.puml
!includeurl ICONURL/font-awesome/database.puml
!includeurl ICONURL/font-awesome-5/database.puml
```

#### 2.1 icon 集合

| Name                                                       | Index                                                        |
| ---------------------------------------------------------- | ------------------------------------------------------------ |
| [Font-Awesome 4](https://fontawesome.com/v4.7.0/)          | [List of macros](https://gitee.com/dotions/plantuml-icon-font-sprites/blob/master/font-awesome/index.md) |
| [Font-Awesome 5](http://fontawesome.io/)                   | [List of macros](https://gitee.com/dotions/plantuml-icon-font-sprites/blob/master/font-awesome-5/index.md) |
| [Devicons](http://vorillaz.github.io/devicons)             | [List of macros](https://gitee.com/dotions/plantuml-icon-font-sprites/blob/master/devicons/index.md) |
| [Govicons](http://govicons.io/)                            | [List of macros](https://gitee.com/dotions/plantuml-icon-font-sprites/blob/master/govicons/index.md) |
| [Weather](https://erikflowers.github.io/weather-icons/)    | [List of macros](https://gitee.com/dotions/plantuml-icon-font-sprites/blob/master/weather/index.md) |
| [Material](http://google.github.io/material-design-icons/) | [List of macros](https://gitee.com/dotions/plantuml-icon-font-sprites/blob/master/material/index.md) |
| [Devicon 2](https://github.com/devicons/devicon.git)       | [List of macros](https://gitee.com/dotions/plantuml-icon-font-sprites/blob/master/devicons2/index.md) |

案例：

```plantuml
@startuml

skinparam defaultTextAlignment center

!define ICONURL https://gitee.com/dotions/plantuml-icon-font-sprites/raw/master/

!includeurl ICONURL/common.puml
!includeurl ICONURL/devicons/mysql.puml
!includeurl ICONURL/font-awesome/server.puml
!includeurl ICONURL/font-awesome-5/database.puml

title Styling example

FA_SERVER(web1,WEB1) #Green
FA_SERVER(web2,WEB1) #Yellow
FA_SERVER(web3,WEB1) #Blue
FA_SERVER(web4,WEB1) #YellowGreen

FA5_DATABASE(db1,LIVE,database,white) #RoyalBlue
DEV_MYSQL(db2,SPARE,database) #Red

db1 <--> db2

web1 <--> db1
web2 <--> db1
web3 <--> db1
web4 <--> db1

@enduml
```

效果图：

![案例图片](http://plantuml.zhizhiting.com/png/ZP1TQy8m58RlyoioTkEWDVXrCyQWpcu8xgjr3gyajaSDEqcw9BNwxvSgtIXii9l0o_kSvoIn7q8Lt719SzZm4jqS3Yv2iLKIbAEPFy0GSk5ReO1ExvwVtf8PtJbNs6l6ji81T3CjMQwTqCgo0hbofSHGP5g56wrSQ0lZCSiChvZarWkPDmgLOPb3QR2nCk-HMdKBF_vhdyE-jbecZ_OJ_-PEMta5LajW5imUpF_WSCHoxlYQMpWF42SS0atT4ONQKZXmMI0GSX-jqZXPn4cdWdKlU8_7lIjw-M00LBlhDzqI47NLBWTDESOIsjMmFNSsUsIqcaJpQ1obSIVtYsVJHHmqLmwgdVzdFvFe8yUJSn8lLe_Bz7NcwNwGlaJ93rw3a1FYFVGc36-fHmYftzF4NftwhJHefU5t-W80)

## 3、自带样式风格

通过 `skinparam monochrome true` 设置为黑白风格。

通过 `autonumber 1 1 "<b>[00]</b>"` 实现序号自增；

案例：

```plantuml
@startuml mybatis_cipher_plugin_flowchart

' 数据加密流程

skinparam monochrome true

participant "Mapper" as mapper
participant "Mybatis" as mybatis
participant "Mybatis-Plugin" as plugin
participant "Cipher-SDK" as sdk
participant "RDS(MySQL)" as db

autonumber 1 1 "<b>[00]</b>"

mapper -> mybatis : 请求执行insert/update操作；

activate mybatis
mybatis -> plugin : 执行加解密代理逻辑；
activate plugin

plugin -> plugin : 提取参数中的@CipherField注解字段；
plugin -> sdk : 请求加密内容；
activate sdk 

sdk ->> plugin : 返回密文；

deactivate sdk 
plugin -> plugin : 增加xxx_cipher字段和对应参数值；
plugin ->> mybatis : 代理逻辑执行成功
deactivate plugin

mybatis -> db : 保存密文数据；
activate db 
db ->> mybatis : 保存成功；
deactivate db 

mybatis ->> mapper : 操作成功；
deactivate mybatis

@enduml
```

效果图：

![效果图3](http://plantuml.zhizhiting.com/png/RLBBIiD05DtFLmpTg8jYtOe4mU962sgN8f8qWmurQSX3wav5wvlMj_YeZovqqrOHyLNrPphJkF8Nd4TR4oaXOSWzzvnppvqkI0_lwKw5R5wHQeu-BJNkjW1mqjYqL5ire94nCwbPEsCWwDeU0e3zTd4AMwhfmaX2jInaHw3gG4CS_vKNDDN5ZgpBSqT0T6pEcy6cm5dY68ODOMiMsT5aV4H073qTha_4azs9XUJuQ8-ewne0gkTcJC_Ga0txs1CPq9J9M6nge5TJ8W18ip2gj6p1VkXNd-d3CjsuzQ-tiUaWs-trB5rr4TtVgN-S_zJE66lAnVFiLtkQLZjZaiOPaQHWWVgt9PPf_RtKAEI-5z_zprrEqkPeJWgQZI6AV87aZqX-cIsd_b9kdAuCoWo6CPhJwUCTfouVqyeJP_mZOCcq9v4R9RbLKdaDwN8GMp7xHfM0flzrGCwA_18ShObXTHHkwU2Jt1IPJ3QRdKu9Uz8JsTicrLVoTY0788kraCjWwC5mP6vqlK0sBuFYhPm2MUiQx_sw8EKJQLXUuj2O30FO-qzFz4WDZWx8S7n0GsdUQBuDSG4wDZNnlm00)

