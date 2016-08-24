---		
layout: post		
title:  从零开始的机器人编程入门
date:   2016-08-23 22:43:55 +0800		
categories:
- showcase
- programming
tags: 机器人 Java 编程
abstract: 由 Zodiac 推出的从零开始的 FRC 机器人入门教程。
---

<ul>
  {% assign c_posts = site.posts | where_exp: "item", "item.showcase == 'programming-guide'" %}
  {% include post-collection.html posts=c_posts %}
</ul>
