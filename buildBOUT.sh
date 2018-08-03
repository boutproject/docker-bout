#!/bin/bash
source ./shellfunc.sh ; echo ""

echo "------------------------------------------"
echo "           Build BOUT++ image             "
echo "------------------------------------------"
echo ""

echo "Enter Dockerfile name prefix"
read DOCKER_NAME

HOSTNAME=`hostname -s`
DOCKERFILE="$DOCKER_NAME.dkr"
IMAGE_NAME="$DOCKER_NAME-img"
SCR_NAME="/scr_eris/jleddy/projects/BOUT-docker/"
# CONTRIB_DIR="/opt/contrib"
#
# if [ ! -d ./contrib ]; then
#   echo "contrib directory needs to be local for Dockerfile to accept"
#   runcmd "cp -R $CONTRIB_DIR ."
# fi

if [ ! -d $SCR_NAME ];then
  echo "Directory $SCR_NAME not found. Check build script"
  exit
fi

echo "DOCKERFILE = $DOCKERFILE"
echo "IMAGE_NAME = $IMAGE_NAME"
echo "SCR_NAME   = $SCR_NAME"
echo ""

#
# The -f gives the file name of the 'Dockerfile'
# The last argument sets the PATH to be used to find files in the
#   'Dockerfile' and to resolve the '-f' option
#
runcmd "sudo docker build -t '$IMAGE_NAME' -f $DOCKERFILE $SCR_NAME"

echo ""
echo "docker images:"
echo ""
sudo docker images
