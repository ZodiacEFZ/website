---		
layout: post		
title:  创建指令组
date:   2016-08-25 22:24:18 +0800		
categories:
- programming
tags: 机器人 Java C++ 编程 翻译
showcase: translation-command-based
---

> 原文：[Creating groups of commands](http://wpilib.screenstepslive.com/s/4485/m/13809/l/599738-creating-groups-of-commands)

我们所创建的操纵机器人机械的指令，可以被组合在一起完成更复杂的行为。这种组合指令的方式非常简单，我们接下来将介绍它。

---

## 创建执行复杂行为的指令

```c++
// C++ Code

#include "PlaceSoda.h"

PlaceSoda::PlaceSoda()
{
	AddSequential(new SetElevatorSetpoint(TABLE_HEIGHT));
	AddSequential(new SetWristSetpoint(PICKUP));
	AddSequential(new OpenClaw());
}
```

```java
// Java Code
public class PlaceSoda extends CommandGroup {

    public PlaceSoda() {
    	addSequential(new SetElevatorSetpoint(Elevator.TABLE_HEIGHT));
    	addSequential(new SetWristSetpoint(Wrist.PICKUP));
    	addSequential(new OpenClaw());
    }
}
```

这是一个把易拉罐放在桌子上的例子。完成这个行为，需要：

1. 机器人升降装置提升到桌面高度以上
2. 机械手腕角度设置到合适位置
3. 张开机械爪

这些动作都要一个接一个执行以保证易拉罐不会掉下来。 `addSequential()` 方法将一个指令（或指令组）作为传参，在这个指令组执行时，这些指令就会一个接一个执行。

## 创建并行执行的指令组

```c++
// C++ Code

#include "PrepareToGrab.h"

PrepareToGrab::PrepareToGrab()
{
	AddParallel(new SetWristSetpoint(PICKUP));
	AddParallel(new SetElevatorSetpoint(BOTTOM));
	AddParallel(new OpenClaw());
}
```

```java
// Java Code

public class PrepareToGrab extends CommandGroup {

    public PrepareToGrab() {
    	addParallel(new SetWristSetpoint(Wrist.PICKUP));
    	addParallel(new SetElevatorSetpoint(Elevator.BOTTOM));
    	addParallel(new OpenClaw());
    }
}
```

为了让程序效率更高，我们经常需要把几个指令同时执行。在这个例子里，机器人要准备抓取一个易拉罐。因为机器人当前什么也没有抓住，所以所有的关节都可以同时移动而不需要像上面那个例子一样考虑易拉罐掉下来。所有的指令都并行执行，因此所有的马达都在同时运作，并且每个指令都在 `isFinished()` 返回真的时候结束。指令可以已任何顺序排列，步骤是：

1. 机械手腕角度设置到合适角度
2. 机器人升降装置提升到合适位置
3. 张开机械爪

## 混合使用并行和顺序指令

```c++
// C++ Code

#include "Grab.h"

Grab::Grab()
{
	AddSequential(new CloseClaw());
	AddSequential(new SetElevatorSetpoint(STOW));
	AddSequential(new SetWristSetpoint(STOW));
}
```

```java
// Java Code

public class Grab extends CommandGroup {

    public Grab() {
    	addSequential(new CloseClaw());
    	addParallel(new SetElevatorSetpoint(Elevator.STOW));
    	addSequential(new SetWristSetpoint(Wrist.STOW));
    }
}
```

有时一些指令需要在其他指令完成之后才能执行。在这个例子里，易拉罐被抓紧了，之后升降装置和机械手腕才可以移动到存放位置。在这个例子里，机械手腕和升降装置必须等到易拉罐被抓住以后才能移动，但这两个操作是可以同时执行的。因此：

1. 关闭机械爪，其他指令等待
2. 升降装置移动
3. 与此同时机械手腕移动
