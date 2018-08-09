---		
layout: post		
title:  指令调度
date:   2016-08-28 16:28:47 +0800		
categories:
- programming
tags: 机器人 Java C++ 编程 翻译
showcase: translation-command-based
---

> 原文：[Scheduling commands](http://wpilib.screenstepslive.com/s/4485/m/13809/l/599745-scheduling-commands)

指令会在事件触发、没有其他指令运行的子系统上默认指令、指令组中的指令、按钮按下、自动阶段等情况下被调度执行。即使许多指令可能看起来在并行运行，但是所有的指令都运行在一个线程（主机器人线程）中。这可以减少线程同步的种种困难。线程可能在 PID 循环、机器人通讯的地方用到。但是这些线程都不需要和主线程不断同步。这使得机器人程序更加稳定。

这些操作都由调度器 `Scheduler` 类实现。它有一个 `run()` 方法被周期性执行（一般就以 Driver Station 的更新频率执行，即每 20 毫秒一次），会处理所有正在执行的指令。这个操作由调用指令的 `execute()` 和 `isFinished()` 方法实现。如果 `isFinished()` 返回真，那么指令就会被标记为“将被删除”，并且在下一个周期把它移除。如果有很多指令同时运行，那么 `Scheduler.run()` 方法调用时，所有指令的 `execute()` 和 `isFinished()` 方法都会被调用。这和用多线程并没有什么区别。

---

## 剖析指令式程序

{% asset scheduling-commands/1.png %}

这里展示了一个典型的指令式机器人程序的代码。`Scheduler.run()` 方法可以调用所有正在执行的指令的 `execute()` 和 `isFinished()` 方法。请忽略 Java 例子中的 `log()` 方法。

## `Scheduler.run` 方法：指令生命周期

{% asset scheduling-commands/2.png %}

这些行为不论在 C++ `Scheduler.Run()` 的指令式程序中还是 Java `Scheduler.run()` 的指令式程序中都会调用。这些行为也会在 Driver Station 以 20 毫秒或 50 毫秒为周期刷新的时候执行。下面的伪代码说明了每次调用 `run()` 方法的时候会发生什么。

1. 按钮和触发器事件被不断询问，来判断是否有相关的指令需要被调度。如果触发器为真，指令被添加到即将执行的队列里。
2. 枚举所有正在运行指令，调用它们的 `execute()` 和 `isFinished()` 函数。已经结束的指令会从正在执行指令的列表中移除。
3. 把第一步即将执行队列里的指令，添加到正在执行的列表中。
4. 对空闲的子系统，向正在执行的列表中添加默认指令。

## 优化指令组

```c++
// C++ Code

Pickup::Pickup() : CommandGroup("Pickup") {
    AddSequential(new CloseClaw());
    AddParallel(new SetWristSetpoint(-45));
    AddSequential(new SetElevatorSetpoint(0.25));
}
```

```java
// Java Code

public class Pickup extends CommandGroup {
    public Pickup() {
    	addSequential(new CloseClaw());
    	addParallel(new SetWristSetpoint(-45));
    	addSequential(new SetElevatorSetpoint(0.25));
    }
}
```

一旦我们编写好了机器人某个机械操控的指令，我们可以把这些指令合并起来组成一个指令组完成更复杂的动作。加入指令组的指令可以被顺序执行或者并行执行。顺序执行的指令在执行完成后才会执行之后的指令。并行指令开始执行后，下一个指令立刻会被调度。

很重要的一点是，添加到指令组中的指令必须在指令组的构造函数内添加。指令组只是一个由几个指令实例组成的类，帮助协调下属指令的执行。因此所有与指令组相关的参数都必须在构造函数内指定完成。

想象机器人设计中，有一个机械爪，连接到机械手腕关节，全部都放在一个升降装置上。当我们想要捡起某个东西时，机械爪需要先接近目标，然后升降装置和机械手腕才能启动，否则物体就会从机械爪上掉出来。这个例子里，`CloseClaw` 指令会先执行，执行完毕后，机械手腕会移动到指定位置，与此同时升降装置移动。这个可以使得机械手腕和升降装置同时移动，加速任务完成时间。

## 指令组什么时候结束？

{% asset scheduling-commands/3.png %}

指令组在组合中所有启动的指令结束以后结束，不论指令是并行还是顺序添加的。比如很多指令都以顺序或者并行的方式被添加进来，指令组在这些指令全部完成以后结束。每个添加的指令被放在一个列表中。这些子指令执行完毕了，会从列表中移除。指令组在列表空时退出结束。

在上面的拾起指令中，指令组会在 `CloseClaw`, `SetWristSetpoint` 和 `SetElevatorSetpoint` 指令全部完成后退出。不论指令是顺序添加的还是并行添加的。

## 如何在现在执行的指令里开始其他的指令？

指令可以通过 Java 中 `schedule()` 方法，或者 C++ 中 `Schedule()` 方法在指令实例中被调度。这可以使得新添加的指令被加入调度器当前即将执行的指令列表中。这个功能在程序需要在某些条件下在某个指令中调用其他指令时十分有用。新调度的指令会被添加到新指令列表中。这些指令会在下一次调度器刷新时执行。新创建的指令不会在和添加时的同一个周期中执行。它会在下一次 `Scheduler.run()` 时（大约 20 毫秒后）执行。

## 从调度器中移除所有正在执行的指令

```c++
// C++ Code

Scheduler::RemoveAll();
```

```java
// Java Code

Scheduler.getInstance().removeAll();
```

偶尔我们需要保证调度器中没有指令执行。使用 Java 中 `Scheduler.removeAll()` 函数或者 C++ 中 `Scheduler::RemoveAll()` 函数可以移除所有指令。这会使得现在正在执行的所有指令的 `interrupted()` 方法 (Java) 或者 `Interrupted()` 方法 (C++) 被调用。还没有开始的指令会直接调用它们的 `end()` 方法 (Java) 或 `End()` 方法 (C++)。

## `requires()` 方法有什么用？

{% asset scheduling-commands/4.png %}

如果有许多指令需要同一个子系统才能执行，我们不能让这些指令同时执行。比如，机械爪系统有 `OpenClaw` 和 `CloseClaw` 两个指令需要。它们不能同时运行。每个需要用到机械爪子系统的指令都要在构造函数中 **1 - 调用 `requires()` (Java) 或者 `Requires()` (C++) 方法声明**。任何一个指令运行时，如果手柄按钮按下调用了其他指令，第二个指令会抢占第一个指令的资源。比如 `OpenClaw` 指令正在运行，点击按钮运行 `CloseClaw` 指令，那么 `OpenClaw` 指令就会被中断，**2 - 下一个周期中 `interrupted()` 方法被调用**，然后 `CloseClaw` 指令被调度。细细想来这种调度方法的确常用。如果你按下一个按钮打开机械爪，然后又突然反悔，那第一个指令的确应该被停止。

一个指令可以调用许多子系统，比如一个复杂的自动阶段指令组。

指令组自动添加了所有子指令的子系统，作为自己需要依赖的子系统。因此我们不需要在指令组中手动 require 子系统。

## 如何使得指令组中每个指令需要的子系统都被满足？

指令组需要的所有子系统是一个所有子指令需要的子系统的集合。如果四个指令被添加到指令组中了，整个指令组会直接依赖所有四个指令依赖的子系统。比如，三个指令在指令组中定义，第一个需要子系统 A，第二个需要子系统 B，第三个需要子系统 C 和 D。指令组执行时就会依赖 ABCD 四个子系统。如果其他需要 ABCD 任意一个子系统的指令开始执行了，它会中断整个指令组，包括顺序和并行，正在执行和将要执行的所有指令。
