This repository is for creating docker containers for BOUT-dev master and next branches. (found here: https://github.com/boutproject/BOUT-dev)

bout.dkr 				- docker script for building BOUT-dev master
bout-next.dkr  			- docker script for building BOUt-dev next
buildBOUT.sh			- script to build a container from a docker script
start-interactive.sh  	- script for starting an interactive docker container
start-BOUT.sh			- script for starting bout container with some detailed options (see below)


To build these containers you must first install docker and then set it running (instructions here: https://docs.docker.com/install/linux/docker-ce/centos/)
Once docker is running, you can navigate into this repo directory and type:
./buildBOUT.sh

This will ask you the name of the docker script file you'd like to build so either "bout" or "bout-next"

It may take a while to build, you will need an internet connection, and you will need sudo privelages.  If your docker commands
function without sudo privelages, then you will need to modify the buildBOUT.sh script by removing all the sudo commands.

When complete, a list of your currently loaded docker images will be displayed.  To open an image as a container you can type:
./start-interactive.sh
it will prompt you for the name of the image (which should either be bout-img or bout-next-img depending on which you built)

You will find yourself at the command line logged in to the container as boutuser.  You should see the BOUT++ installation and should be able to build
and run examples.

Alternatively, you can use the start-BOUT.sh script which will prompt you to create a common data folder so files can be shared between your machine and the container. This script
will also prompt you regarding the number of processors you desire.