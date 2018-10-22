FROM ubuntu:18.04
MAINTAINER hackacharya@gmail.com
LABEL DESCRIPTION "A container with buildroot dependencies \
 and buildroot-2018.08. Note you may run container as follows \
 On the host you may \
 git clone https://www.github.com/hackacharya/buildroot-container \
 cd buildroot-container \
 mkdir -p $HOME/buildroot-dl; \
 ./run.sh --pull \
 Env variables that the init uses are UNAME, GNAME, USRID, GRPID, HOME \
 See http://buildroot.org for buildroot, And for the container "

# https://buildroot.org/downloads/manual/manual.html#requirement-mandatory
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y sed make binutils build-essential \
 gcc g++ bash patch gzip bzip2 perl tar cpio python unzip sudo \
 rsync file bc wget curl libelf-dev libsystemd-dev \
 libncurses5-dev openssh-client \
 git subversion rsync ; \
 apt-get clean 

# avoid asciidoc w3m dblatex texinfo for now
# openjdk-8-jre libgtk2, libglade2 etc make the image too heave
# so no

# The following two lines are used to invalidate cache.
# ------------------------------------------------------
ARG BUILDTIME=01Jan70-101000
LABEL buildtime=$DATETIME

# See http://buildroot.org
# See 
ADD ./buildroot.tar.gz /home/buildroot

COPY ./init.sh /init.sh

# graphical configdendencies.
# RUN apt-get install -y glib2 gtk2 libglade2 graphviz python-matplotlib 
# for git and 

CMD ["/init.sh"]
