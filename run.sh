#!/bin/bash
while [ $# -gt 0 ]
do
  case $1 in
      --version) VER=$2; shfit 2;;
      *) shift;;
  esac
done
if [ "x$VER" == "x" ]; then
   VER=latest
fi

# Avoid repeated downloads set BR2_DL_DIR on the host.
# And use it upon repeated invocations.
HOST_DLDIR=$HOME/buildroot-dl
mkdir -p $HOST_DLDIR && docker run  -v $HOST_DLDIR:/BR2_DL_DIR --rm -it buildroot:$VER
