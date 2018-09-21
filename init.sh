#!/bin/bash

cd /home/buildroot/buildroot*
pwd
cat << END_OF_TEXT

* *********************************************************** *
* hackacharya/buildroot-2018.08
* All your buildroot downloads going to \$HOME/buildroot-dl
*
* make menuconfig is a good place to start
* *********************************************************** *
END_OF_TEXT
if [ -d /BR2_DL_DIR ]; then
	export BR2_DL_DIR="/BR2_DL_DIR"
else 
	echo "You may want to mount a host dir under /BR2_DL_DIR."
	echo "You may be able to save time on downloads."
fi
exec /bin/bash -o vi
