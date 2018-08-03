#!/bin/bash
source  ./shellfunc.sh ; echo ""

echo "---------------------------------------"
echo "    Start interactive session inside   "
echo "            named container            "
echo "---------------------------------------"
echo ""

sudo docker images
echo ""

echo "Enter name of image:"
read IMAGE_NAME

runcmd "sudo docker run --rm -it $IMAGE_NAME /bin/bash"
