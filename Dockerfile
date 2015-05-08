FROM centos:centos7
MAINTAINER KD
ENV HOSTNAME dockeroracle

RUN yum -y update && yum -y install wget
RUN wget http://public-yum.oracle.com/public-yum-ol7.repo -O /etc/yum.repos.d/public-yum-ol7.repo
RUN wget http://public-yum.oracle.com/RPM-GPG-KEY-oracle-ol7 -O /etc/pki/rpm-gpg/RPM-GPG-KEY-oracle
RUN yum -y install oracle-rdbms-server-11gR2-preinstall

RUN yum -y update && yum install -y initscripts openssh openssh-server openssh-clients sudo passwd sed screen tmux byobu which vim-enhanced
RUN sshd-keygen
RUN sed -i "s/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config
# setup default user
RUN useradd admin -G wheel -s /bin/bash -m
RUN echo 'admin:welcome' | chpasswd
RUN echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers
# expose ports for ssh
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
