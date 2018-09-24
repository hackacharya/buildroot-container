#!/bin/bash
# A simple convenience script to build a container
# image for buildroot.
# As of ubuntu:18.04 it is minimal ubuntu about 84MB
# ---------------------------------------------------
while [ $# -gt 0 ]
do
  case $1 in
      --version) VER=$2; shfit 2;;
      *) shift;;
  esac
done
if [ "x$VER" == "x" ]; then
   # Default is Stable
   VER=2018.08
fi

# DOWNLOAD the version specified in the command line
# Use that to create a container of the same name.
# -----------------------------------------------
NAME=buildroot 
echo "Getting buildroot-${VER}... "
FILENAME=${NAME}-${VER}.tar.gz
/usr/bin/curl --output ${FILENAME} https://buildroot.org/downloads/${FILENAME}
ln -sf ${FILENAME} ${NAME}.tar.gz
if [ $? -ne 0 ]; then
   echo "$NAME Download failed!"
   exit $?
fi

# docker build --no-cache=true
docker build --no-cache=true -t ${NAME}:${VER} .
if [ $? -eq 0 ]; then
   echo "Done and build image ${NAME}:${VER} ready."
   echo "You may use ./run.sh to start it. Or simply do: "
   echo "   docker run --rm -it  ${NAME}:${VER}"
fi

# really?
docker tag ${NAME}:${VER} ${NAME}:latest 
