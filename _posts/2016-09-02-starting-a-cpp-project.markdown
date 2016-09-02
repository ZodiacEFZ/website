---		
layout: post		
title:  "RE: 从零开始的 C++ 工程"
date:   2016-09-01 17:21:33 +0800		
categories:
- showcase
- programming
tags: C++ 编程
abstract: 由 Zodiac 推出的从零开始的 C++ 工程入门教程，帮助您写出模块化的工业级 C++ 项目。
---

由 Zodiac 推出的从零开始的 C++ 工程入门教程，帮助您写出模块化的工业级 C++ 项目。

<ul>
  {% assign c_posts = site.posts | where_exp: "item", "item.showcase == 'programming-guide-c++'" %}
  {% include post-collection.html posts=c_posts %}
</ul>
