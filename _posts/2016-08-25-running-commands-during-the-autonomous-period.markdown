---		
layout: post		
title:  自动阶段执行指令
date:   2016-08-25 23:04:38 +0800		
categories:
- programming
tags: 机器人 Java C++ 编程 翻译
showcase: translation-command-based
---

> 原文：[Running commands during the autonomous period](http://wpilib.screenstepslive.com/s/4485/m/13809/l/599740-running-commands-during-the-autonomous-period)

指令被定义后，它们就可以在手动或自动阶段被调用。事实上，指令式编程的最大好处就是可以让我们在不同的地方重用同一个指令。如果我们定义了一个射出飞盘的指令，这个指令在自动阶段执行，可以通过摄像头自动瞄准准确射击，我们没有理由不把它用在手动阶段，让驾驶员在手动阶段也可以自动瞄准。

---

## 创建自动阶段需要的指令

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

我们的机器人要在自动阶段完成下列任务：从地面上捡起易拉罐，并移动到一定距离外的桌子旁，把易拉罐放上去。这个过程由以下指令组成：

1. 准备抓取（移动升降装置，机械手腕，机械夹到指定位置）
2. 抓取易拉罐
3. 根据超声波测距仪的数据，将机器人开到桌子的一定距离处。
4. 放置易拉罐
5. 通过测距仪的数据，回到原来的位置
6. 重新摆放机械夹

在这个例子里，这六个指令一个接一个执行。

## 指定指令组在自动阶段执行

```c++
// C++ Code

Command* autonomousCommand;

class Robot: public IterativeRobot {

	void RobotInit()
	{
        // 初始化自动阶段的自动指令
		autonomousCommand = new SodaDelivery();
		oi = new OI();

	}


	void AutonomousInit()
	{
        // 触发一个自动指令
		if(autonomousCommand != NULL) autonomousCommand->Start();
	}

	/*
	 * 这个方法在自动阶段被周期性调用
	 */
	void AutonomousPeriodic()
	{
		Scheduler::GetInstance()->Run();
	}

	...-
}
```

```java
// Java Code

public class Robot extends IterativeRobot {

    Command autonomousCommand;

    public void robotInit() {
		oi = new OI();
        // 初始化自动阶段的自动指令
        autonomousCommand = new SodaDelivery();
    }

    public void autonomousInit() {
        // 触发一个自动指令
        if (autonomousCommand != null) autonomousCommand.start();
    }

	/*
	 * 这个方法在自动阶段被周期性调用
	 */
    public void autonomousPeriodic() {
        Scheduler.getInstance().run();
    }

	...
}
```

要让 `SodaDelivery` 指令在自动阶段执行：

1. 在 `robotInit()` 方法中初始化指令实例。
2. 在 `autonomousInit()` 方法中启动它。
3. 保证 `scheduler` 在 `autonomousPeriodic()` 方法中被周期性执行。

`robotInit()` 仅仅在机器人被启动时调用一次，所以这时候最好创建指令实例。 `autonomousInit()` 在自动阶段开始前调用，在这里启动一个指令。 `autonomousPeriodic()` 以 20 毫秒为周期不断被调用，所以在这里运行调度器，就可以把所有触发的指令运行一遍。
