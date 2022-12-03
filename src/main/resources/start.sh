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
            echo "程序"$jappname"[pid="$psid"]已经启动!"
            echo "正在关闭程序"$jappname
            kill $psid
        fi
    fi
    let i++;
done
#引入依赖类库到类路径
export CLASSPATH=.
for jarpath in `ls *.jar`
do
    CLASSPATH=$CLASSPATH:$jarpath
done
export CLASSPATH=$CLASSPATH

for jarpath in `ls lib/*.jar`
do
    CLASSPATH=$CLASSPATH:$jarpath
done
export CLASSPATH=$CLASSPATH
java -Xnoclassgc -XX:MaxMetaspaceSize=1024M -XX:SurvivorRatio=6 -XX:InitialSurvivorRatio=6 -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:+HeapDumpOnOutOfMemoryError -XX:+PrintGCDateStamps -XX:+PrintGCDetails -verbose:gc -Xloggc:gc.log -XX:+PerfBypassFileSystemCheck -cp $CLASSPATH com.lin.AwesomeVideoAdminApplication
