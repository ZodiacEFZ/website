---		
layout: post		
title:  "向机器人项目中添加指令和子系统"
date:   2016-08-23 11:24:19 +0800		
categories:
- command-based programming
- programming
tags: 机器人 Java 编程 翻译
---

> 原文：[Adding Commands and Subsystems to the project](http://wpilib.screenstepslive.com/s/4485/m/13809/l/599734-adding-commands-and-subsystems-to-the-project)


指令和子系统都是以类的形式被创建的。WPILib 开发插件内置了指令和子系统的程序模板。我们可以直接添加。

---

## 添加子系统

{% img adding-commands-and-subsystems-to-the-project/1.png %}

右键点击项目名，并选择 New - Subsystem。

## 命名子系统

{% img adding-commands-and-subsystems-to-the-project/2.png %}

在文本框中填写子系统名称。因为这个名称是程序中的类名，所以请指定一个符合编程语言语法的名称。

## 所有子系统

{% img adding-commands-and-subsystems-to-the-project/3.png %}

我们可以在 `Subsystems` (C++) 或 `org.usfirst.frc.teamxxxx.robot.subsystems` (Java) 目录中查看所有新建的子系统。欲了解如何完善一个子系统，请参见 [简单子系统]({% post_url 2016-08-23-simple-subsystems %}) 这篇文章。

## 添加指令

{% img adding-commands-and-subsystems-to-the-project/4.png %}

指令的添加步骤与子系统的添加类似。右键点击项目名，选择 New - Command。

## 命名指令

{% img adding-commands-and-subsystems-to-the-project/5.png %}

在 `Class Name` 中输入指令名。因为这个名称是程序中的类名，所以请指定一个符合编程语言语法的名称。

## 所有指令

{% img adding-commands-and-subsystems-to-the-project/6.png %}

我们可以在 `Commands` (C++) 或 `org.usfirst.frc.teamxxxx.robot.commands` (Java) 目录中查看所有新建的子系统。欲了解如何完善一个指令，请参见“创建简单的指令”这篇文章。
