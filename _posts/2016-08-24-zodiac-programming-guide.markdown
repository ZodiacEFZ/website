---		
layout: post		
title:  "RE: 从零开始的编程入门"
date:   2016-08-23 22:43:55 +0800		
categories:
- showcase
- programming
tags: 机器人 Java 编程
abstract: |
  <del class="text-muted">从便利店回来的路上突然被召唤到异世界的少年，菜月昴。在无可依赖的异世界，无力的少年所唯一拥有的力量……
  那就是死后便会使时间倒转的“死亡回归”的力量。为了守护重要的人，并取回那些无可替代的时间，少年向绝望抗争，挺身面对残酷的命运。</del>
  由 Zodiac 推出的从零开始的 FRC 机器人入门教程。
---

由 Zodiac 推出的从零开始的 FRC 机器人入门教程。

<ul>
  {% assign c_posts = site.posts | where_exp: "item", "item.showcase == 'programming-guide'" %}
  {% include post-collection.html posts=c_posts %}
</ul>
