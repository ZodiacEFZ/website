---		
layout: post		
title:  简单子系统
date:   2016-08-23 11:40:36 +0800		
categories:
- command-based programming
- programming
tags: 机器人 Java 编程 翻译
---

> 原文：[Creating a robot project](http://wpilib.screenstepslive.com/s/4485/m/13809/l/599733-creating-a-robot-project)

## 创建子系统

```java
// Java code

package org.usfirst.frc.team1.robot.subsystems;

import edu.wpi.first.wpilibj.*;
import edu.wpi.first.wpilibj.command.Subsystem;
import org.usfirst.frc.team1.robot.RobotMap;

public class Claw extends Subsystem {

	Victor motor = RobotMap.clawMotor;

    public void initDefaultCommand() {
    }

    public void open() {
    	motor.set(1);
    }

    public void close() {
    	motor.set(-1);
    }

    public void stop() {
    	motor.set(0);
    }
}
```

这是一个很简单的控制机械爪子系统。在这个例子中，机械爪使用一个马达驱动张开或关闭，并且没有使用任何传感器（我们可以用这个例子练习编程，但是请不要在实际中这么设计机械爪）。机械爪张开和关闭的程度是计时实现的。三个方法 `open()` `close()` `stop()` 可以驱动机械爪的马达。请注意，这里没有任何代码可以确认机械爪是否真的张开或关闭了。`open()` 方法调用时，机械爪向打开的方向移动。`close()` 方法使机械爪往关闭的方向移动。我们可以使用指令来控制机械爪究竟要花多少时间张开关闭。

## 使用指令操纵机械爪

```java
// Java code

package org.usfirst.frc.team1.robot.commands;

import edu.wpi.first.wpilibj.command.Command;
import org.usfirst.frc.team1.robot.Robot;
/**
 *
 */
public class OpenClaw extends Command {

    public OpenClaw() {
        requires(Robot.claw);
        setTimeout(.9);
    }

    protected void initialize() {
    	Robot.claw.open()
    }

    protected void execute() {
    }

    protected boolean isFinished() {
        return isTimedOut();
    }

    protected void end() {
    	Robot.claw.stop();
    }

    protected void interrupted() {
    	end();
    }
}
```

指令可以帮助我们设置每个子系统操作的时间。多个指令可以使用一个子系统完成多个行为。机械爪就是一个例子。指令可以设置机械爪张开或关闭的时间参数。比如上面的指令就控制了机械爪张开。请注意，我们在这个指令中用 `setTimeout` 函数设置了指令的执行时间为 0.9 秒。最后要在 `isFinished()` 函数中判断是否到达了指定时间。关于如何使用指令，请参见“使用指令”这篇文章。
