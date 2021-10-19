---
title: "Pydantic - Python数据验证框架"
date: 2021-10-18T16:18:45+08:00

draft: false
tags:
  - Python
categories:
  - 技术
---



Python 的类型验证和数据校验是一个比较麻烦的事情，幸好已经有了Pydantic这种成熟的框架来解决。

<!--more-->



Pydantic 官方文档地址：https://pydantic-docs.helpmanual.io/

Pydantic Github地址：https://github.com/samuelcolvin/pydantic/



## 代码示例

下面这个是一个常见使用案例。

```python
from datetime import datetime
from typing import List, Optional
from pydantic import BaseModel


class User(BaseModel):
    id: int
    name = 'John Doe'
    signup_ts: Optional[datetime] = None
    friends: List[int] = []


external_data = {
    'id': '123',
    'signup_ts': '2019-06-01 12:22',
    'friends': [1, 2, '3'],
}
user = User(**external_data)
print(user.id)
#> 123
print(repr(user.signup_ts))
#> datetime.datetime(2019, 6, 1, 12, 22)
print(user.friends)
#> [1, 2, 3]
print(user.dict())
"""
{
    'id': 123,
    'signup_ts': datetime.datetime(2019, 6, 1, 12, 22),
    'friends': [1, 2, 3],
    'name': 'John Doe',
}
"""
```

代码说明：

1. 指定`id` 的类型为 `int` ，如果传入的 id 数据是 `string`、`byte` 或 `float` ，则将强制为 `int` ， 转换失败会引发异常；
2. `name` 如果不传，则默认值为 `John Doe`；
3. `signup_ts` 是一个可选的 `datetime` 字段(如果没有提供，则赋值为 `None` 。
4. `friends` 是一个整数列表，与 `id` 一样，类似整数的对象将被转换为整数。



如果验证失败，pydantic 会抛出错误，并对错误进行细分：

```python
from pydantic import ValidationError

try:
    User(signup_ts='broken', friends=[1, 2, 'not number'])
except ValidationError as e:
    print(e.json())
```

异常输出如下：

```json
[
  {
    "loc": [
      "id"
    ],
    "msg": "field required",
    "type": "value_error.missing"
  },
  {
    "loc": [
      "signup_ts"
    ],
    "msg": "invalid datetime format",
    "type": "value_error.datetime"
  },
  {
    "loc": [
      "friends",
      2
    ],
    "msg": "value is not a valid integer",
    "type": "type_error.integer"
  }
]
```



## Pydantic 用户案例

- [FastAPI](https://fastapi.tiangolo.com/)：一个基于 pydantic 和 Starlette 的高性能 API 框架，易于学习，编码速度快，可用于生产。

- [Project Jupyter](https://jupyter.org/)：Jupyter notebook 的开发者正在用 pydantic 来开发[子项目](https://github.com/samuelcolvin/pydantic/issues/773)。

- Microsoft：[许多服务](https://github.com/tiangolo/fastapi/pull/26#issuecomment-463768795)中都使用了 pydantic (FastAPI) ，其中一些服务正在“集成到核心 Windows 产品和一些 Office 产品中”
- Amazon Web Services：在[gluon-ts](https://github.com/awslabs/gluon-ts)中使用了 pydantic，[gluon-ts](https://github.com/awslabs/gluon-ts) 是一个开源的概率时间序列模型库。
- The NSA（美国国家安全局） ：在开源自动化框架 [WALKOFF](https://github.com/nsacyber/WALKOFF) 中使用了 pydantic。
- Uber：在 [Ludwig](https://github.com/uber/ludwig) 使用 pydantic，一个开源的 TensorFlow 包装器。
- Cuenca：是墨西哥的一个新银行，它使用 pydantic 来处理一些内部工具(包括 API 验证)和开源项目，比如 stpmex，用于在墨西哥处理实时的 24 x 7 的银行间转账。
- [The Molecular Sciences Software Institute（分子科学软件研究所）](https://molssi.org/)：在 [QCFractal](https://github.com/MolSSI/QCFractal) 中使用了 pydantic，QCFractal 是一个量子化学的大规模分布式计算框架。
- [Reach](https://www.reach.vote/)：通过 pydantic  (FastAPI) 和 [arq](https://github.com/samuelcolvin/arq) (Samuel 优秀的异步任务队列)来可靠地支持多个任务关键型微服务。
