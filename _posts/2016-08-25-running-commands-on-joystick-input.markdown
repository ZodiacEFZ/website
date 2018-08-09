---		
layout: post		
title:  手柄事件触发指令
date:   2016-08-25 22:55:32 +0800		
categories:
- programming
tags: 机器人 Java C++ 编程 翻译
showcase: translation-command-based
---

> 原文：[Running commands on Joystick input](http://wpilib.screenstepslive.com/s/4485/m/13809/l/599739-running-commands-on-joystick-input)

我们可以在手柄按钮被按下、放开、或者当按钮被按下时触发指令执行。只需要几行代码就可以实现这个功能。

---

## OI 类

{% asset running-commands-on-joystick-input/1.png %}

指令式编程的模板里含有一个叫 `OI` 的类。在这里可以定义所有操作接口。如果使用 RobotBuilder 的话，这个文件可以在 `org.usfirst.frc####.NAME` 包中找到。

## 创建手柄实例和按钮实例

```c++
// C++ Code

OI::OI()
{
	joy = new Joystick(1);

	JoystickButton* button1 = new JoystickButton(joy, 1),
			button2 = new JoystickButton(joy, 2),
			button3 = new JoystickButton(joy, 3),
			button4 = new JoystickButton(joy, 4),
			button5 = new JoystickButton(joy, 5),
			button6 = new JoystickButton(joy, 6),
			button7 = new JoystickButton(joy, 7),
			button8 = new JoystickButton(joy, 8);

}
```

```java
// Java Code
public class OI {
    // Create the joystick and the 8 buttons on it
	Joystick leftJoy = new Joystick(1);
	Button  button1 = new JoystickButton(leftJoy, 1),
			button2 = new JoystickButton(leftJoy, 2),
			button3 = new JoystickButton(leftJoy, 3),
			button4 = new JoystickButton(leftJoy, 4),
			button5 = new JoystickButton(leftJoy, 5),
			button6 = new JoystickButton(leftJoy, 6),
			button7 = new JoystickButton(leftJoy, 7),
			button8 = new JoystickButton(leftJoy, 8);
}
```

这个例子里，手柄被接在端口 1 上，接着定义了八个在这个手柄上的按钮来操纵机器人的各个部分。在测试时这样设定十分方便。当然我们也可以在 SmartDashboard 上添加执行某个指令的按钮。

## 将按钮关联到指令上

```c++
// C++ Code

button1->WhenPressed(new PrepareToGrab());
button2->WhenPressed(new Grab());
button3->WhenPressed(new DriveToDistance(0.11));
button4->WhenPressed(new PlaceSoda());
button6->WhenPressed(new DriveToDistance(0.2));
button8->WhenPressed(new Stow());

button7->WhenPressed(new SodaDelivery());
```

```java
// Java Code

public OI() {
	button1.whenPressed(new PrepareToGrab());
	button2.whenPressed(new Grab());
	button3.whenPressed(new DriveToDistance(0.11));
	button4.whenPressed(new PlaceSoda());
	button6.whenPressed(new DriveToDistance(0.2));
	button8.whenPressed(new Stow());

	button7.whenPressed(new SodaDelivery());
}
```

在这个例子里，大部分的手柄按钮都被关联到指令上了。当按钮按下时，对应的指令就会被运行。通过这种方式，我们可以在手动阶段方便地给按钮指派一个任务，按下即执行。

## 其他的使用方法

除了使用 `whenPressed()` 方法指派指令以外，我们还可以使用其他方法触发指令：

* 在按钮被放开时执行一个指令 `whenReleased()`
* 在按钮被按下时执行一个指令 `whileHeld()`
* 按钮按一下切换指令的开始/停止 `toggleWhenPressed()`
* 按下按钮停止某个指令 `cancelWhenPressed()`

另外，指令也可以通过我们自己定义的触发器 (Trigger) 执行。触发器（和按钮）都是以大约 20 毫秒的周期被检测的。
