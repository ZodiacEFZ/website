---		
layout: post		
title:  同步两个指令
date:   2016-08-27 11:17:14 +0800		
categories:
- programming
tags: 机器人 Java C++ 编程 翻译
showcase: translation-command-based
---

> 原文：[Synchronizing two commands](http://wpilib.screenstepslive.com/s/4485/m/13809/l/599743-synchronizing-two-commands)


指令可以使用指令组来组合。简单的指令被添加到指令组后，可以指定是顺序执行（一个接一个执行）还是并行执行（下一个指令和这个指令被同时开始执行）。偶尔我们需要两个并行指令完成以后执行下一个指令。这一篇文章里将会讲到。

---

## 创建一个顺序并行共存的指令组

```c++
// C++ Code

#include "CoopBridgeAutonomous.h"

CoopBridgeAutonomous::CoopBridgeAutonomous()
{
     // SmartDashboard->PutDouble("Camera Time", 5.0);
     AddSequential(new SetTipperState(READY_STATE);
     AddParallel(new SetVirtualSetpoint(HYBRID_LOCATION);
     AddSequential(new DriveToBridge());
     AddParallel(new ContinuousCollect());
     AddSequential(new SetTipperState(DOWN_STATE));

     // addParallel(new WaitThenShoot());

     AddSequential(new TurnToTargetLowPassFilterHybrid(4.0));
     AddSequential(new FireSequence());
     AddSequential(new MoveBallToShooter(true));
}
```

```java
// Java Code

public class CoopBridgeAutonomous extends CommandGroup {

    public CoopBridgeAutonomous() {
    	//SmartDashboard.putDouble("Camera Time", 5.0);
    	addSequential(new SetTipperState(BridgeTipper.READY_STATE)); // 1
    	addParallel(new SetVirtualSetpoint(SetVirtualSetpoint.HYBRID_LOCATION)); // 2
    	addSequential(new DriveToBridge()); // 3
    	addParallel(new ContinuousCollect());
    	addSequential(new SetTipperState(BridgeTipper.DOWN_STATE));

    	// addParallel(new WaitThenShoot());

    	addSequential(new TurnToTargetLowPassFilterHybrid(4.0));
    	addSequential(new FireSequence());
    	addSequential(new MoveBallToShooter(true));
    }
}
```

在这个例子里，一些指令并行，一些指令顺序执行。这些指令组成了指令组 `CoopBridgeAutonomous()` (1)。第一个指令 `SetTipperState` 在 `SetVirtualSetpoint` 开始前执行 (2)。在 `SetVirtualSetpoint` 指令完成前，`DriveToBridge` 指令立刻被调度了，因此两个指令同时执行。这个例子可以大概解释一下指令组是如何调度指令的。

## 流程图

{% img synchronizing-two-commands/1.png %}

以上的代码可以绘制成这样的流程图。请注意，并行添加的指令与之后的指令没有依赖关系。也就是说，即使现在已经在运行 `MoveBallToShooter` 指令了，并行的指令可能仍然在执行。主指令序列中（右侧的指令分支）的指令需要使用其他并行指令所需要的子系统时，并行指令才会被停止。比如，`FireSequence` 需要 `SetVirtualSetpoint` 指令所需要的子系统，那么 `SetVirtualSetpoint` 指令会在 `FireSequence` 指令被执行前才停止。

## 让一个指令等待之前的所有指令完成后执行

{% img synchronizing-two-commands/2.png %}

如果有一个顺序指令要等待两个并行指令完成后再执行，我们可以把用 `addParallel()` 这两个指令加到一个指令组里。接着这个指令组就能原先的指令组中作为顺序指令执行。这样的话，一个指令就可以等待多个并行指令全部结束后再执行了。

这个例子里 `Move to Bridge` 指令组包含了 `SetVirtualSetpoint` 和 `DriveToBridge` 两个指令。等到两个指令全部完成后，下一个顺序指令才会被执行。
