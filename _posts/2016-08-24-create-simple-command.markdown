---		
layout: post		
title:  创建简单指令
date:   2016-08-24 23:20:08 +0800		
categories:
- programming
tags: 机器人 Java C++ 编程 翻译
showcase: translation-command-based
---

> 原文：[Creating Simple Commands](http://wpilib.screenstepslive.com/s/4485/m/13809/l/599737-creating-simple-commands)

这一篇文章讲了一个指令的基本格式，并且提供了使用手柄操纵底盘的指令的例子。

---

## 指令的基本格式

要实现一个指令，我们需要重载 WPILib `Command` 类的许多方法。大部分方法只需要保留默认就好，不需要重载。部分情况下我们需要编写灵活性较高的指令，可能就会用到这些方法。以下是一个基本指令的组成部分：

```c++
// C++ Code

#include "MyCommandName.h"

/*
 * 1.  构造函数：可以传入诸如“目标位置、角度”的参数。为了调试方便，最好在构造时定义
 *     一个指令名。它将会在调试时显示在 SmartDashboard 中。指令同时也要 require
 *     它需要用到的子系统。
 */
MyCommandName::MyCommandName() : CommandBase("MyCommandName")
{
	Requires(Elevator);
}

/*
 * 2.  Initialize() - 通过该方法建立指令。它会在指令每一次执行 (execute) 之前被
 *     调用。这里应该写入指令的初始化代码。
 */
void MyCommandName::Initialize()
{

}

/*
 * 3.  Execute() - 这个方法被周期性（大约 20 毫秒）调用，并且执行指令需要完成的行为。
 *     比如子系统要移动到某个位置，那么这个函数里就应该不断调用子系统的函数，来达到目
 *     标位置。当然部分情况下也可以在 initialize() 中设置好目标，留空 execute() 函数。
 */
void MyCommandName::Execute()
{

}

/*
 * 4. 如果指令不再需要执行，返回 true。
 */
bool MyCommandName::IsFinished()
{
	return false;
}

void MyCommandName::End()
{

}

void MyCommandName::Interrupted()
{

}
```

```java
// Java code

public class MyCommandName extends Command {

    /*
     * 1.  构造函数：可以传入诸如“目标位置、角度”的参数。为了调试方便，最好在构造时定义
     *     一个指令名。它将会在调试时显示在 SmartDashboard 中。指令同时也要 require
     *     它需要用到的子系统。
     */
    public MyCommandName() {
    	super("MyCommandName");
        requires(elevator);
    }

    /*
     * 2.  initialize() - 通过该方法建立指令。它会在指令每一次执行 (execute) 之前被
     *     调用。这里应该写入指令的初始化代码。
     */
    protected void initialize() {
    }

    /*
     * 3.  execute() - 这个方法被周期性（大约 20 毫秒）调用，并且执行指令需要完成的行为。
     *     比如子系统要移动到某个位置，那么这个函数里就应该不断调用子系统的函数，来达到目
     *     标位置。当然部分情况下也可以在 initialize() 中设置好目标，留空 execute() 函数。
     */
    protected void execute() {
    }

	/*
	 * 4. 如果指令不再需要执行，返回 true。
	 */
    protected boolean isFinished() {
        return false;
    }
}
```

## 简单的指令示范

这个例子实现了一个可以用手柄 `tank drive` 底盘的指令。

```c++
// C++ Code

#include "DriveWithJoysticks.h"
#include "RobotMap.h"

DriveWithJoysticks::DriveWithJoysticks() : CommandBase("DriveWithJoysticks")
{
	Requires(Robot::drivetrain); // Drivetrain 是底盘子系统的一个对象（实例）
}

// 指令被运行前执行
void DriveWithJoysticks::Initialize()
{

}

/*
 * execute() - 在这个方法里调用子系统 tankDrive 的方法。这个方法需要传递两个从 OI
 * 类中获取到的手柄的速度参数。 OI 抽象了手柄对象，因此可以极大方便改变速度来源。
 * （比如如果我们需要让手柄不要那么敏感，我们可以在 OI 里把速度乘上 0.5。）
 */
void DriveWithJoysticks::Execute()
{
	Robot::drivetrain->Drive(Robot::oi->GetJoystick());
}

/*
 * isFinished() - 这个方法始终返回 false，这意味着指令永远不会自己要求停止，这样
 * 的话，我们就可以把指令设置为子系统的默认指令，只要子系统不运行其他指令，那么这个
 * 指令就会被持续执行。如果其他指令的执行中断了这个指令，那么这个指令会在其他指令执
 * 行完成以后继续执行。
 */
bool DriveWithJoysticks::IsFinished()
{
	return false;
}

void DriveWithJoysticks::End()
{
	Robot::drivetrain->Drive(0, 0);
}

// 在其他指令需要使用底盘子系统时中断本指令。
void DriveWithJoysticks::Interrupted()
{
	End();
}
```

```java
// Java Code
public class DriveWithJoysticks extends Command {

    public DriveWithJoysticks() {
    	requires(drivetrain); // Drivetrain 是底盘子系统的一个对象（实例）
    }

    protected void initialize() {
    }

    /*
     * execute() - 在这个方法里调用子系统 tankDrive 的方法。这个方法需要传递两个从 OI
     * 类中获取到的手柄的速度参数。 OI 抽象了手柄对象，因此可以极大方便改变速度来源。
     * （比如如果我们需要让手柄不要那么敏感，我们可以在 OI 里把速度乘上 0.5。）
     */
    protected void execute() {
    	drivetrain.tankDrive(oi.getLeftSpeed(), oi.getRightSpeed());
    }

    /*
     * isFinished() - 这个方法始终返回 false，这意味着指令永远不会自己要求停止，这样
     * 的话，我们就可以把指令设置为子系统的默认指令，只要子系统不运行其他指令，那么这个
     * 指令就会被持续执行。如果其他指令的执行中断了这个指令，那么这个指令会在其他指令执
     * 行完成以后继续执行。
     */
    protected boolean isFinished() {
        return false;
    }

    protected void end() {
    }

    protected void interrupted() {
    }
}
```
