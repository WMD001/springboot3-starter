北知局项目后端创建模板

## 使用方式

使用本项目之前，应确保 `bzj-starter-parent` 已经在本地`install`过.

### 导入项目

下载本项目代码文件，打开编辑器导入maven项目，待导入完成后，运行 `BzjStarterApplication.class`，可以看到日志输出启动日志，以及启动时使用的端口号。
端口默认配置`0`，使用随机端口号，避免和本地端口冲突。

浏览器访问 `localhost:端口号/bzj-starter`

返回：
```text
bzj start project.
```


### 修改配置

**context-path**
修改配置文件中：
```yml
server:
  servlet:
    context-path: /bzj-starter # web context path
```
修改为自己项目的名称。

**port**
修改端口号
```yml
server:
  port: 0 # web port, 0 is random port
```

**pom.xml**
修改pom文件中项目相关的配置
```
    <artifactId>bzj-starter</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>bzj-starter</name>
```

修改最终打包名称
```text
<build>
    <finalName>bzj-starter</finalName>
    ...
</build>
```