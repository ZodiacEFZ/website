---		
layout: post		
title:  "论如何维护 Zodiac 官网"		
date:   2016-08-19 13:02:26 +0800		
categories: team		
tags: 队伍 网站 维护		
---		


1.  首先需要注册一个 [GitHub](https://github.com) 账号。

2.  访问 [https://github.com/ZodiacEFZ/website/](https://github.com/ZodiacEFZ/website/) ，点击 Fork 把这个项目拷贝到自己的账户下。
    **（这之后的操作都是在自己的项目里操作的！）**

    {% asset make-website/website-1.png %}

3.  在拷贝后的网站 `_posts` 文件夹下点击 `Create New File` 创建文件。

    {% asset make-website/website-2.png %}

4.  文件名设置为 `2016-08-04-first-day-training.markdown` (格式为 `日期-英文-名`)。

    {% asset make-website/website-3.png %}

5.  在开头复制文件头    

    ```yaml
    ---
    layout: post
    title: 创客营第一天
    date: 2016-08-03 15:10:09 +0800
    categories: news
    tags: 新闻 创客营 日常
    ---
    ```

    把 `date` 改成当前时间，`categories` 只能写英文无空格。    

    {% asset make-website/website-4.png %}

6.  空一行直接开始写文章。Markdown 语法相关请参见 [http://www.jianshu.com/p/q81RER](http://www.jianshu.com/p/q81RER)
    (如果不习惯使用 GitHub 的编辑器，可以在 [StackEdit](https://stackedit.io) 上编辑完成后拷贝过来)。

    {% asset make-website/website-5.png %}

7.  点击 `Preview` 可以预览当前文章。

    {% asset make-website/website-6.png %}

8.  如果需要插入图片，请先新建一个在与文章名字相同的目录的文件 `_assets/img/first-day-training/dummy.txt`，再把压缩后的图片上传到 `_assets/img/first-day-training` 目录下。文件名不要出现中文字符。

    {% asset make-website/website-7.png %}

9.  在文章中引入图片，换行空行后直接插入代码：    
    <code>&#123;&#37; img first-day-training/test-picture.jpg &#37;&#125;</code>    

    这里 `first-day-training/test-picture.jpg` 是图片相对于 img 目录的位置。注意图片无法直接在 GitHub 上预览文章时显示。

    {% asset make-website/website-8.png %}

10. 点击 `Commit New File`。

    {% asset make-website/website-9.png %}

11. 文章的文字和图片都上传完毕后，点击项目导航栏中的 `New Pull Request`，在提交信息中填写这次更改的内容（比如`添加了创客营第一天的新闻`），再点击 `Create Pull Request`。

    {% asset make-website/website-10.png %}

    {% asset make-website/website-11.png %}

    {% asset make-website/website-12.png %}

12. 在这里可以看到审核状况 [https://github.com/ZodiacEFZ/website/pulls](https://github.com/ZodiacEFZ/website/pulls)

13. 本人审核后即可自动部署到网站上。部署完毕后在 Slack 的 `#business` 中会有通知。

    {% asset make-website/website-13.png %}

    其中 **GitHub** 出现 `1 new commit` 表示审核已经通过，大约三分钟后出现 **Travis** `Build #93 (036ff5c) of ZodiacEFZ/website@master by SkyZH passed in 4 min 39 sec` 表示已经将修改同步到网站上。
