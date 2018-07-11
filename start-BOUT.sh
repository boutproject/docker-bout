#!/bin/bash
source  ./commonAWSFuncs.sh ; echo ""

echo "---------------------------------------"
echo "    Start interactive session inside   "
echo "           BOUT-img container          "
echo "---------------------------------------"
echo ""

sudo docker images
echo ""
echo "Enter full path of shared storage directory:"
read SHARED_DIR

export IMAGE_NAME="bout-img"
runcmd "mkdir $SHARED_DIR"

runcmd 'sudo docker run --rm -it --env="DISPLAY" --env="QT_X11_NO_MITSHM=1" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" -v $SHARED_DIR:/home/bout-img-shared $IMAGE_NAME /bin/bash' #
export containerId=$(sudo docker ps -l -q)
