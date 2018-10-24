#!/bin/bash
# A simple convenience script to build a container
# image for buildroot.
# As of ubuntu:18.04 it is minimal ubuntu about 84MB
# ---------------------------------------------------
PUSH=no
DOWNLOAD=no
while [ $# -gt 0 ]
do
  case $1 in
      --download) DOWNLOAD=yes; shift 1;;
      --version) VER=$2; shift 2;;
      --push) PUSH=yes ; shift 1;;
      *) shift;;
  esac
done
if [ "x$VER" == "x" ]; then
   # Default is Stable
   VER=2018.08
fi

# DOWNLOAD the version specified in the command line
# Use that to create a container of the same name.
# Only download when it is not there here
#
# -----------------------------------------------
NAME=buildroot 
FILENAME=${NAME}-${VER}.tar.gz
if [ ! -f $FILENAME ]; then
   DOWNLOAD="yes"
fi
if [ "$DOWNLOAD" == "yes" ]; then
    echo "Getting buildroot-${VER}... "
    /usr/bin/curl --output ${FILENAME} https://buildroot.org/downloads/${FILENAME}
    if [ $? -ne 0 ]; then
        echo "$FILENAME Download failed!"
        exit $?
    fi
else
    echo "Using archive $FILENAME ... "
fi
ln -sf ${FILENAME} ${NAME}.tar.gz

DATETIME=$(/bin/date +%d%h%y-%H%M%S)
docker build --build-arg=BUILDTIME=${DATETIME} -t ${NAME}:${VER} .
if [ $? -eq 0 ]; then
   echo "Done and build image ${NAME}:${VER} ready."
   echo "You may use ./run.sh to start it."
   echo "Run.sh creates userids mounts your home etc so you should be happy"
fi

# really?
docker tag ${NAME}:${VER} ${NAME}:latest 

DOCKERREPO=hackacharya
if [ "$PUSH" == "yes" ]; then 
    docker tag ${NAME}:${VER}  $DOCKERREPO/${NAME}:${VER}
    docker tag  $DOCKERREPO/${NAME}:${VER} $DOCKERREPO/${NAME}:latest
    docker push $DOCKERREPO/${NAME}:${VER}
    docker push $DOCKERREPO/${NAME}:latest
fi


