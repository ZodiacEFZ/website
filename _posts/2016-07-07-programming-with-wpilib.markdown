---
layout: post
title:  "来自 Xenial 星的召唤 · FRC 机器人编程入门"
date:   2016-07-07 17:23:35 +0800
categories: programming
tags: zc大哥哥的编程干货 FRC@EFZ 机器人 Java
---

很久以前在 *Xenial* 星上住着一群懒虫。它们整天什么事情都不想干，只想坐在沙发上玩 *Xenial* 冲突。终于有一天 *Xenial* 星上的人们发现自己的家里太脏太乱了，于是决定开发一款基于 `wpilib` 的扫地机器人。一位名为 *SkyZH* 的 *Xenial* 星人自告奋勇跳出来说，我可以做出扫地机器人！*SkyZH* 真是一位勤劳勇敢的好同志。

可是好景不长，当他兴高采烈地搭好机器人底盘，设计好底盘上的设备的时候，发现自己不会写程序。

*SkyZH* 求助于聪明的你，希望你可以帮忙设计出这样的机器人。

----

## 创建机器人工程

{% img '{{ "programming-with-wpilib/create-project-1.png" }}' %}

打开 Eclipse，选择 `File` - `New` - `Others`

{% img '{{ "programming-with-wpilib/create-project-2.png" }}' %}

选择 `WPILib Robot Java Development` - `Robot Java Project`

{% img '{{ "programming-with-wpilib/create-project-3.png" }}' %}

填写项目名，选择 Sample Robot。

{% img '{{ "programming-with-wpilib/create-project-4.png" }}' %}

如果界面没有反应，点击左侧边栏上的放大键。

{% img '{{ "programming-with-wpilib/create-project-5.png" }}' %}

在 `Project Explorer` 中找到刚才创建项目中的 `Robot.java`

## 编写逻辑

新创建的机器人类中，删去多余的代码，有以下几个函数：

```java
public class Robot extends SampleRobot {

    public Robot() {
    }

    public void robotInit() {
    }

    public void autonomous() {
    }

    public void operatorControl() {
    }

    public void test() {
    }
}
```

`public Robot()` 是类的初始化函数。
`public void robotInit()` 是机器人的初始化函数。
`public void autonomous()` 是机器人自动驾驶时的执行逻辑。
`public void operatorControl()` 是机器人人工操控时的执行逻辑。

*SkyZH* 首先希望能够操控底盘，让机器人在他扁平状的卧室里直线行走。那么我们需要干这么几件事情：

1. 在 `Robot` 类中声明所需要的控制器。
2. 将控制器绑定在端口上。
3. 在 `autonomous()` 函数中编写逻辑。

机器人底盘通过 `RobotDrive` 类驱动。与此同时 *SkyZH* 的机器人采用的是 `VictorSP` 马达控制器。
**前左，前右，后左，后右马达分别对应端口 `1`, `2`, `3`, `4`。**

### 声明控制器

```java
public class Robot extends SampleRobot {
    RobotDrive myRobot;

    public Robot() {

```

### 绑定控制器

```java
public class Robot extends SampleRobot {
    RobotDrive myRobot;

    public Robot() {
        myRobot = new RobotDrive(new VictorSP(1), new VictorSP(3), new VictorSP(2), new VictorSP(4));
    }

```

注意：`RobotDrive` 初始化时的顺序是前左，后左，前右，后右。

这时我们发现 `VictorSP` 下出现了红线。这说明这句语句出了问题。我们可以点击左边的小灯泡让 Eclipse 自动解决。

{% img '{{ "programming-with-wpilib/bind-ctrl-1.png" }}' %}

双击 `Import VictorSP` 将没有包含的库包含进程序中。

{% img '{{ "programming-with-wpilib/bind-ctrl-2.png" }}' %}

### 编写逻辑

*SkyZH* 让机器人在房间里前进两秒，停两秒扫地，后退两秒，再停止两秒，不断循环。

```java
    public void autonomous() {
        myRobot.setSafetyEnabled(false);
        while(true) {
            myRobot.drive(1.0, 0);
            Timer.delay(2);
            myRobot.drive(0, 0);
            Timer.delay(2);
            myRobot.drive(-1.0, 0);
            Timer.delay(2);
            myRobot.drive(0, 0);
            Timer.delay(2);  
        }

    }

```

于是我们就写完了扫地机器人的行走程序啦！是不是很棒 QwQ。

## 燃烧 Xenial 初号！扫地吧！

*SkyZH* 说那就给这个机器人取个名字叫 *Xenial 初号* 吧。可是它还不能扫地啊。

扫帚的毛刷被固定在一个舵机上。让舵机不断转动就可以扫地了。舵机被接在端口 `5` 上。

### 声明控制器 & 绑定控制器

```java
public class Robot extends SampleRobot {
    RobotDrive myRobot;
    Servo servo;

    public Robot() {
        myRobot = new RobotDrive(new VictorSP(1), new VictorSP(3), new VictorSP(2), new VictorSP(4));
        myRobot.setExpiration(0.1);

        servo = new Servo(5);
    }

```

### 编写逻辑

在机器人停下脚步时调用舵机转向。使用 `Timer.delay()` 等待几秒，保证舵机转到底。

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

## 习题

1. 阅读 `wpilib` [API 文档](http://first.wpi.edu/FRC/roborio/release/docs/java/)，查找获取 `Servo` 现在的旋转角度的函数，将原来的 `Timer.delay(2)` ，改成使用 `while` 循环等待舵机转到指定角度。

2. 尝试绑定 `Joystick` 手柄，当手柄按钮按下时再开始扫地。相关文档可以在 [wpilib 官网](http://wpilib.screenstepslive.com/s/4485/m/13809/l/241881-joysticks) 或 *Java Programming Guide PDF* 中找到。
