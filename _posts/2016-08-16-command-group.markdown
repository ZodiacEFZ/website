---
layout: post
title:  "CommandGroup · 指令组"
date:   2016-07-08 17:08:16 +0800
categories: programming
tags: zyz大哥哥的编程干货 机器人 Java
---

`ZYZ` 是来自 `Zodiac` 的巨神程序猿。作为一名 Xenial 星人，他有一个聪慧的大脑 INN。利用
INN，他可以 **按顺序** 或者 **同时** 完成一项或多项任务。

在进行机器人编程的时候，难免会发现，一个 `Command` 只能执行一个动作，或者是同时执行多个动作。
`WPILib` 中，提供一种叫 `CommandGroup` 的特殊 `Command`, 可以用来进行 `Command` 的**顺序管理**。

## 创建 `CommandGroup`

{% img '{{ "command-group/create-1.png" }}' %}

右击项目 - `Add` - `CommandGroup` 输入名称即可创建一个指令组。

```
public class TestCommandGroup extends CommandGroup {

    public TestCommandGroup() {
        // 在这里插入你的代码
    }
}
```

在构造函数内插入代码就能描述一个指令组。

## `addSequential()` 与 `addParallel()`

在 `CommandGroup` 中，最常用的两个函数是 `addSequential(Command command)` 与
`addParallel(Command command)`。

其中, `addSequential` 是顺序执行一个指令(串联)，而 `addParallel`
则是使该指令和上一指令同时进行(并联)，并在所有并列的指令都执行完成后再执行剩下的指令。

我们再回到之前的 Command-based Robot 中，探索如何运行 INN 器官。

{% img '{{ "command-based-robot/xenial-2.png" }}' %}

在 `CommandGroup` 的构造函数里插入你的代码：

```
public class INNCommandGroup extends CommandGroup {

    public INNCommandGroup() {
        addSequential(new Command1());
        addSequential(new Command2());
        addParallel(new Command3());
        addSequential(new Command4());
    }
}
```

此时, `Command1` 先执行，接着 `Command2` 与 `Command3` 同时执行，
最后在两者都执行完成后才开始执行 `Command4`。

*注：如果需要达到并联串联同时使用的效果，可以将一部分指令放在一个 CommandGroup 里，再将这个 CommandGroup 加到其他的 CommandGroup 里。*

{% img '{{ "command-group/create-2.png" }}' %}

比如这里可以将绿框内的 `Command` 放在一个 `CommandGroup` 里，标号 `7`，
然后再创建一个 `CommandGroup`：


```
addSequential(new Command5());
addSequential(new Command6());
```

```
addSequential(new Command1());
addSequential(new Command2());
addParallel(new Command3());
addParallel(new Command7());      // Command7 是一个 CommandGroup
addSequential(new Command6());
```

## `initialize()`, `execute()`, `isFinished()`, `end()`, `interrupted()`

`CommandGroup` 继承了 `Command` 类，已经帮你写好了这些函数，帮助你管理指令。因此你不需要再重载这些函数。

*感谢 Rocka Zhou 供稿*
