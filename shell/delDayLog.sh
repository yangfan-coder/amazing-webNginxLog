#!/bin/sh
:<<!
	功能：每天的零点开始运行脚本清除日志文件
	原理：得到小于当天的时间戳直接rm掉。
!


# 日志文件夹
ACCESSDAY='/data/nginx_log/logs/access_minute/'

# 当前的时间
This_time=$(date "+%Y-%m-%d" )

# 当前的时间戳
This_tamp=$(date -d "$This_time" +"%s")

remove_logs(){

  for FLIE in $(ls ${ACCESSDAY})
	do 
		# 切分自定义日期日志名称
		NEW_FLIE=$( echo $FLIE | awk -F '[-]' '{print substr($0,1,length($0)-17)}' )
		
		This_Sum_Tamp=$(date -d "$NEW_FLIE" +"%s")

		# 日志的时间戳小于当前的时间戳，清除日志
		if [ $This_Sum_Tamp -lt $This_tamp ]; then

              		rm -rf $ACCESSDAY$FLIE
		fi

	done	
	echo '=========当天的日志清理完成...============'
}
remove_logs
