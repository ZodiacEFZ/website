---
layout: post
title:  "手舞足蹈的 Xenial 星人 · 指令式机器人"
date:   2016-07-08 08:54:35 +0800
categories: programming
tags: zc的编程干货 机器人 Java 编程
---

SkyZH 要对自己的机器人开始升级啦！因为之前的程序只能扫他扁平状的房间，而不能扫客厅，
因此他非常恼火。他想要让机器人自动扫大厅，但是又懒得写自动寻路算法。终于有一天，
他在 X购物 上购买的的 Xperia 手柄快递到家了！期待已久的他决定使用手柄控制机器人，
玩 Xenial 冲突累了的时候就可以让机器人扫地了。

上次自动控制的代码是这个样子的：

```java
    public void autonomous() {
        myRobot.setSafetyEnabled(false);
        while(true) {
            myRobot.drive(1.0, 0);
            Timer.delay(2);
            myRobot.drive(0, 0);
            servo.setAngle(0);
            Timer.delay(2);
            servo.setAngle(180);
            Timer.delay(2);
            myRobot.drive(-1.0, 0);
            Timer.delay(2);
            myRobot.drive(0, 0);
            servo.setAngle(0);
            Timer.delay(2);
            servo.setAngle(180);
            Timer.delay(2);
        }

    }
```

SkyZH 于是决定稍微修改一下程序。
**（注意：以下几段代码中的部分函数，比如 `getSpeed` 和 `getDirection` 并不是官方 API 中的，这是胡编乱造的。 o(^▽^)o）**

```java
    public void autonomous() {
        myRobot.setSafetyEnabled(false);
        while(true) {
            myRobot.drive(joystick.getSpeed(), joystick.getDirection());
            Timer.delay(0.02);
        }

    }
```

机器人要在按住手柄上的 `1` 键时停下，并开始扫地。

```java
    public void autonomous() {
        myRobot.setSafetyEnabled(false);
        while(true) {
            myRobot.drive(joystick.getSpeed(), joystick.getDirection());
            if(button1.isHeld()) {
                myRobot.drive(0, 0);
                servo.setAngle(180);
                Timer.delay(1);
                servo.setAngle(0);
                Timer.delay(1);
                servo.setAngle(180);
            }
            Timer.delay(0.02);
        }

    }
```

SkyZH 有一个很奇怪的习惯。他凭感觉将扫地机器人开到任意一个地方，按下扫地键后，他才会关注那里到底是什么。
如果机器人扫到他心爱的最新 Xenialware 笔记本电脑的话，他会很不开心的。因此松开 `1` 键后，机器人应该立刻停下扫地工作。
`milliseconds()` 可以获取到程序运行的毫秒数，**但官方文档并没有这个函数**。


```java
    public void autonomous() {
        myRobot.setSafetyEnabled(false);
        while(true) {
            myRobot.drive(joystick.getSpeed(), joystick.getDirection());
            if(button1.isHeld()) {
                myRobot.drive(0, 0);
                servo.setAngle(180);
                int __timer = milliseconds();
                while(milliseconds() - __timer <= 1 && button1.isHeld());
                if(button1.isHeld()) {
                    servo.setAngle(0);
                    while(milliseconds() - __timer <= 2 && button1.isHeld());
                }
                servo.setAngle(180);
            }
            Timer.delay(0.02);
        }
    }
```

好麻烦啊！SkyZH 为了偷懒，决定采用指令式编程来解决这个问题。

## Xenial 星人的 INN

Xenial 星人通过名为 INN 的系统进行身体各个器官的通讯。
当 Xenial 星人想要起床时，INN 系统会从中心器官大脑向各个器官发送如下指令：

1. 腰部关节旋转到 90 度。（翻身，仰视）
2. 等待腰部旋转完成。
3. 腰关节旋转到 45 度。
4. 小腿关节旋转到 90 度。（由于 INN 发送指令的速度非常快，因此 3~4 可以被认为是同一时间发出的）
5. 等待 3~5 完成。
6. 开始转动 XEN 器官。
7. 等待两秒。
8. 停止 XEN 器官旋转。

{% img '{{ "command-based-robot/xenial-1.png" }}' %}

总之最后 Xenial 人就变成这个样子了。

我们把这个过程分解成如下几个指令：

1.  初始操作：让腰部关节横轴旋转到 90 度。    
    结束条件：腰部关节横轴已经旋转到 90 度了。
2.  初始操作：腰关节纵轴旋转到 45 度。    
    结束条件：已经旋转到了 45 度。
3.  初始操作：小腿关节旋转到 90 度。    
    结束条件：小腿已经旋转到 90 度了。
4.  初始操作：转动 XEN 器官。    
    结束条件：指令执行了两秒。    
    终止操作：停止旋转 XEN 器官。

`2`, `3` 并行，其他顺序执行。

{% img '{{ "command-based-robot/xenial-2.png" }}' %}

## 开始 Command-based Programming

SkyZH 想，我们也能利用这种 **指令系统** 完成上面的扫地机器人。
于是他决定把这些资料交给你，让你帮忙完成这个程序。

`wpilib` 提供了一整套 Command-based 的类与函数，可以帮助你使用指令来编写机器人程序。

这个工程中最重要的两个基类就是 `Command/CommandGroup` 和 `Subsystem`。

我们创建新工程来慢慢学习。

### 入门

打开 Eclipse，创建 `Robot Java Project`。

{% img '{{ "command-based-robot/tutorial-1.png" }}' %}

在 `robot` 包中有三个类：

{% img '{{ "command-based-robot/tutorial-2.png" }}' %}

`Robot` 类是机器人的引导类。通过 `Robot` 可以控制自动期间、手动期间所需要执行的指令。

{% img '{{ "command-based-robot/tutorial-3.png" }}' %}

`RobotMap` 类是一个常量类，在这里写入每种控制器或传感器的端口号，这样在创建对象时就不用记录端口号了。
比如 `Servo servo = new Servo(RobotMap.CleanerServoPort);` 另外在调试时也可以方便地更改端口号。

{% img '{{ "command-based-robot/tutorial-4.png" }}' %}

`OI` 类里保存了机器人所有传感器控制器的对象。在 `Robot` 类初始化时会创建一个 `OI` 对象，
我们可以通过 `OI` 直接访问到机器人的所有设备。注意：`RobotMap` 储存端口号，
而 `OI` 中才真正创建了 `Servo`, `RobotDrive` 等可以通过程序操控的对象。

### Subsystem (子系统)

子系统绑定了机器人的各个部件，比如马达、舵机，并把它抽象成机械臂、发射塔等装置，提供更加简单接口。

在 `org.usfirst.frc.teamxxxx.robot.subsystems` 包中右键新建，选择 `Others`。

{% img '{{ "command-based-robot/tutorial-5.png" }}' %}

双击 `Subsystem` 即可创建子系统。

扫地机器人上有一个很奇怪的部件叫做 `XEN`，它是一个可以 360 度旋转的天线，使用马达控制。
一般来说我们只需要它正转、反转、停止。因此我们可以这样抽象这个马达：

```java
public class XenSubsystem extends Subsystem {

    VictorSP xen = new VictorSP(RobotMap.MotorXenPort);

    public void initDefaultCommand() {
    }

    public void forward() {
    	xen.set(1);
    }

    public void backward() {
    	xen.set(-1);
    }

    public void stop() {
    	xen.set(0);
    }
}
```

最后在 `RobotMap` 中指定端口号。

```java
public class RobotMap {
    public static int MotorXenPort = 5;
}
```

在创建 `XenSubsystem` 对象后，我们就可以调用 `xen.forward()` 等函数了。在 `Robot` 中创建 `Subsystem`。

```java
public class Robot extends IterativeRobot {

	public static final XenSubsystem xenSubsystem = new XenSubsystem();
```

### Command (指令)

我们可以使用指令控制子系统。在 `org.usfirst.frc.teamxxxx.robot.commands` 包中右键新建，选择 `Others`。
选择 `Command`，输入名称即可创建指令。

```java
public class XenCommand extends Command {

    public XenCommand() {
    }

    protected void initialize() {
    }

    protected void execute() {
    }

    protected boolean isFinished() {
        return false;
    }

    protected void end() {
    }

    protected void interrupted() {
    }
}
```

在 `XenCommand` 中有以下几个成员函数。

`XenCommand()` 是类的构造函数。在这里使用 `requires(...)` 声明这个类所需要的子系统。

`initialize()` 是初始化函数。第一次运行这个指令时会执行它。

*为什么又要初始化函数又要构造函数？类在创建对象时，机器人的各个部件可能还没有初始化好。
要等机器人的事件系统完全运行时才能初始化。*

`execute()` 指令执行过程中不断调用这个函数。

`isFinished()` 用于判断指令是否结束了。一般这里可以写“角度大于 180”或“时间到了”之类的语句。

`end()` 是指令执行完毕后需要调用的函数。

`interrupted()` 是指令被中断时调用的函数。比如手柄按钮按住时执行一个指令，指令没有执行完就松开了手柄，就会调用它。

`XenCommand` 要实现 XEN 的转动。我们将这一操作抽象成 `Command`:

初始操作：转动 XEN 器官。    
结束条件：指令执行了两秒。    
终止操作：停止旋转 XEN 器官。

可以使用 `setTimeout(double seconds)` 设定定时器，`isTimedOut()` 判断是否到时间。

```java
public class XenCommand extends Command {

    public XenCommand() {
        requires(Robot.xenSubsystem); //声明依赖
    }

    protected void initialize() {
    	setTimeout(2);
    	Robot.xenSubsystem.forward();
    }

    protected void execute() {
    }

     protected boolean isFinished() {
        return isTimedOut();
    }

    protected void end() {
    	Robot.xenSubsystem.stop();
    }


    protected void interrupted() {
    }
}
```

最后在 `Robot` 中将这个指令设定为自动阶段的默认指令。

```java
    public void autonomousInit() {
        autonomousCommand = new XenCommand();
        autonomousCommand.start();
    }
```

### 最后的话

FRC 机器人的 Command-based Robot 模式在国外的队伍中广泛使用。它的模块化、组件化的特点使得程序架构变得清楚，维护起来也更加方便。

除了 `Robot` 引导机器人主程序，`OI` 保存机器人所有的手柄相关设置，`RobotMap` 保存所有常量、端口映射以外，
`Subsystem` 提供了抽象的功能，可以将一个控制器原来的十几个函数变成所需要的几个甚至一个函数，并增加可读性。
(比如将 `VictorSP` 抽象为 `XenSubsystem`)。而 `Command` 提供了操作 `Subsystem` 的可能，
使得我们可以通过发送指令的方式**非阻塞地**执行命令，并且轻松地执行命令组。

UPDATE: 由于 `OI` 对象创建时机器人还没有完全初始化完毕，因此传感器、控制器对象直接在 `Subsystem` 中创建。相关代码已修改。

## 练习

1.  自学 `CommandGroup`。创建一个指令组，让 `XEN` 正转两秒，反转两秒。    
    [教程](http://wpilib.screenstepslive.com/s/4485/m/13809/l/241903-creating-groups-of-commands)
    [文档](http://first.wpi.edu/FRC/roborio/release/docs/java/edu/wpi/first/wpilibj/command/CommandGroup.html)
2.  创建一个待机指令，相当于 `Timer.delay()`，让 `XEN` 正转两秒，停两秒，反转两秒。    
    提示：想一想如何将一个操作抽象成 `Command`? 一个 `Command` 要有哪些要素？
3.  修改这个待机指令的构造函数，使得创建指令对象时可以指定待机指令的待机时长。让 `XEN` 正转两秒，停两秒，反转两秒，停三秒，正转两秒。        
    提示：最后应该有这两句语句 `addSequential(new SuspendCommand(2))` `addSequential(new SuspendCommand(3))`
4.  自行查阅 `Subsystem` 相关文档，让 `XenSubsystem` 在没有任何指令执行的情况下执行一个默认指令 (Default Command)，让 XEN 反转。
5.  尝试添加更多的控制器，比如底盘。    
    提示：回忆一下创建一个控制器需要依次更改哪些类？创建一个指令需要依次更改哪些类？
5.  学习使用并行执行指令组 (Parallel)，实现 `XEN` 正方向转动两秒的同时让扫地机器人的底盘行走。
6.  (选做) 尝试自己阅读传感器相关文档，创建一个基于陀螺仪 (Gyro) 的 `PIDSubsystem`。    
    提示：`WPILib sensors` 章节中讲传感器的用法，而 `PIDSubsystem` 将如何创建传感器的子系统。
7.  (选做) 添加底盘的默认指令，添加手柄，默认情况下底盘用手柄控制。

请善用下列资料：

[Java Programming Guide - Command-based Programming 在线版](http://wpilib.screenstepslive.com/s/4485/m/13809/c/88893)

[WPILib API Reference 在线版](http://first.wpi.edu/FRC/roborio/release/docs/java/)

第一个文档有 PDF 版。第二个文档可以在 Eclipse 中展开 `WPILib` 包查看。

{% img '{{ "command-based-robot/api-reference-1.png" }}' %}
