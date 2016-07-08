---
layout: post
title:  "手舞足蹈的 Xenial 星人 · 指令式机器人"
date:   2016-07-08 08:54:35 +0800
categories: programming
tags: zc大哥哥的编程干货 FRC@EFZ 机器人 Java
---

*SkyZH* 要对自己的机器人开始升级啦！因为之前的程序只能扫他扁平状的房间，而不能扫客厅，
因此他非常恼火。他想要让机器人自动扫大厅，但是又懒得写自动寻路算法。终于有一天，
他在 *X购物* 上购买的的 *Xperia* 手柄快递到家了！期待已久的他决定使用手柄控制机器人，
玩 *Xenial* 冲突累了的时候就可以让机器人扫地了。

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

*SkyZH* 于是决定稍微修改一下程序。
**（注意：以下几段代码中的部分函数，比如 `getSpeed` 和 `getDirection` 并不是官方 API 中的，但是一看到名字你就能明白它是干什么的）**

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

*SkyZH* 有一个很奇怪的习惯。他凭感觉将扫地机器人开到任意一个地方，按下扫地键后，他才会关注那里到底是什么。
如果机器人扫到他心爱的最新 *Xenialware* 笔记本电脑的话，他会很不开心的。因此松开 `1` 键后，机器人应该立刻停下扫地工作。
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
                if(button1.isHead()) {
                    servo.setAngle(0);
                    while(milliseconds() - __timer <= 1 && button1.isHeld());
                }
                servo.setAngle(180);
            }
            Timer.delay(0.02);
        }
    }
```

好麻烦啊！*SkyZH* 为了偷懒，决定采用指令式编程来解决这个问题。

## Xenial 星人的 INN

*Xenial* 星人通过名为 *INN* 的系统进行身体各个器官的通讯。
当 *Xenial* 星人想要起床时，*INN* 系统会从中心器官大脑向各个器官发送如下指令：

1. 腰部关节旋转到 90 度。（翻身，仰视）
2. 等待腰部旋转完成。
3. 腰关节旋转到 45 度。
4. 小腿关节旋转到 90 度。（由于 *INN* 发送指令的速度非常快，因此 3~4 可以被认为是同一时间发出的）
5. 等待 3~5 完成。
6. 开始转动 *XEN* 器官。
7. 等待两秒。
8. 停止 *XEN* 器官旋转。

{% img '{{ "command-based-robot/xenial-1.png" }}' %}

总之最后 *Xenial* 人就变成这个样子了。

我们把这个过程分解成如下几个指令：

1.  初始操作：让腰部关节横轴旋转到 90 度。    
    结束条件：腰部关节横轴已经旋转到 90 度了。
2.  初始操作：腰关节纵轴旋转到 45 度。    
    结束条件：已经旋转到了 45 度。
3.  初始操作：小腿关节旋转到 90 度。    
    结束条件：小腿已经旋转到 90 度了。
4.  初始操作：转动 *XEN* 器官。    
    结束条件：指令执行了两秒。    
    终止操作：停止旋转 *XEN* 器官。

`2`, `3` 并行，其他顺序执行。

{% img '{{ "command-based-robot/xenial-2.png" }}' %}

## 开始 Command-based Programming

*SkyZH* 想，我们也能利用这种 **指令系统** 完成上面的扫地机器人。
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

在 `subsystems` 包中右键新建，选择 `Others`。

{% img '{{ "command-based-robot/tutorial-5.png" }}' %}

双击 `Subsystem` 即可创建子系统。

扫地机器人上有一个很奇怪的部件叫做 `XEN`，它是一个可以 360 度旋转的天线，使用马达控制。
一般来说我们只需要它正传、反转、停止。因此我们可以这样抽象这个马达：

```java
public class XenSubsystem extends Subsystem {

    VictorSP xen = Robot.oi.xen;

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

接下来要在 OI 中创建 xen 对象。

```java
public class OI {
    VictorSP xen = new VictorSP(RobotMap.MotorXenPort);
}
```

最后在 RobotMap 中指定端口号。

```java
public class RobotMap {
    public static int MotorXenPort = 5;
}
```

在创建 XenSubsystem 对象后，我们就可以调用 `xen.forward()` 等函数了。
