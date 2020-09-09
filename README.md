前端监控系统<日志截取过滤入库脚本>
===========================
整个项目脚本采用node.js读取日志文件文件的内容、sequelize、mysql数据库进行批量日志的循环插入
详情请看项目文件
****
	
|作者|yangfan19|
|---|---
|segmentfault|[点击我](https://segmentfault.com/u/this_586daa4645804)
|github|[点击我](https://github.com/yangfandashuaige/amazing-webNginxLog)


****
## 目录
```
├── config  // 配置文件
│   ├── db.js // 链接数据库的配置文件
│   ├── index.js // 初始文件
├── models
│   ├── index.js   //初始文件
│   ├── logTable.js  // 规定当前的数据库的字段类型 => 需要跟数据库保持统一
├── shell       // 配置清空当前的日志文件目录
│   ├── delAweek.sh   // 每周清空日志文件脚本
│   ├── delDayLog.sh  // 每天清空日志文件脚本
│   ├── dingDing.sh  // 测试 => 配置钉钉提醒
│   ├── runMysql.sh  // 安装mysql的脚本
│   ├── writeSQL.sh  // shell脚本切割入库 跟node 同理
├── index.js   // 入口文件
├── README.md
```

## nginx配置

****

根据当前nginx请求拦截log_img的错误日志

****

```javascript

user  root;
worker_processes  1;

error_log   /data/nginx_log/logs/error_log/error.log;

pid        /usr/local/nginx/logs/nginx.pid;

events {
    worker_connections  1024;
}

http {
  include       mime.types;
  default_type  application/octet-stream;

  log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';
  
  log_format  getIp  '$args';
  access_log  /usr/local/nginx/logs/access.log  main;
  sendfile        on;
  keepalive_timeout  65;

  server {
    # location ~ /tracker\.(gif|png|jpeg){
    location /log_img {
        #echo "$time_iso8601";
        
        alias	 /usr/img/;

        if ($time_iso8601 ~ "^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})")
        {	

            set $year $1;

            set $month $2;

            set $day $3;

            set $hour $4;

            set $minutes $5;

            set $seconds $6;

        }
        
    
        # 根据分钟进行切分
        access_log  /data/nginx_log/logs/access_minute/$year-$month-$day-$hour:$minutes-access.log  main;
    
        # 根据天进行切分
        access_log  /data/nginx_log/logs/access_day/$year-$month-$day-access.log  main;
        
        # default_type application/json;
        # return  200  '{"status":"success","result":"hello body!"}';
        # return 200 'ok';
        # echo "$args";
    }
  }
  include vhost/*.conf;
}

```
## 配置linux的crontab

[根据自己的需求进行配置](https://www.runoob.com/w3cnote/linux-crontab-tasks.html)
\