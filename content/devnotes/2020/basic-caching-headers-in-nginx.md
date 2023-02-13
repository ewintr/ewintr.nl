---
title: "Basic caching headers in nginx"
date: 2020-01-05
draft: false
---

To add basic caching headers for different filetypes, add an `expires` directive to your nginx config file, like this:<!-- more -->

```
# Expires map
map $sent_http_content_type $expires {
    default                    off;
    text/html                  epoch;
    text/css                   30d;
    application/javascript     30d;
    ~image/                    30d;
    ~font                      max;
}

server {
    listen 80 default_server;
    listen [::]:80 default_server;

    expires $expires;
    ...
```

* `off` means no caching headers.
* `epoch` is no caching, ask the website itself.
* `30d` cache for 30 days.
* `max` is the maximum, cache as long as you can.
* A `~` in the mimetype indicates a regular expression.

## Fonts

It could be that this does not work right away for fonts, as nginx defaults to the `application/octet-stream` mimetype for those filetypes. To fix this, add these lines to the `/etc/nginx/mime.types` config file:

```
font/ttf             ttf;
font/opentype        otf;
font/woff            woff;
font/woff2           woff2;
```

Don't forget to add the first two to the list of gzipped mimetypes, the last two already have compression baked into the format:

```
gzip_types text/plain text/css ... font/ttf font/opentype;
```

In `/etc/nginx/nginx.conf` (on Debian).

## Sources

* [www.digitalocean.com](https://www.digitalocean.com/community/tutorials/how-to-implement-browser-caching-with-nginx-s-header-module-on-centos-7)
* [drawingablank.me](http://drawingablank.me/blog/font-mime-types-in-nginx.html)
