#!/bin/bash

function printusage() {
cat << END_OF_HELP
Usage: 
   run.sh [ options ]
   where options are:
     --version VERSION - the docker container image tag to run , default 'latest'
     --pull  - pull it from dockerhub instead of using local image, default run locally
     --dldir - specify an existing or an empty directory to use as buildroot download dir on the host
     --help  - print this message
END_OF_HELP
}

HOST_DLDIR=$HOME/buildroot-dl
while [ $# -gt 0 ]
do
  case $1 in
      --version) VER=$2; shift 2;;
      --pull) DOCKERREPO="hackacharya/"; shift;;
      --dldir) HOST_DLDIR=$2; shift 2;;
      --help) printusage; exit 0 ;;
      *) shift;;
  esac
done

if [ "x$VER" == "x" ]; then
   VER=latest
fi

# Avoid repeated downloads set BR2_DL_DIR on the host.
# And use it upon repeated invocations.
# we also try to launch the container with $HOME mounted
# 
if [ ! -d "${HOST_DLDIR}" ]; then
    mkdir -p ${HOST_DLDIR}
fi

echo "Using ${HOST_DLDIR} as download dir ..."
echo "Running from ${DOCKERREPO}buildroot:$VER ..."
USRID=`id -u`
GRPID=`id -g`
GNAME=`cat /etc/group | grep  ":$GRPID:" | cut -d":" -f1`
mkdir -p $HOST_DLDIR && docker run --env HOME=$HOME --env USRID=$USRID --env GRPID=$GRPID --env UNAME=$USER --env GNAME=$GNAME -v $HOME:$HOME -v $HOST_DLDIR:/BR2_DL_DIR --rm --name buildroot-container -it ${DOCKERREPO}buildroot:$VER
