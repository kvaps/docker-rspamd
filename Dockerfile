FROM centos:centos6
MAINTAINER kvaps <kvapss@gmail.com>

RUN mv /etc/localtime /etc/localtime.old; ln -s /usr/share/zoneinfo/Europe/Moscow /etc/localtime
RUN localedef -v -c -i en_US -f UTF-8 en_US.UTF-8; $(exit 0)
#RUN localedef -v -c -i ru_RU -f UTF-8 ru_RU.UTF-8; $(exit 0)
ENV LANG en_US.UTF-8

RUN curl -o /etc/yum.repos.d/rspamd.repo http://rspamd.com/CentOS/6/os/x86_64/rspamd.repo
RUN rpm --import http://rspamd.com/vsevolod.pubkey
RUN yum -y update
RUN yum -y install rspamd rmilter
