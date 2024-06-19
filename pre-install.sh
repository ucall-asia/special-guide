#!/bin/sh

#upgrade the packages
apt-get update && apt-get upgrade -y

#setup timezone
export TZ=Asia/Ho_Chi_Minh
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#install packages
apt-get install -y git lsb-release
