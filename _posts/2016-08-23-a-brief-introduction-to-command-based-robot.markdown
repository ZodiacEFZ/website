---		
layout: post		
title:  入门指令式机器人编程
date:   2016-08-23 12:00:36 +0800		
categories:
- programming
tags: 机器人 Java 编程
---

Zodiac 翻译了 2016 FRC Control System 中 Command-based 相关的文档。

<ul>
  {% for post in site.categories["command-based programming"] reversed %}
    <li>
      <span class="post-meta">
        <span class="m-r-1">{{ post.date | date: "%b %-d, %Y" }}</span>
        <small>
        {% for tag in post.tags %}
          <span class="text-muted">#{{ tag }}</span>
        {% endfor %}
        </small>
      </span>
      <h2>
        <a class="post-link" href="{{ post.url | prepend: site.baseurl }}">{{ post.title }}</a>
      </h2>
    </li>
  {% endfor %}
</ul>
