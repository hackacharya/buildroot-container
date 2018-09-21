FROM ubuntu:18.04
MAINTAINER hackacharya@gmail.com
LABEL DESCRIPTION "A container with buildroot dependencies \
 and buildroot-2018.08 If you have a directory \
 with BR2_DL_DIR (as a result of make source) \
 then you may mount that as /BR2_DL_DIR to  \
 the container. See http://buildroot.org"

# https://buildroot.org/downloads/manual/manual.html#requirement-mandatory
RUN apt-get update; \
 DEBIAN_FRONTEND=noninteractive apt-get install -y sed make binutils build-essential \
 gcc g++ bash patch gzip bzip2 perl tar cpio python unzip  \
 rsync file bc wget curl libelf-dev libsystemd-dev texinfo \
 asciidoc w3m dblatex libncurses5 openssh-client \
 git subversion rsync openjdk-8-jre; \
 apt-get clean 

# See http://buildroot.org
ADD ./buildroot.tar.gz /home/buildroot

COPY ./init.sh /init.sh

# graphical configdendencies.
# RUN apt-get install -y glib2 gtk2 libglade2 graphviz python-matplotlib 
# for git and 

CMD ["/init.sh"]
