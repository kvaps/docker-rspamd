FROM centos:centos6
MAINTAINER kvaps <kvapss@gmail.com>
ENV REFRESHED_AT 2015-09-17
ENV RSPAMD_VERSION 0.9.10


RUN yum -y install epel-release

RUN yum -y install git gcc cmake libevent-devel glib2-devel gmime-devel lua lua-devel pcre-devel sqlite-devel hiredis-devel logrotate openssl-devel tar xz

#Install Rspamd
#RUN git clone --recursive https://github.com/vstakhov/rspamd.git /usr/src/rspamd
RUN curl http://rspamd.com/downloads/rspamd-${RSPAMD_VERSION}.tar.xz | tar xpJ -C /usr/src/

WORKDIR /usr/src/rspamd-${RSPAMD_VERSION}

RUN cmake -DCMAKE_INSTALL_PREFIX= .
RUN make -j2
RUN make install

RUN adduser --system --no-create-home _rspamd
#RUN cp /usr/src/rspamd/centos/sources/rspamd.init /etc/init.d/rspamd
#RUN chmod 755 /etc/init.d/rspamd
RUN cp /usr/src/rspamd-${RSPAMD_VERSION}/centos/sources/rspamd.logrotate /etc/logrotate.d/rspamd
RUN mkdir -p /var/lib/rspamd /var/run/rspamd /var/log/rspamd
RUN chown _rspamd:_rspamd /var/lib/rspamd /var/run/rspamd /var/log/rspamd

ADD start.sh /bin/start.sh
ENTRYPOINT ["/bin/start.sh"]

# Attach data volume
VOLUME ["/data"]

EXPOSE 11333 11334

WORKDIR /root
