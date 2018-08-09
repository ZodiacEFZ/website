---		
layout: post		
title:  使用限位开关限制行为
date:   2016-08-28 18:24:24 +0800		
categories:
- programming
tags: 机器人 Java C++ 编程 翻译
showcase: translation-command-based
---

> 原文：[Using limit switches to control behavior](http://wpilib.screenstepslive.com/s/4485/m/13809/l/599744-using-limit-switches-to-control-behavior)

限位开关常常用来限制机器人的机械幅度。虽然限位开关很好用，但是它只能获取一个方向上的移动状况。因此它们可以用来保证移动不超过限制，但不能控制接近限制时机械的速度。比如，一个旋转的机器人肩关节最好使用电位器和精准编码器控制。限位开关只能保证电位器无法使用时，这个机械不会坏掉。

## 限位开关提供了什么数据？

{% asset using-limit-switches-to-control-behavior/1.png %}

限位开关有“大概开启”和“大概关闭”两个输出。一般限位开关都被连接在 `Digital Input` 接口和地线上。电子输入端口有上拉电阻，保证限位开关开启时，输入是 1，限位开关关闭时，输入是 0（输入被连接到地线）。图中的限位开关有开启和关闭输出值。

## 轮询限位开关关闭

```c++
// C++ Code

#include "RobotTemplate.h"
#include "WPILib.h"

RobotTemplate::RobotTemplate()
{
     DigitalInput* limitSwitch;
}

void RobotTemplate::RobotInit()
{
     limitSwitch = new DigitalInput(1);
}

void RobotTemplate::operatorControl()
{
     while(limitSwitch->Get())
     {
          Wait(10);
     }
}
```

```java
// Java Code

import edu.wpi.first.wpilibj.DigitalInput;
import edu.wpi.first.wpilibj.SampleRobot;
import edu.wpi.first.wpilibj.Timer;

public class RobotTemplate extends SampleRobot {

	DigitalInput limitSwitch;

	public void robotInit() {
		limitSwitch = new DigitalInput(1);
	}

	public void operatorControl() {
		// 其他代码
		while (limitSwitch.get()) {
			Timer.delay(10);
		}
	}
}
```

我们可以写一个非常简单的小程序不断读取限位开关直到它的返回值从 1 (开启) 变为 0 (闭合)。但是我们的程序不可能在这个等待期间不干其他事情，比如要读取手柄输入。这个例子只是限位开关的最基本用法，程序等待时，其他事情不发生。

## 指令式编程等待限位开关闭合

```c++
// C++ Code

#include "ArmUp.h"

ArmUp::ArmUp()
{

}

void ArmUp::Initialize()
{
    arm.ArmUp();
}

void ArmUp::Execute()
{
}

void ArmUp::IsFinished()
{
    return arm.isSwitchSet();
}

void ArmUp::End()
{
    arm.ArmStop();
}

void ArmUp::Interrupted()
{
    End();
}
```

```java
// Java Code

package edu.wpi.first.wpilibj.templates.commands;

public class ArmUp extends CommandBase {
    public ArmUp() {
    }

    protected void initialize() {
        arm.armUp();
    }

    protected void execute() {
    }

    protected boolean isFinished() {
        return arm.isSwitchSet();
    }

    protected void end() {
        arm.armStop();
    }

    protected void interrupted() {
        end();
    }
}
```

指令一秒钟大概可以调用五十次 `execute()` 和 `isFinished()` 函数，也就是 20 毫秒的周期。一个根据限位开关操纵马达的指令可以在 `isFinished()` 函数中返回限位开关的值。如果达到极限，返回真，指令结束，停止马达。

*请注意，机械（这个例子里的机械臂）有惯性，不能立刻停止，所以保证一切正常一定要使机械臂慢速移动。*

## 使用计数器判断限位开关是否闭合

```c++
// C++ Code

#include "WPILIB.h"
#include "Arm.h"

DigitalInput* limitSwitch;
SpeedController* armMotor;
Counter* counter;

Arm::Arm()
{
	limitSwitch = new DigitalInput(1);
	armMotor = new Victor(1);
	counter = new Counter(limitSwitch);
}

bool Arm::IsSwitchSet()
{
    return counter->Get() > 0;
}

void Arm::InitializeCounter()
{
    counter->Reset();
}

void Arm::ArmUp()
{
    armMotor->Set(.5);
}

void Arm::ArmDown()
{
    armMotor->Set(-0.5);
}

void Arm::ArmStop()
{
    armMotor->Set(0);
}

void InitDefaultCommand()
{
}
```

```java
// Java Code

package edu.wpi.first.wpilibj.templates.subsystems;
import edu.wpi.first.wpilibj.Counter;
import edu.wpi.first.wpilibj.DigitalInput;
import edu.wpi.first.wpilibj.SpeedController;
import edu.wpi.first.wpilibj.Victor;
import edu.wpi.first.wpilibj.command.Subsystem;
public class Arm extends Subsystem {

    DigitalInput limitSwitch = new DigitalInput(1);
    SpeedController armMotor = new Victor(1);
    Counter counter = new Counter(limitSwitch);

    public boolean isSwitchSet() {
        return counter.get() > 0;
    }

    public void initializeCounter() {
        counter.reset();
    }

    public void armUp() {
        armMotor.set(0.5);
    }

    public void armDown() {
        armMotor.set(-0.5);
    }

    public void armStop() {
        armMotor.set(0.0);
    }
    protected void initDefaultCommand() {
    }
}
```

限位开关可能在机械移动过后关闭后又打开。如果闭合十分快的话，程序可能无法捕捉到限位开关关闭。一种替代方法就是用 `Counter` 对象捕捉限位开关的关闭。因为计数器在硬件中实现，所以不论限位开关关闭得多快，它都可以捕捉到并增加计数器的值。因此程序可以简单地判断，计数器是否增加了，并且执行其他程序。

上面的子系统使用计数器捕捉限位开关操作，等待计数器数值改变。限位开关闭合时，计数器会增加，指令就能捕捉到。

## 编写一个计数器判断限位开关闭合的指令

```c++
// C++ Code

#include "ArmUp.h"

ArmUp::ArmUp()
{
}

void ArmUp::Initialize()
{
	arm.InitializeCounter();
	arm.ArmUp();
}

void ArmUp::Execute()
{
}

bool ArmUp::IsFinished()
{
	return arm->IsSwitchSet();
}

void ArmUp::End()
{
	arm->ArmStop();
}

void ArmUp::Interrupted()
{
	End();
}
```

```java
// Java Code

package edu.wpi.first.wpilibj.templates.commands;

public class ArmUp extends CommandBase {

    public ArmUp() {
    }

    protected void initialize() {
        arm.initializeCounter();
        arm.armUp();
    }

    protected void execute() {
    }

    protected boolean isFinished() {
        return arm.isSwitchSet();
    }

    protected void end() {
        arm.armStop();
    }

    protected void interrupted() {
        end();
    }
}
```

指令执行前，初始化计数器，然后开始移动马达。在 `isFinished()` 函数中等待计数器数值改变。数值改变，机械臂停止。使用硬件计数器，一个限位开关即使开关得再快也能被程序捕捉到。
