BOUT++ docker scripts
=====================

This repository contains scripts for creating and using docker
containers for BOUT-dev master and next branches. (found here:
https://github.com/boutproject/BOUT-dev)

To build or use Docker containers, you must first install docker and
then set it running (instructions here:
https://docs.docker.com/install/linux/docker-ce/centos/)

Building docker images
----------------------

The `.dkr` files each create a docker image, and each should have
the command needed to run them at the top of the file.

For example, to build BOUT-next on Arch Linux,

    $ cd arch
    $ sudo docker build -t boutproject/bout-next:4cee87c-arch -f arch-bout-next.dkr .

Note that the tag should be updated to reflect the BOUT++ commit or release
being compiled.

Using docker images
-------------------

To open an image as a container you can type:

    ./start-interactive.sh

it will prompt you for the name of the image (which should either be
bout-img or bout-next-img depending on which you built)
  
You will find yourself at the command line logged in to the container
as boutuser.  You should see the BOUT++ installation and should be
able to build and run examples.
  
Alternatively, you can use:

    ./start-BOUT.sh

which will prompt you to create a common data folder so files can be
shared between your machine and the container. This script will also
prompt you regarding the number of processors you desire.
