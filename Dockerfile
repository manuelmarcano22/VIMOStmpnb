##
## hepsw/cc7-base is a WIP image for CERN CentOS-7
##
FROM centos:7
MAINTAINER Sebastien Binet "binet@cern.ch"

# add CERN CentOS yum repo
ADD http://linux.web.cern.ch/linux/centos7/CentOS-CERN.repo /etc/yum.repos.d/CentOS-CERN.repo
ADD http://linuxsoft.cern.ch/cern/centos/7.1/os/x86_64/RPM-GPG-KEY-cern /tmp/RPM-GPG-KEY-cern

RUN /usr/bin/rpm --import /tmp/RPM-GPG-KEY-cern && \
    /bin/rm /tmp/RPM-GPG-KEY-cern


RUN yum update -y && \
	yum clean all

##Extra
RUN yum -y update
RUN yum -y install \
           file which

RUN yum -y install binutils-devel gcc gcc-c++ gcc-gfortran git make patch python-devel \
	   glibc.i686 zlib.i686 ncurses-libs.i686 bzip2-libs.i686 uuid.i686 libxcb.i686 \
	   libXmu.so.6 libncurses.so.5 tcsh


#These are needed to build IRAF
RUN yum -y install \
           bzip2-devel \
           libXpm-devel libXft-devel libXext-devel \
           libxml2-devel \
           libuuid-devel \
           ncurses-devel \
           texinfo \
           wget \
	   bzip2 sudo passwd bc csh vim libXScrnSaver evince


## Intall minicoda python 2.7
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh  -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh

ENV PATH /opt/conda/bin:$PATH


##With iraf
##Install
ENV PATH /opt/conda/bin:$PATH

RUN wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm
RUN rpm -ivh epel-release-7-9.noarch.rpm


WORKDIR "/root"
#Install iraf
#Astroconda other way
#RUN /opt/conda/bin/conda config --add channels http://ssb.stsci.edu/astroconda
#RUN /opt/conda/bin/conda create -y -n iraf27 python=2.7 iraf pyraf Flask bokeh
ADD environmentpyraf.yml	      /root/
RUN conda env create -f environmentpyraf.yml
ADD VIMOSReduced /root/VIMOSReduced/


# Add Tini. Tini operates as a process subreaper for jupyter. This prevents
# kernel crashes. Still haven't implemented
ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]


EXPOSE  80 8080 8888
