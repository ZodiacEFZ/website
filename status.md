---
layout: page
title: Status
---

[![Build Status](https://travis-ci.org/ZodiacEFZ/website.svg?branch=master)](https://travis-ci.org/ZodiacEFZ/website)

This badge indicates the website building status. If it is green, you are visiting
the latest version of our site. Otherwise there might be some technical error with
our building system.

You are visiting our site hosted on {% if site.build_target == 'QINIU' %}[Qiniu](http://www.qiniu.com/){% endif %}{% if site.build_target == 'GITHUB_PAGES' %}[GitHub Pages](https://github.com/){% endif %}.
