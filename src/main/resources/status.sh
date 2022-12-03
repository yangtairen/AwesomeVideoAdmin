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
			echo "程序"$jappname"正在运行！"
			kill $psid  
			exit 0
		fi         
	fi   
	let i++;   
done   
echo "程序"$jappname"未运行！"
