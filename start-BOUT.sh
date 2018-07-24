#!/bin/bash
source  ./commonAWSFuncs.sh ; echo ""

echo "---------------------------------------"
echo "    Start interactive session inside   "
echo "           BOUT-img container          "
echo "---------------------------------------"
echo ""

sudo docker images
echo ""
echo "Enter full local path of shared storage directory:"
read SHARED_DIR

export IMAGE_NAME="bout-img"
runcmd "mkdir $SHARED_DIR"

echo ""
echo "How many cores should container utilize:"
read NCORES

MYCMD="sudo docker run --rm -it --tty --cpuset-cpus=\"0-$(($NCORES-1))\" -v $SHARED_DIR:/home/bout-img-shared $IMAGE_NAME /bin/bash"

echo ""
echo "Running command:"
echo $MYCMD
eval $MYCMD
export containerId=$(sudo docker ps -l -q)

## --env="DISPLAY" --env="QT_X11_NO_MITSHM=1"
## --cpuset-cpus="0-$(($NCORES-1))"
