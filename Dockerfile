FROM centos:centos6
MAINTAINER kvaps <kvapss@gmail.com>
ENV REFRESHED_AT 2016-09-29

RUN yum -y install epel-release
RUN curl -o /etc/yum.repos.d/rspamd.repo http://rspamd.com/rpm-stable/centos-6/rspamd.repo
RUN rpm --import http://rspamd.com/rpm-stable/gpg.key
RUN yum -y install rspamd

ENTRYPOINT ["/bin/start.sh"]
VOLUME ["/data"]
EXPOSE 11333 11334

ADD start.sh /bin/start.sh
