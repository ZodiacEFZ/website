---
layout: post
title:  "漂亮和丑陋的 Xenial 星人 · Java 面向对象入门"
date:   2016-07-07 17:15:22 +0800
categories: programming
tags: zc大哥哥的编程干货 FRC@EFZ 机器人 Java
---

*Pisces000221* 是一名 *Xenial* 星人。
经过五年的观察，他发现了 *Xenial* 生物的遗传规律。
*Xenial* 星生物可以分成两部分：漂亮的 *Xenial* 星人和丑陋的 *Xenial* 星人。
漂亮的 *Xenial* 星女人和丑陋的 *Xenial* 星男人生孩子生下的女孩都是丑陋的，男孩都是美丽的……

*Pisces000221* 决定使用 **Java 面向对象** 的方法分析 *Xenial* 星人的数据。

## 从零开始

类描述了许多个对象共同的属性和方法。每一个类都有成员变量，成员函数，构造函数，析构函数等等。

我们先创建一个 Java 工程来尝试创建类。

{% img '{{ "object-oriented-programming/oo-1.png" }}' %}

点击 `Finish` 创建工程。

{% img '{{ "object-oriented-programming/oo-2.png" }}' %}

右击工程创建类。

{% img '{{ "object-oriented-programming/oo-3.png" }}' %}

填入 `Name`，勾选 `public static void main(String[] args)` 创建主程序所在的类。
注意，创建其他类时**不需要勾选这一项**。

{% img '{{ "object-oriented-programming/oo-4.png" }}' %}

在创建的类中输入程序：

```java
public class XenialMain {

	public static void main(String[] args) {
		System.out.println("Hello, World!");
	}

}
```

单击工具栏中的运行键即可运行程序。

{% img '{{ "object-oriented-programming/oo-5.png" }}' %}

此时在 Console 中会出现一句 `Hello, World!` 表明程序成功运行。

{% img '{{ "object-oriented-programming/oo-6.png" }}' %}

## 在 Xenial 星球上

*Pisces000221* 觉得所有 *Xenial* 星人都有以下几个属性：名字、外貌特征、年龄。
所有 *Xenial* 星人都会用电波进行心♂灵交流。
这种交流的方法叫做 `say`。

除了外貌特征以外，其他的特征都无法直接通过 *Xenial* 星人的特殊感觉器官 *XEN* 发现。
只能在心♂灵交流时，其他的特征才能被人知晓。

在心♂灵交流时 *Xenial* 会在控制台内输出一句话。
当然 *Pisces000221* 也不知道什么时候 *Xenial* 星人和控制台联系在了一起。

万能的神明：哈哈哈 *Pisces000221* 你怎么也是想不到的其实 *Xenial* 星人的基因是由 `TNA` 决定的！这个 `TNA` 只有我神明知道！

### 定义基类

在项目视图中创建 `Xenial` 类后，即可添加成员变量和构造函数。

```java
public class Xenial {
	protected int gender, age;
	protected String name;
	public int appearance;
	private int TNA;

	public Xenial() {
		gender = 0; age = 0; name = ""; TNA = 0;
	}
}
```

我们可以在主程序创建该类的对象。调用 `new Xenial()` 时实际上给这个变量分配了内存，并调用了构造函数 `Xenial()`。

```java
public class XenialMain {

	public static void main(String[] args) {
		Xenial xenial = new Xenial();
	}
}
```

*这里不需要 import 这个类，是因为它和 `XenialMain` 在同一个包 (package) 中。*

接下来你可以尝试访问这个对象的成员变量。

```java
public class XenialMain {

	public static void main(String[] args) {
		Xenial xenial = new Xenial();
		System.out.println(xenial.gender);
		System.out.println(xenial.appearance);
		System.out.println(xenial.TNA);
	}
}
```

最后一句话报错了。因为 `TNA` 是 `private` 变量，无法**直接通过对象访问**。
而 `gender` 是一个 `protected` 的变量。这个变量在**子类**和**同一个包**中可以直接访问。
`public` 类型的成员可以直接通过对象访问。

经过 *Pisces000221* 研究发现，*Xenial* 人有豪爽的人和内向的人。
豪爽的人一旦心灵交流就会毫不犹豫地把自己的性别、年龄告诉别人，
这也增加了他们被怪蜀黍拐走的可能性。
而内向的人只会犹犹豫豫地交流自己的性别。

### 类的继承

每个 `Xenial` 都会心灵♂交流。我们在基类 `Xenial` 中定义 `say` 函数。

```java
public class Xenial {
	protected int gender, age;
	protected String name;
	public int appearance;
	private int TNA;

	public Xenial() {
		gender = 0; age = 0; name = ""; TNA = 0;
	}

	public String say() {
		return "";
	}
}
```

创建 `StraightXenial` 类来代表豪爽的人。我们要 **重写** 他的 `say` 函数。

```java
public class StraightXenial extends Xenial {

	public StraightXenial() {

	}

	public String say() {
		return "I'm " + age + " years old. I'm " + gender + ".";
	};
}
```

```java
public class XenialMain {

	public static void main(String[] args) {
		StraightXenial xenial = new StraightXenial();
		System.out.println(xenial.say());
	}

}
```

如果把 `StraightXenial xenial = new StraightXenial();` 改成 `Xenial xenial = new StraightXenial();` 还能执行吗？这时调用 `say` 会输出什么呢

```java
public class XenialMain {

	public static void main(String[] args) {
		Xenial xenial = new StraightXenial();
		System.out.println(xenial.say());
	}

}
```

```
I'm 0 years old. I'm 0.
```

因此**对象的行为取决于创建对象时的类，而不是保存类的变量类型本身**。
即使是使用 `Xenial` 类型保存一个用 `StraightXenial` 初始化的对象，
调用的也是 `StraightXenial` 的函数和成员变量。这也是类的多态性的体现。

## 构造函数

*Pisces000221* 发现写的程序里没有办法指定创建的 *Xenial* 的年龄、性别、名字等信息。

我们可以通过构造函数或成员函数添加。

```java
public class Xenial {
	protected int gender, age;
	protected String name;
	public int appearance;
	private int TNA;

	public Xenial(int gender, int age, String name, int TNA) {
		this.gender = gender;
		this.age = age;
		this.name = name;
		this.TNA = TNA;
	}

	public String say() {
		return "";
	};
}
```

而在主程序中可以通过 `new` 操作符创建 `Xenial` 对象。

*Xenial* 生物的 `TNA` 是生来注定的。而他的名字在日后还可以随时更改。因此我们可以添加一个成员函数 setName 进行名字的更改。

```java
	public void setName(String name) {
		this.name = name;
	}
```

## 练习

1. 创建内向的 *Xenial*。
2. 有一天内向的 *Xenial* 发现他们可以通过一种叫 *CEN* 的器官让对方瞬间明白自己的一切。
这意味着他们不用再害羞地用心灵交流出自己的小秘密啦！给内向的 *Xenial* 定义 `cen` 函数。
并探究如果使用 `Xenial` 基类储存这个对象，是否可以调用它的 `cen` 函数。
3. 使用 `super` 关键字在 `StraightXenial` 等类中调用父类的构造函数。
4. *Xenial* 还有很多种。你可以自己创造一些，然后定义它的成员。
5. 自学静态类 (static)，定义一个类似 C/C++ 中的全局变量。
