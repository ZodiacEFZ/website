---		
layout: post		
title:  入门指令式机器人编程
date:   2016-08-23 12:00:36 +0800		
categories:
- showcase
- programming
tags: 机器人 Java 编程
abstract: 2016 FRC Control System 中 Command-based 相关文档的翻译。
---

Zodiac 翻译的 2016 FRC Control System 中 Command-based 相关的文档。

<ul>
  {% assign c_posts = site.posts | where_exp: "item", "item.showcase == 'translation-command-based'" %}
  {% include post-collection.html posts=c_posts %}
</ul>
