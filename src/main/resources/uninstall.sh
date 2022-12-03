#!/bin/bash
# CONTAINER_NAME="moliapp"
eval $(grep 'CONTAINER_NAME=' install.sh)

function echo_error() {
    echo -e "\033[1m\033[7m\033[31m"$*"\033[0m"
}

function echo_info() {
    echo -e "\033[1m\033[7m\033[32m"$*"\033[0m"
}

echo "Check enviroment"
systemctl status docker &> /dev/null
if [[ $? != 0 ]];
then
	echo_error "docker is not running, error exit"
	exit 127
else
	echo_info "environment is ok."
fi

echo "Check service"
docker ps|awk '{print $NF}'|grep $CONTAINER_NAME &> /dev/null
if [[ $? == 0 ]];
then
	echo_info "$CONTAINER_NAME now is running, will stop first"
	docker stop $CONTAINER_NAME 
fi

echo "Service $CONTAINER_NAME is not running, begin uninstalling"
IMAGE_NAME=`docker ps -a --filter name=$CONTAINER_NAME |tail -1 | awk '{print $2}'`
docker rm -f -v $CONTAINER_NAME &> /dev/null
docker rmi $IMAGE_NAME &> /dev/null

rm -rf /usr/bin/$CONTAINER_NAME
echo_info "\nLocal files and db data were not erased, please clean manualy."
