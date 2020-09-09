#!/bin/sh
:<<!
	功能：每周的零点开始运行脚本清除全部日志文件
!

# 日志文件夹
ACCESSDAY='/data/nginx_log/logs/access_day/'

rm -rf $ACCESSDAY*.log

echo "=====当周的的日志清理完成...======"
