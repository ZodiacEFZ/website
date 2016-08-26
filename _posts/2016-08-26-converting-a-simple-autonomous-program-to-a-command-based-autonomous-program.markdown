---		
layout: post		
title:  将顺序自动程序转换成指令式自动程序
date:   2016-08-26 22:31:06 +0800		
categories:
- programming
tags: 机器人 Java C++ 编程 翻译
showcase: translation-command-based
---

> 原文：[Converting a Simple Autonomous program to a Command based autonomous program](http://wpilib.screenstepslive.com/s/4485/m/13809/l/599741-converting-a-simple-autonomous-program-to-a-command-based-autonomous-program)

## 含有循环的代码

```c++
// C++ / Java Code

// 瞄准
SetTargetAngle();                   // 初始化：准备需要执行的操作
while (!AtRightAngle()) {           // 条件：满足条件时循环一直执行
	CorrectAngle();                 // 执行：不断执行操作直到循环条件不成立
	delay();                        // 延时防止过高 CPU 占用
}
HoldAngle();                        // 结束：执行扫尾操作，为其他操作准备

// 加速飞轮
SetTargetSpeed();                   // 初始化：准备需要执行的操作
while (!FastEnough()) {             // 条件：满足条件时循环一直执行
	SpeedUp();                      // 执行：不断执行操作直到循环条件不成立
	delay();                        // 延时防止过高 CPU 占用
}
HoldSpeed();

// 飞盘射击
Shoot(); // 结束：执行扫尾操作，为其他操作准备
```

以上代码先瞄准，然后加速飞轮，最后在理想速度时把飞盘射出。代码包含了三个不同的行为：瞄准，加速飞轮，以及射击。前两个动作符合指令的四要素：

1. 初始化：准备需要执行的操作。
2. 条件：满足条件时循环一直执行。
3. 执行：不断执行操作直到循环条件不成立。
4. 结束：执行扫尾操作，为其他操作准备。

即使我们认为最后一个行为不需要手动结束，只要一个初始化操作就行了，但我们也要严格地加上一个结束条件。最明显的结束条件就是完成了发射任务，或者自动阶段已经结束。

## 重写为指令

```c++
// C++ Code

#include "AutonomousCommand.h"

AutonomousCommand::AutonomousCommand()
{
     AddSequential(new Aim());
     AddSequential(new SpinUpShooter());
     AddSequential(new Shoot());
}
```

```java
// Java Code

public class AutonomousCommand extends CommandGroup {

    public AutonomousCommand() {
    	addSequential(new Aim());
    	addSequential(new SpinUpShooter());
    	addSequential(new Shoot());
    }
}
```

我们可以使用指令组将操作组合起来，每个操作都再定义一个自己的指令。首先，编写指令组，接着再分别写三个指令。这个代码十分简洁明了，它将会一个接一个完成三个指令。第三行瞄准，第四行加速飞轮，第五行设计。`addSequential()` 方法使得这些指令一个接一个按次序执行。

## 瞄准指令

```c++
// C++ Code

#include "Aim.h"

Aim::Aim()
{
     Requires(Robot::turret);
}

// 指令运行前调用
void Aim::Initialize()
{
    SetTargetAngle();
}

// 指令执行时不断调用
void Aim:Execute()
{
    CorrectAngle();
}

// 指令不需要再执行时返回真
bool Aim:IsFinished()
{
    return AtRightAngle();
}

// IsFinished() 返回假后调用一次
void Aim::End()
{
     HoldAngle();
}

// 当其他指令需要使用这个指令使用的子系统时调用
void Aim:Interrupted()
{
     End();
}
```

```java
// Java Code

public class Aim extends Command {

    public Aim() {
    	requires(Robot.turret);
    }

    // 指令运行前调用
    protected void initialize() {
    	SetTargetAngle();
    }

    // 指令执行时不断调用
    protected void execute() {
    	CorrectAngle();
    }

    // 指令不需要再执行时返回真
    protected boolean isFinished() {
        return AtRightAngle();
    }

    // IsFinished() 返回真后调用一次
    protected void end() {
    	HoldAngle();
    }

    // 当其他指令需要使用这个指令使用的子系统时调用
    protected void interrupted() {
    	end();
    }
}
```

这个指令就是以之前我们提到的四个要素来构建的。它还有一个 `interrupted()` 方法，我们将在之后讨论。另外需要注意的是，`isFinished()` 的返回值恰好和循环条件相反，返回真指令停止，返回假继续执行。初始化、执行、扫尾和之前提到的一样，按照各自的需求编写就行了。

## 飞轮加速指令

```c++
// C++ Code

#include "SpinUpShooter.h"

SpinUpShooter::SpinUpShooter()
{
     Requires(Robot::shooter)
}

void SpinUpShooter::Initialize()
{
    SetTargetSpeed();
}

void SpinUpShooter::Execute()
{
    SpeedUp();
}

bool SpinUpShooter::IsFinished()
{
    return FastEnough();
}

void SpinUpShooter::End()
{
    HoldSpeed();
}

void SpinUpShooter::Interrupted()
{
    End();
}
```

```java
// Java Code

public class SpinUpShooter extends Command {

    public SpinUpShooter() {
        requires(Robot.shooter);
    }

    protected void initialize() {
    	SetTargetSpeed();
    }

    protected void execute() {
    	SpeedUp();
    }

    protected boolean isFinished() {
        return FastEnough();
    }

    protected void end() {
    	HoldSpeed();
    }

    protected void interrupted() {
    	end();
    }
}
```


飞轮加速指令的编写和瞄准指令极为类似。

## 发射指令

```c++
// C++ Code

#include "Shoot.h"

Shoot::Shoot()
{
     Requires(Robot.shooter);
}

void Shoot::Initialize()
{
    Shoot();
}

void Shoot::Execute()
{
}

bool Shoot::IsFinished()
{
    return true;
}

void Shoot::End()
{
}

void Shoot::Interrupted()
{
    End();
}
```

```java
// Java Code

public class Shoot extends Command {

    public Shoot() {
        requires(shooter);
    }

    protected void initialize() {
    	Shoot();
    }

    protected void execute() {
    }

    protected boolean isFinished() {
        return true;
    }

    protected void end() {
    }

    protected void interrupted() {
    	end();
    }
}
```

发射指令的编写和之前不尽相同。但是它被设置成立刻结束。在指令式编程中，这种情况下最好是让 `isFinished()` 直接返回真表示指令不需要再进一步执行了。相对于之前的几个指令，这个指令的编写更直接。

## 指令式编程的好处

为什么要用指令式编程重写之前的代码？指令式编程有如下好处：

* 重用性：我们可以在自动阶段和手动阶段重用同样的指令。由于用到这个指令的地方，实际上都是同一个类的实例，因此如果我们需要修改或修复一个指令的代码，我们只要在一个地方修改就行了，不需要再几个地方都改一遍。
* 可测试性：我们可以用 SmartDashboard 单独测试一个指令。把指令组合在一起时，我们可以更加放心。
* 并行性：如果我们需要让瞄准和加速同时进行，使用指令式编程就非常简单了。只要在加入瞄准指令时用 `AddParallel()` 替换 `AddSequential()`，瞄准加速就能同时进行。
* 可中断性：指令可以被中断，这样我们就能在不需要某个指令继续执行时把它提前结束。同样的需求在循环中很难实现。
