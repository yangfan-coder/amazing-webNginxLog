#!/bin/sh

curl 'https://oapi.dingtalk.com/robot/send?access_token=a08bbca03ca70a4d0a51ac5f6adbae7fe25fb51671a636a73c3061324ff23db3' \
   -H 'Content-Type: application/json' \
   -d '{
	"msgtype": "text", 
	"text": {
             "content": "中午到了 应吃饭啦！"
        },
	"at":{
		"isAtAll": true
	}
      }'
