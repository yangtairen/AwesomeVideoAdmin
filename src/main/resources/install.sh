#!/bin/bash
# 镜像名称，默认无需修改，除非指定不同镜像
# IMAGE="docker.sensenets.com/vid/vid"
# 容器名称，需要启动多个服务时，为避免容器冲突需自行修改
CONTAINER_NAME="AwesomeVideoAdmin"
IMAGE="AwesomeVideoAdmin"
# 服务80端口的对外映射端口，默认仍为80，需要启动多个服务时，为避免端口冲突需自行修改
PORT=80

function echo_error() {
    echo -e "\033[1m\033[7m\033[31m"$*"\033[0m"
}

function echo_info() {
    echo -e "\033[1m\033[7m\033[32m"$*"\033[0m"
}

ROOTPATH=$(cd `dirname $0`; pwd)
cd $ROOTPATH

# 1. 检查docker和本服务是否运行
echo -e "\nCheck enviroment."
docker ps &> /dev/null
if [[ $? != 0 ]];
then
  echo_error "docker is not running, error exit"
  exit 127
else
  docker ps -a | awk '{print $NF}' | grep $CONTAINER_NAME &> /dev/null
  if [[ $? == 0 ]];
  then
    echo_error "$CONTAINER_NAME has been installed.please uninstall first."
    exit 1
  else
    echo_info "environment is ok."
  fi
fi

# 2. 导入镜像
#离线导入
#echo -e "\nLoad image."
#imgfile=`ls *.img 2> /dev/null`
#if [[ -z $imgfile ]];then
#  echo_error "not found docker image tar, error exit"
#  exit 128
#else
#  echo "docker load -i $imgfile"
#  IMAGE=`docker load -i $imgfile|awk '{print $3}'`
#  echo "$IMAGE has loaded"
#fi
#在线构建
docker build -t $CONTAINER_NAME .

# 3. 运行容器
echo_info "Run $CONTAINER_NAME server"
docker run -p ${PORT}:80 \
       --name $CONTAINER_NAME \
       --restart on-failure \
       -v $ROOTPATH:/usr/src -d $IMAGE

# 4. 导入命令
if [ $? -eq 0 ];then

cat << EOF >  /usr/bin/$CONTAINER_NAME
if [[ "\$1" =~ 'shell' ]];then
  echo -e "\nEnter Container"
  docker exec -it $CONTAINER_NAME bash
elif [[ "\$1" =~ 'start' ]];then
  echo -e "\nStart Server"
  docker start $CONTAINER_NAME
elif [[ "\$1" =~ 'stop' ]];then
  echo -e "\nStop Server"
  docker stop $CONTAINER_NAME
elif [[ "\$1" =~ 'status' ]];then
  docker ps|awk '{print \$NF}'|grep $CONTAINER_NAME &> /dev/null
  if [[ \$? == 0 ]];then
    echo "$CONTAINER_NAME is running"
  else
    echo "$CONTAINER_NAME is not running"
    exit 1
  fi
elif [[ "\$1" =~ 'help' ]];then
  echo -e "\nUsage:  \"$CONTAINER_NAME\" [COMMAND]"
  echo -e "\nRun a command for \"$CONTAINER_NAME\""
  echo -e "\nCommands:"
  echo -e "start\t\tStart Server"
  echo -e "stop\t\tStop Server"
  echo -e "status\t\tGet Server Status"
  echo -e "shell\t\tEnter Container Shell(use \"exit\" or \"CTRL+P+Q\" to return"
  echo -e "\nAttention:For more information or options, use docker commands instead."
else
  echo "\"$CONTAINER_NAME\" requires at least 1 argument(s)"
  echo -e "See '\"$CONTAINER_NAME\" --help'."
  echo -e "\nUsage:  \"$CONTAINER_NAME\" [COMMAND]"
fi
EOF

chmod +x /usr/bin/$CONTAINER_NAME
echo_info  "\nInstall completely，please use command \"$CONTAINER_NAME\" to manage server.\n"
else
echo_error  "\nInstall failed, exit error."
exit 127
fi



