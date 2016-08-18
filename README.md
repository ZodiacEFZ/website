# website

[![Build Status](https://travis-ci.org/ZodiacEFZ/website.svg?branch=master)](https://travis-ci.org/ZodiacEFZ/website) [![Dependency Status](https://gemnasium.com/badges/github.com/ZodiacEFZ/website.svg)](https://gemnasium.com/github.com/ZodiacEFZ/website)

This is the website project for Zodiac.

## Continuous Integration

We use Travis to automatically deploy our website on GitHub Pages and Qiniu.

You can now view the site building status on Travis.

## Deployment

We use `Jekyll` to generate website pages, and then use Travis to deploy them.

`DNSPod` enables us to speed up website access by using different settings for a domain.

In China, `frc.hsefz.org` will be resolved to `Qiniu`, and all external libraries
will be loaded from `BootCDN` and `useso.com`. Otherwise this site will be resolved
to `GitHub Pages,` and all libraries will be loaded from `CDNJS` and `Google Fonts`.

In a word, **we do not use any cloud server**. CDN provides faster speed and
better defense against DDOS. Only static files are hosted.
We use GitHub to collaborate and update our website.

## Discuss

We've enabled discuss on our site. In China mainland, you'll see a `duoshuo`
plugin. Otherwise there'll be a `Disqus` plugin.
