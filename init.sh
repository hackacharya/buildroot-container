#!/bin/bash 

cd /home/buildroot/buildroot*
pwd
if [ -d /BR2_DL_DIR ]; then
	export BR2_DL_DIR="/BR2_DL_DIR"
else 
	echo "You may want to mount a host dir under /BR2_DL_DIR."
	echo "You may be able to save time on downloads."
fi

# Setup the container such that the userid and group id there matches
# the person invoking  so the /home/ directory appears very much the
# same as the host inside the container.
# We are hoping we are launched with the following env variables
#   USRID, UNAME
#   GRPID, GNAME
# ------------------------------------------------------
if [ "$HOME" != "" ]; then
   HOMEOPT="-d $HOME"
fi

# If GID already exists with a different change its group id
if [ "$GRPID" != "" ]; then
       grep  ":$GRPID:" /etc/group > /dev/null  2>&1
       if [ $? -eq 0 ]; then
          OLDGNAME=`cat /etc/group | grep  ":$GRPID:" | cut -d":" -f1`
          if [ "$OLDGNAME" != "" -a "$OLDGNAME" != "$GNAME" ]; then
            NEWGRPID=$((GRPID+2000))      # Hack, assume this doesn't exist!
            groupmod -g $NEWGRPID $OLDGNAME 
            echo "Moving $OLDGNAME to $NEWGRPID ... rc=$?"
          fi
       fi
fi

# If our group name doesn't exist create it.. and ensure it has the same id
if [ "$GNAME" != "" -a "$GRPID" != "" ]; then
    grep -w $GNAME /etc/group >/dev/null 2>&1
    if  [ $? -eq 0 ]; then
       groupmod -g $GRPID $GNAME
       echo "Updating group $GNAME($GRPID) ... rc=$?"
    else
       groupadd -g $GRPID $GNAME
       echo "Creating group$GNAME($GRPID) ... rc=$?"
    fi
fi

# if your user name does not exist create it
if [ "$UNAME" != "" -a "$USRID" != "" ]; then
     grep -w $UNAME /etc/passwd >/dev/null 2>&1
     if [ $? -eq 0 ]; then 
        usermod -u $USRID $HOMEOPT -aG $GNAME $UNAME
        echo "Updating user $UNAME($USRID), $GNAME($GRPID) ... rc=$?"
     else
        useradd -u $USRID -g $GRPID -G sudo -s /bin/bash $HOMEOPT $UNAME
        echo "Creating user $UNAME($USRID), $GNAME($GRPID) ... rc=$?"
     fi
fi

echo "Preparing your files! just a minute please ..."
sudo chown -R $USRID:$GRPID /home/buildroot
echo
cat << END_OF_TEXT
* *********************************************************** *
* TODO: CAVEAT: your gid may not have ported out nicely
*
* hackacharya/buildroot-2018.08
* All your buildroot downloads going to \$HOME/buildroot-dl
*
*
* Your home is @ $HOME
* Your buildroot is @ /home/buildroot
*
* make menuconfig  - is a good place to start
* *********************************************************** *
END_OF_TEXT
exec su - $UNAME
