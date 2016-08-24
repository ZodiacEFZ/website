---		
layout: post		
title:  PID 子系统
date:   2016-08-23 22:40:36 +0800		
categories:
- programming
tags: 机器人 Java C++ 编程 翻译
showcase: translation-command-based
---

> 原文：[PIDSubsystems for built-in PID control](http://wpilib.screenstepslive.com/s/4485/m/13809/l/599736-pidsubsystems-for-built-in-pid-control)

如果我们在编程时用到这样一个子系统：来自传感器的返回值直接用来控制电机的速度或位置，那么我们就可以使用 PID 子系统。可能会用到 PID 子系统的例子有：用电位器指定高度的升降装置，用编码器调整速度的射球装置，以及用电位器来确定旋转度数的机械手腕。

WPILib 中本来就有 `PIDController`，但是为了能够方便地在指令式编程中使用它，我们可以使用 `PIDSubsystem`。一个 PID 子系统其实就是一个内置了 `PIDController` 的子系统，并且提供了可以协调传感器和机械的成员方法。

```java
// Java code
package org.usfirst.frc.team1.robot.subsystems;
import edu.wpi.first.wpilibj.*;
import edu.wpi.first.wpilibj.command.PIDSubsystem;
import org.usfirst.frc.team1.robot.RobotMap;


public class Wrist extends PIDSubsystem { // 这个子系统继承自 PIDSubsystem

	Victor motor = RobotMap.wristMotor;
	AnalogInput pot = RobotMap.wristPot();

	public Wrist() {
		super("Wrist", 2.0, 0.0, 0.0); // 构造函数传递子系统名称和在计算输出时会用到的 P I D 三个参数。
		setAbsoluteTolerance(0.05);
		getPIDController().setContinuous(false);
	}

    public void initDefaultCommand() {
    }

    protected double returnPIDInput() {
    	return pot.getAverageVoltage(); // 这个函数作为子系统对于传感器参数的反馈。
    }

    protected void usePIDOutput(double output) {
    	motor.pidWrite(output); // 在这里执行 PID 传感器参数应用在电机上的程序。
    }
}
```
