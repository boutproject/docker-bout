#!/bin/bash

# =====================================================
#    Convenience method for printing out a command
#             prompting user, then running
# =====================================================
runcmd() {
  echo ""
  local cmd=$1
  local skipprompt=$2

  if [ ! -z $skipprompt ]; then
      echo "Running: $cmd"
      eval $cmd
      return
  fi

  echo "Running: $cmd ... continue? y/n"
  read gonext
  if [ $gonext == "y" ]; then
    eval $cmd
  else
    echo "Skipping command"
  fi
}


# ------------------------------------------------------------------------------------------------
# Print index of array value
#    use --> printArrayIndex my_array $value
#    val=$(printArrayIndex my_array $value)
#    echo "val = $val"
#
# Args:
#  1. array
#  2. value of array to find index
# ------------------------------------------------------------------------------------------------
printArrayIndex() {
  my_array=$1
  value=$2
  for i in "${!my_array[@]}"; do
      if [[ "${my_array[$i]}" = "${value}" ]]; then
          echo "${i}";
      fi
  done
}


# ------------------------------------------------------------------------------------------------
# Setup Ubercloud 'appr' program
# ------------------------------------------------------------------------------------------------
installAppr() {
    echo "Installing Ubercloud's 'appr'"
    tar -xvf ./appr-linux-amd64.tar.gz
    sudo mv appr-linux /usr/bin/appr
    echo ""
}


# ------------------------------------------------------------------------------------------------
# Download docker, setup and start
# ec2-user added to docker group so sudo not needed
# ------------------------------------------------------------------------------------------------
installDocker() {
    echo "Setting up docker on instance"
    sudo yum update -y && sudo yum install docker -y && sudo service docker start && sudo usermod -a -G docker ec2-user
    echo ""
}


# ------------------------------------------------------------------------------------------------
# Start webchem container along with consul service
# Docker must be installed
#
# Args:
#   1. type of image (lammps/nwchem/qmcpack)
#   2. start consul service ['y'/'n']
#   3. compose.yaml version ['techx'/'aws']
# ------------------------------------------------------------------------------------------------
startContainers() {

    # Pick image
    docker images
    echo ""
    IMAGE_TYPE=$1
    echo "  IMAGE_TYPE = $IMAGE_TYPE"

    # Start consul service
    START_CONSUL=$2
    echo "  START_CONSUL = $START_CONSUL"
    startUberConsul $START_CONSUL

    # Pick compose.yaml settings file
    YAML_TYPE=$3
    echo "  YAML_TYPE = $YAML_TYPE"

    if [ $YAML_TYPE == 'techx' ];then
        echo "Using techx compose.yaml"
        cp compose-techx.yaml compose.yaml
    elif [ $YAML_TYPE == 'aws' ];then
        echo "Using aws compose.yaml"
        cp compose-aws.yaml compose.yaml
    else
        exit
    fi

    # Parse short name for name in repo
    if [ $IMAGE_TYPE == "lammps" ]; then
        IMAGE_NAME=registry.theubercloud.com/techx/lammps_centos_7
    elif [ $IMAGE_TYPE == "vorpal" ]; then
        IMAGE_NAME=registry.theubercloud.com/techx_staging/vsim_8.1_centos_7
    elif [ $IMAGE_TYPE == "nwchem" ]; then
        IMAGE_NAME=registry.theubercloud.com/techx/nwchem_centos_7
    elif [ $IMAGE_TYPE == "qmcpack" ]; then
        IMAGE_NAME=registry.theubercloud.com/techx/qmcpack_centos_7
    else
        echo "Image type not recognized"
    fi

    # Start the containers, if consul started then email password, otherwise dont
    # Correct --email option when Ubercloud responds
    echo ""
    echo "Starting up image name = $IMAGE_NAME"
    if [ $START_CONSUL == 'y' ];then
        cat ./compose.yaml | appr run --email swsides@txcorp.com $IMAGE_NAME
    else
        cat ./compose.yaml | appr run --email blank@txcorp.com   $IMAGE_NAME
    fi
}


# ------------------------------------------------------------------------------------------------
# Force removal of all containers (running or otherwise)
# ------------------------------------------------------------------------------------------------
removeCntrs() {
  echo ""
  echo "Removing all running containers"
  echo ""
  docker rm -f  $(docker ps -aq)
}


# ------------------------------------------------------------------------------------------------
# Start the consul container with Uber cloud
# network settings. Args [y/n] to start or skip service
# Default behavior skips starting service
# ------------------------------------------------------------------------------------------------
startUberConsul() {

    START_CONSUL=$1
    if [ $START_CONSUL == "y" ];then
        echo ""
        echo "Starting consul image"
        echo ""
        docker run -d --restart=always -p 8400:8400 -p 8500:8500 -h \
               consul progrium/consul -server -bootstrap -client 0.0.0.0
    fi
}


# ------------------------------------------------------------------------------------------------
# Pull images from Ubercloud registry (Arg: lammps/vorpal/nwchem)
# ------------------------------------------------------------------------------------------------
pullUberCloudImg() {

    echo ""
    echo "---------------------------------------"
    echo "       Pulling Ubercloud images        "
    echo "---------------------------------------"
    echo ""

    echo "Logging into Ubercloud registry (using Tech-X docker machine password)"
    sudo docker login registry.theubercloud.com -u hpc.txcorp.com -p nkAEwxj1EDvD

    IMAGE_TYPE=$1

    if [ $IMAGE_TYPE == "lammps" ]; then
        sudo docker pull registry.theubercloud.com/techx/lammps_centos_7

    elif [ $IMAGE_TYPE == "vorpal" ]; then
        sudo docker pull registry.theubercloud.com/techx_staging/vsim_8.1_centos_7

    elif [ $IMAGE_TYPE == "nwchem" ]; then
        sudo docker pull registry.theubercloud.com/techx/nwchem_centos_7

    elif [ $IMAGE_TYPE == "qmcpack" ]; then
        sudo docker pull registry.theubercloud.com/techx/qmcpack_centos_7

    else
        echo ""
        echo "Image type not recognized"
        echo ""
    fi
}
