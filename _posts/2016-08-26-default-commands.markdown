---		
layout: post		
title:  默认指令
date:   2016-08-26 23:11:51 +0800		
categories:
- programming
tags: 机器人 Java C++ 编程 翻译
showcase: translation-command-based
---

> 原文：[Default Commands](http://wpilib.screenstepslive.com/s/4485/m/13809/l/599742-default-commands)

有些情况下我们需要一个子系统不断调用一个指令。如果当前的指令结束了，如何让子系统自动唤起一个指令呢？这就是默认指令干的事情。

---

## 什么是默认指令？

每个子系统可以指定一个默认指令，在这个子系统没有其他指令执行的时候唤起。最常见的例子就是由手柄操控的底盘子系统。这个指令可以被其他的开车指令中断（比如“精确驾驶模式”，自动对齐/瞄准等），但是在这些指令完成后，手柄操纵底盘的指令应该再次重新执行。

## 设置默认指令

```c++
// C++ Code

#include "ExampleSubsystem.h"

ExampleSubsystem::ExampleSubsystem()
{
    // 把子系统需要用到的机械在这里定义好，指令调用子系统中的机械。
}

ExampleSubsystem::InitDefaultCommand()
{
    // 在这里定义默认指令
    SetDefaultCommand(new MyDefaultCommand());
}
```

```java
// Java Code

public class ExampleSubsystem extends Subsystem {

    // 把子系统需要用到的机械在这里定义好，指令调用子系统中的机械。

    public void initDefaultCommand() {
        // 在这里定义默认指令
        setDefaultCommand(new MyDefaultCommand());
    }
}
```

所有子系统都应该包含一个方法 `initDefaultCommand()`，在这里声明子系统的默认指令。如果这个子系统不需要默认指令，把这个方法留空就行。如果需要给子系统指派默认指令，在这个方法里调用 `setDefaultCommand()` 函数，将指令实例作为参数传入。
