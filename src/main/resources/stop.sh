#!/bin/bash   
##############   
#判断是否程序已启动   
jappname='AwesomeVideoAdminApplication'
javaps=`jps`   
i=0  
psid=0  
for psresult in $javaps   
do
	let cur=i%2  
	if [ $cur -eq 0 ]; then   
		psid=$psresult   
	else  
		if (test "$psresult" = "$jappname")   
		then
			echo "正在关闭程序"$jappname
			kill $psid  
			exit 0
		fi         
	fi   
	let i++;   
done   
