---
layout: post
title:  "CommandGroup · 指令组"
date:   2016-08-16 23:30:41 +0800
categories: programming
tags: zyz的编程干货 机器人 Java 编程
showcase: programming-guide
---

`ZYZ` 是来自 `Zodiac` 的巨神程序猿。作为一名 Xenial 星人，他有一个聪慧的大脑 INN。利用
INN，他可以 **按顺序** 或者 **同时** 完成一项或多项任务。

在进行机器人编程的时候，难免会发现，一个 `Command` 只能执行一个动作，或者是同时执行多个动作。
`WPILib` 中，提供一种叫 `CommandGroup` 的特殊 `Command`, 可以用来进行 `Command` 的**顺序管理**。


## 创建 CommandGroup

{% asset '{{ "command-group/create-1.png" }}' %}

右击项目 - `Add` - `CommandGroup` 输入名称即可创建一个指令组。

```java
public class TestCommandGroup extends CommandGroup {

    public TestCommandGroup() {
        // 在这里插入你的代码
    }
}
```

在构造函数内插入代码就能描述一个指令组。


## 串联指令与并行指令

在 `CommandGroup` 中，最常用的两个函数是 `addSequential(Command command)` 与
`addParallel(Command command)`。

其中, `addSequential` 是顺序执行一个指令(串联)，而 `addParallel`
则是使该指令在上一个顺序指令完成后执行，并使得之后的并行和第一个顺序指令和这个指令同时开始执行(并行)。

因此，使用 `addSequential` 添加的指令不会等待之前所有的并行指令完成后开始，而是仅仅等待上一个顺序指令。

我们再回到之前的 Command-based Robot 中，探索如何运行 INN 器官。

{% asset '{{ "command-based-robot/xenial-2.png" }}' %}

在 `CommandGroup` 的构造函数里插入你的代码：

```java
public class INNCommandGroup extends CommandGroup {

    public INNCommandGroup() {
        addSequential(new Command1());
        addParallel(new Command2());
        addSequential(new Command3());
        addSequential(new Command4());
    }
}
```

此时, `Command1` 先执行，接着 `Command2` 与 `Command3` 同时执行，
`Command3` 执行完成后开始执行 `Command4`。

*注：如果需要达到并联串联同时使用的效果，可以将一部分指令放在一个 CommandGroup 里，再将这个 CommandGroup 加到其他的 CommandGroup 里。*

{% asset '{{ "command-group/create-2.png" }}' %}

比如这里可以将绿框内的 `Command` 放在一个 `CommandGroup` 里，标号 `7`，
然后再创建一个 `CommandGroup`：

### Command7

```java
addSequential(new Command5());
addSequential(new Command6());
```

### CommandFinal

```java
addSequential(new Command1());
addParallel(new Command2());
addParallel(new Command3());
addSequential(new Command7());      // Command7 是一个 CommandGroup
addSequential(new Command6());
```

## 消失的函数

`initialize()`, `execute()`, `isFinished()`, `end()`, `interrupted()` 这些本来继承于 `Command` 的函数还需要写吗？

`CommandGroup` 继承了 `Command` 类，已经帮你写好了这些函数，帮助你管理所有指令。因此你不需要再重载这些函数。

*感谢 Rocka Zhou 供稿*

*修复了 CommandGroup 并行的一些问题*
