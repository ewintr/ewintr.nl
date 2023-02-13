---
title: "JSON structured logging with nginx"
date: 2021-03-21
draft: false
---

After writing my tutorial on analysis of JSON structured logs on the command line I realized I could apply the same solution for website statistics. If only I could make Nginx to log in the same format.<!-- more -->

Web stats have always been cumbersome for some reason. Most people resort to a Javascript tracker, but that is a complex solution. It requires an online service that the tracker can report to and it requires Javascript on the client side, which is not always available. Not to mention the privacy issues, performance drain, security concerns and all other forms of morally questionable misery that the advertising industry dumps on everyones everyday internet experience.

Since most people use a cloud service to deploy their site, they don’t really have another option, as they don’t have access to the webserver logs. But since I have access, I figured I could use just make my own reports. I actually only care about the amount of requests (as indication what users find interesting) and the referer (so I could chime in if there is a discussion elswehere about a page), so the logs should be sufficient.

As it turns out, Nginx does not have a magical `json=true` option, but it does have an `escape=json` directive that you can use when defining your own log format. So the solution is to just write the JSON you want to have and use this directive to escape the variables.

In your `nginx.conf`, in the `http` block, define a new log format:

```
  log_format jsonformat escape=json '{'
    '"time_local":"$time_local",'
    '"remote_addr":"$remote_addr",'
    '"remote_user":"$remote_user",'
    '"request":"$request",'
    '"status": "$status",'
    ... more fields
    ‘}’;
```

And then, in the same `nginx.conf`, or in your site configuration, depending on where you configure the logging, update the format that is used:

```
  access_log  /var/local/nginx/my_log.log jsonformat;
```

That’s it. But maybe there is more interesting stuff to learn about this, so I went for the list of fields that I found on [blog.tyk.nu](https://blog.tyk.nu/blog/structured-json-logging-in-nginx/):

```
  log_format jsonformat escape=json '{'
      '"time_iso8601": "$time_iso8601", ' # local time in the ISO 8601 standard format
      '"msec": "$msec", ' # request unixtime in seconds with a milliseconds resolution
      '"connection": "$connection", ' # connection serial number
      '"connection_requests": "$connection_requests", ' # number of requests made in connection
      '"request_id": "$request_id", ' # the unique request id
      '"request_length": "$request_length", ' # request length (including headers and body)
      '"request_time": "$request_time", ' # request processing time in seconds with msec resolution
      '"remote_addr": "$remote_addr", ' # client IP
      '"remote_port": "$remote_port", ' # client port
      '"remote_user": "$remote_user", ' # client HTTP username
      '"ssl_protocol": "$ssl_protocol", ' # TLS protocol
      '"ssl_cipher": "$ssl_cipher", ' # TLS cipher
      '"http_user_agent": "$http_user_agent", ' # user agent
      '"http_referer": "$http_referer", ' # HTTP referer
      '"http_host": "$http_host", ' # the request Host: header
      '"server_name": "$server_name", ' # the name of the vhost serving the request
      '"scheme": "$scheme", ' # http or https
      '"request_method": "$request_method", ' # request method
      '"request_uri": "$request_uri", ' # full path and arguments if the request
      '"server_protocol": "$server_protocol", ' # request protocol, like HTTP/1.1 or HTTP/2.0
      '"bytes_sent": "$bytes_sent", ' # the number of bytes sent to a client
      '"status": "$status", ' # response status code
      '"pipe": "$pipe", ' # “p” if request was pipelined, “.” otherwise
      '"upstream": "$upstream_addr", ' # upstream backend server for proxied requests
      '"upstream_connect_time": "$upstream_connect_time", ' # upstream handshake time incl. TLS
      '"upstream_header_time": "$upstream_header_time", ' # time spent receiving upstream headers
      '"upstream_response_time": "$upstream_response_time", ' # time spend receiving upstream body
      '"upstream_cache_status": "$upstream_cache_status"' # cache HIT/MISS where applicable
    '}';
```

## Sources

* [stackoverflow.com](https://stackoverflow.com/questions/25049667/how-to-generate-a-json-log-from-nginx)
* [blog.tyk.nu](https://blog.tyk.nu/blog/structured-json-logging-in-nginx/)
* [www.nginx.com](https://www.nginx.com/blog/diagnostic-logging-nginx-javascript-module/)
