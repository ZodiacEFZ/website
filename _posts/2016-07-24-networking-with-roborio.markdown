---
layout: post
title:  "和 Xenial 情感交流"
date:   2016-07-24 13:29:02 +0800
categories: programming
tags: zc大哥哥的编程干货 FRC@EFZ 机器人 Java
---

## 那些年，那个扫地机器人

SkyZH 研发了扫地机器人几个月后，终于意识到，只让扫地机器人自主扫地是远远不够的。
SkyZH 决定开发一套通讯系统，使用 Xenialware 上的 APP 控制扫地机器人打扫的房间。

为了连接到机器人，SkyZH 引入了一套协议 `mDNS`。
`mDNS` 帮助计算机快速连接到 RoboRIO 机器人。
没有 `mDNS` 协议，SkyZH 就必须在管理系统中获取机器人的 IP 地址，
然后在 APP 中手动输入。引入了这个协议后，SkyZH 就可以直接通过网址访问机器人了！
在烧写机器人固件时，SkyZH 确定了它的地址为 `roborio-2333-frc.local`。
于是他就可以直接通过 `roborio-2333-frc.local` 这个地址解析出机器人的局域网 IP
`10.23.33.xx`，接着连接上去了。

## Networktables

SkyZH 引入了 `Networktables` 协议进行机器人数据的储存。
SkyZH 可以在 `Networktables` 中创建表格，并在表格中储存键值对。

`Networktables` 由服务器和客户端组成。服务器一般运行在 RoboRIO 控制器上，
而客户端可以运行在任何地方。比如烧写在 RoboRIO 上的程序可以通过 `Networktables`
获取一个值，电脑上的 `SmartDashboard` 可以通过 `Networktables` 获取机器人的传感器数据，
同时你也可以通过 Python 编写一个 `Networktables` 程序。

### 打开测试的 NetworkTable

安装 WPIlib 插件之后，你就可以在 `<用户目录>/wpilib/tools` 中找到应用程序。

{% img '{{ "networking-roborio/smartdashboard-1.png" }}' %}

`OutlineViewer` 是一个 `Networktables` 的监视工具。你可以在这个应用里看到所有的 `Networktables` 数据。

{% img '{{ "networking-roborio/nt-1.png" }}' %}

地址填写 `localhost`，当然在调试机器人时要填写 `roborio-xxxx-frc.local`。
本地调试则点击 `Start Server` 运行服务器。调试机器人选择 `Start Client` 运行客户端。

{% img '{{ "networking-roborio/nt-2.png" }}' %}

在这个界面中就可以监视所有数值。

### 在机器人控制器上存储数据

首先要从 Networktables 中获取一张表格。

```java
NetworkTable ntable = NetworkTable.getTable("test");
```

接着就可以向表格中存储各种数据。

```java
ntable.putNumber("testInt", 233);
ntable.putString("testString", "Hello, World!");
```

`putString`/`putNumber` 在设置的键存在时，会覆盖之前的数据。但是，
如果 `test` 原先设置成数字 233，而后又 `putString("test", "Hello!")` 就会报错。
键的类型是不能改变的。

{% img '{{ "networking-roborio/nt-3.png" }}' %}

获取数据也十分简单。

```java
ntable.getNumber("testInt", 0);
ntable.getString("testString", "Default String");
```

函数的参数，第一个是要获取的键，第二个是如果该键不存在返回的默认值。

### 远程操控

视觉处理的数据经过控制器传输后，需要在电脑上处理。因此需要在电脑上远程连接 Networktables。

在使用 `getTable` 前调用初始化函数即可。

```java
NetworkTable.setTeam(9036);
```

### 订阅事件

通过 Networktables 的事件订阅机制，每当有值被修改时，都可以调用用户指定的函数。
首先要定义一个回调接口，并在接口中编写回调函数。

定义类成员变量 `tableListener`。

```java
private final ITableListener tableListener = new ITableListener() {

    @Override
    public void valueChanged(ITable source, String key, Object value,
            boolean isNew) {
        if (key.equals("testInt")) {
            System.out.println((Double)value);
        }
    }
};
```

在获取到 `Table` 对象后，注册事件处理器。

```java
ntable.addTableListener(tableListener);
```

### 事务

有一天 SkyZH 给扫地机器人编写了视觉处理确定打扫目标程序，程序返回了三个键值对的结果：

```
(targetAngle, 180.0)
(tragetPosition, 20)
(tragetSpeed, 10)
```

要进行存储，必然要经过以下几个步骤：

```
putNumber("targetAngle", 180.0);
...
putNumber("tragetPosition", 20);
...
putNumber("tragetSpeed", 10);
```

机器人要不断读取这些数据。

```
getNumber("targetAngle", 0);
...
getNumber("tragetPosition", 0);
...
getNumber("tragetSpeed", 0);
```

那么问题来了。假设储存程序执行了两次，而这一期间机器人又读取了数据：

```
事件流
1     targetAngle = 180
2     targetPosition = 20
3     targetSpeed = 10
4     get targetAngle           (=180)
5     get tragetPosition        (=20)
6     get targetSpeed           (=10)
7     targetAngle = 170
8     targetPosition = 25
9     targetSpeed = 13
```

一切正常。

但如果三个数据不是同时写入或同时读取，或者读取指令因为网络原因没有同时到达，可能造成这种队列：

```
事件流
1     targetAngle = 180
2     targetPosition = 20
3     targetSpeed = 10
4     get targetAngle           (=180)
5     targetAngle = 170
6     targetPosition = 25
7     get tragetPosition        (=25)
8     get targetSpeed           (=10)
9     targetSpeed = 13
```

这样获取到的组合就是 `{ targetSpeed: 10, targetPosition: 25, targetAngle: 180 }`，不是任何一次设置的值。

解决方法是将这些指令一起执行。中间不插入任何代码。

```
......
putNumber("targetAngle", 180.0);
putNumber("tragetPosition", 20);
putNumber("tragetSpeed", 10);
......
```

```
......
getNumber("targetAngle", 0);
getNumber("tragetPosition", 0);
getNumber("tragetSpeed", 0);
......
```

或者再使用一个临时的键值对 `isTransferred`，当数据全部设置完毕后设置为 `false`，仅在此时才能获取数据。

### (拓展) 使用 Python 操作 Networktables

我们使用这个开源项目操作 `Networktables`。[pynetworktables](https://github.com/robotpy/pynetworktables)

1.  安装 Python3
2.  将 Python 添加到环境变量中
3.  在命令提示符中运行 `pip install pynetworktables`。如果速度很慢请使用国内 pip 镜像。
4.  编写 Python 程序。    

    ```python
    from networktables import NetworkTable
    dashboard = NetworkTable.getTable('SmartDashboard')
    dashboard.putNumber('test', 2333)
    while True:
        pass
    ```

5.  保存为 `test.py`，在命令提示符中切换到当前目录，执行 `python test.py`。最后一个 `while` 循环保证数据录入后再退出程序。

## SmartDashboard

除了使用 `Networktables` 储存数据以外，`SmartDashboard` 利用 `Networktables`，
通过配置文件，可以方便地将储存在 `Networktables` 数据展示在屏幕上。
`SmartDashboard` 是机器人与计算机通讯的桥梁。

### 打开 SmartDashboard

安装 FRC Update Suites 之后，你就可以在 `<用户目录>/wpilib/tools` 中找到应用程序。

{% img '{{ "networking-roborio/smartdashboard-1.png" }}' %}

`OutlineViewer` 是一个 `Networktables` 的监视工具。你可以在这个应用里看到所有的 `Networktables` 数据。

`SmartDashboard` 是稳定的 `SmartDashboard` 版本。推荐在比赛时使用。

`sfx` 是一个美观大气但充满 BUG 的 `SmartDashboard` 程序。在调试时可以用它进行数据分析。

### 使用 SmartDashboard 显示调试数据

SmartDashboard 是一个静态类，可以使用其中的静态函数向 SmartDashboard 发送数据。

```java
    SmartDashboard.putNumber("TestData", 23333);
```

在指令执行过程中不断调用发送数据的指令，数据就会不断刷新。在 `SmartDashboard`
上将该数据设置成折线图格式，就可以显示出一段时间内的该数据点的所有数值。

### 为什么有 SmartDashboard 还要 Networktables?

`SmartDashboard` 是直接展现给操作员的面板，并且可以可视化展现调试数据。

而视觉处理、图像处理等的临时数据必须要存储在 `Networktables` 才能进行进一步展现和处理。
另外 `Networktables` 提供了事件订阅功能，可以在其中的键值对发生更改时接收到通知。

## 练习

1.  阅读 `SmartDashboard` 教程，学习如何查看现在运行的所有指令、现在 `DriveSubsystem` 子系统执行的指令，
    以及如何手动运行一个指令。
    ([教程](http://wpilib.screenstepslive.com/s/4485/m/26401/l/255422-displaying-the-status-of-commands-and-subsystems))
2.  阅读 `SmartDashboard` 教程，学习如何通过控制板选择自动阶段执行的指令。
    (关键: 添加 `SendableChooser` 到控制板, [教程](http://wpilib.screenstepslive.com/s/4485/m/26401))
3.  添加一个 `DebugSubsystem` 以及 `DebugCommand`，实现在机器人程序运行期间，不断向 `SmartDashboard` 写入一个随机数值。
    (提示: 在 `DebugCommand` 的 `execute` 函数中进行数据存放)
3.  通过 `Networktables` 读取 `Test` 表格中的三个数据 `speedMax`, `speedDelta` 和 `speedMin`。注意使用事务。
4.  在 DriverStation 的设置中将默认的调试面板改为 `SmartDashboard` (调成 Java 模式)。
5.  在 `Networktables` 中添加 `SubTable` 并存储数据 [文档](http://first.wpi.edu/FRC/roborio/release/docs/java/edu/wpi/first/wpilibj/networktables/NetworkTable.html)

请善用官方教程和 WPILib 文档：

[FRC Java Programming 在线版](http://wpilib.screenstepslive.com/s/4485/m/13809)

[SmartDashboard 教程 在线版](http://wpilib.screenstepslive.com/s/4485/m/26401)

[WPILib API Reference 在线版](http://first.wpi.edu/FRC/roborio/release/docs/java/)
