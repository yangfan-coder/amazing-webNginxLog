#!/bin/sh

# ACCESSDAY='/data/nginx_log/logs/access_day/2019-07-18-access.log';

# 日志文件夹
ACCESSDAY='/data/nginx_log/logs/access_minute/'

# 当前的时间
This_time=$(date "+%Y-%m-%d %H:%M" )
# 当前的时间戳
This_tamp=$(date -d "$This_time" +"%s")

# 过去5分钟时间
Past_times=$(date -d "-5  minute" +"%Y-%m-%d %H:%M")
# 过去5分钟的时间戳
Past_Minute_tamp=$(date -d "$Past_Minute_tamp" +"%s")

# 昨天的时间
Yester_day=$(date -d "-1  day" +"%Y-%m-%d %H:%M")
# 昨天的时间戳
Past_tamp=$(date -d "$Yester_day" +"%s")

# 打印的时间戳
#echo ${This_tamp}
#echo ${Past_Minute_tamp}
#echo ${Past_tamp}


#echo $(date -d "$This_time" +"%s")
#echo $(date -d "$Past_times" +"%s")

echo "===============脚本开始======================"
echo $This_time

# 写入数据库
Write_Mysqls(){

	USER='root'

	PASSWORD='test1234567890'

	# 登录mysql
	mysql -u $USER --password=$PASSWORD <<EOF

	use monitoringLogs;

	select "写入数据库";

	insert into log_table(
		prject_id,
		user_id,
		log_type,
		ua_info,
		date,
		key_name,
		key_id,
		key_self_info,
		error_type,
		error_type_info,
		error_stack_info,
		target_url
	)
	values(
			"${1}",
			"${2}",
			"${3}",
			"${4}",
			"${5}",
			"${6}",
			"${7}",
			"${8}",
			"${9}",
			"${10}",
			"${11}",
			"${12}"
	);

EOF

echo "=================写入数据库完毕======================"
echo $This_time

}

Handle(){
	prjectId='null'

	userId='null'

	logType='null'

	uaInfo='null'

	Dates='null'

	keyName='null'

	keyId='null'

	keySelfInfo='null'

	errorType='null'

	errorTypeInfo='null'

	errorStackInfo='null'

	targetUrl='null'

	_prjectId=$(echo $1 | awk -F '[=]' '{print $2}' )

	_userId=$(echo $2 | awk -F '[=]' '{print $2}' )

	_logType=$(echo $3 | awk -F '[=]' '{print $2}' )

	_uaInfo=$(echo $4 | awk -F '[=]' '{print $2}' )

	_Dates=$(echo $5 | awk -F '[=]' '{print $2}' )

	_keyName=$(echo $6 | awk -F '[=]' '{print $2}' )
	
	_keyId=$(echo $7 | awk -F '[=]' '{print $2}' )

	_keySelfInfo=$(echo $8 | awk -F '[=]' '{print $2}' )

	_errorType=$(echo $9 | awk -F '[=]' '{print $2}' )

	_errorTypeInfo=$(echo $10 | awk -F '[=]' '{print $2}' )

	_errorStackInfo=$(echo $11 | awk -F '[=]' '{print $2}' )

	_targetUrl=$(echo $12 | awk -F '[=]' '{print $2}' )
	
	if [ -n "$_logType" ]; then
		logType=$_logType
	fi
	if [ -n "$_uaInfo" ]; then
		uaInfo=$_uaInfo
	fi
	if [ -n "$_Dates" ]; then
		Dates=$_Dates
	fi
	if [ -n "$_keyName" ]; then
		keyName=$_keyName
	fi
	if [ -n "$_keyId" ]; then
		keyId=$_keyId
	fi
	if [ -n "$_keySelfInfo" ]; then
		keySelfInfo=$_keySelfInfo
	fi
	if [ -n "$_errorType" ]; then
		errorType=$_errorType
	fi
	if [ -n "$_errorTypeInfo" ]; then
		errorTypeInfo=$_errorTypeInfo
	fi
	if [ -n "$_errorStackInfo" ]; then
		errorStackInfo=$_errorStackInfo
	fi
	if [ -n "$_targetUrl" ]; then
		targetUrl=$_targetUrl
	fi
	
	Write_Mysqls $_prjectId $_userId $logType $uaInfo $Dates $keyName $keyId $keySelfInfo $errorType $errorTypeInfo $errorStackInfo $targetUrl                                               
}

# 循环切分字符集
foreach_value(){
	
	#采集端定义字段
	arr_log=(
		"prject_id"
		"user_id"
		"log_type"
		"ua_info"
		"date"
		"key_name"
		"key_id"
		"key_self_info"
		"error_type"
		"error_type_info"
		"error_stack_info"
		"target_url"
	)

	#验证规则
	re=".*?(?=&)"
	
	prject_id=$(echo $1 | grep -oP "${arr_log[0]}${re}")	

	user_id=$(echo $1 | grep -oP "${arr_log[1]}${re}")
	
	log_type=$(echo $1 | grep -oP "${arr_log[2]}${re}")
	
	ua_info=$(echo $1 | grep -oP "${arr_log[3]}${re}")
	
	dates=$(echo $1 | grep -oP "${arr_log[4]}${re}")
	
	key_name=$(echo $1 | grep -oP "${arr_log[5]}${re}")
	
	key_id=$(echo $1 | grep -oP "${arr_log[6]}${re}")
	
	key_self_info=$(echo $1 | grep -oP "${arr_log[7]}${re}")
	
	error_type=$(echo $1 | grep -oP "${arr_log[8]}${re}")
	
	error_type_info=$(echo $1 | grep -oP "${arr_log[9]}${re}")
	
	error_stack_info=$(echo $1 | grep -oP "${arr_log[10]}${re}")
	
	target_url=$(echo $1 | grep -oP "${arr_log[11]}${re}")	


	# 判断必要的参数，为比传值	
	if [ -n "$prject_id" -a  -n "$user_id" ]; then

			# 处理参数
			Handle $prject_id $user_id $log_type $ua_info $dates $key_name $key_id $key_self_info $error_type $error_type_info $error_stack_info $target_url
	fi
	
}

# 打印出日志所有的文件夹

whlie_log(){
	
	for FLIE in $(ls ${ACCESSDAY})
	do 
		
		# 切分自定义日期日志名称
		NEW_FLIE=$( echo $FLIE | awk -F '[-]' '{print substr($0,1,length($0)-11)}' )
		
		# 切分日期分钟，转换格式时间戳 用于判断			
		CUT_TIME=$( echo ${NEW_FLIE} | awk -F "[-]" '{print $1"-"$2"-"$3" "$4$5 }' )
		
		GET_TEXT=$( cat $ACCESSDAY$FLIE ) 
	
		This_Sum_Tamp=$(date -d "$CUT_TIME" +"%s")

		if [ $This_Sum_Tamp -gt $Past_tamp ]; then
		
				foreach_value $GET_TEXT
		fi

	done	
}

whlie_log


