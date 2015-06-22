FROM centos:centos6
MAINTAINER kvaps <kvapss@gmail.com>

RUN mv /etc/localtime /etc/localtime.old; ln -s /usr/share/zoneinfo/Europe/Moscow /etc/localtime
RUN localedef -v -c -i en_US -f UTF-8 en_US.UTF-8; $(exit 0)
#RUN localedef -v -c -i ru_RU -f UTF-8 ru_RU.UTF-8; $(exit 0)
ENV LANG en_US.UTF-8

RUN yum -y install epel-release

RUN yum -y install git gcc cmake libevent-devel glib2-devel gmime-devel lua lua-devel pcre-devel sqlite-devel hiredis-devel logrotate

#Install Rspamd
RUN git clone --recursive https://github.com/vstakhov/rspamd.git /usr/src/rspamd

WORKDIR /usr/src/rspamd

RUN cmake -DCMAKE_INSTALL_PREFIX= .
RUN make -j2
RUN make install

RUN adduser --system --no-create-home _rspamd
#RUN cp /usr/src/rspamd/centos/sources/rspamd.init /etc/init.d/rspamd
#RUN chmod 755 /etc/init.d/rspamd
RUN cp /usr/src/rspamd/centos/sources/rspamd.logrotate /etc/logrotate.d/rspamd
RUN mkdir -p /var/lib/rspamd /var/run/rspamd /var/log/rspamd
RUN chown _rspamd:_rspamd /var/lib/rspamd /var/run/rspamd /var/log/rspamd

ADD start.sh /bin/start.sh
ENTRYPOINT ["/bin/start.sh"]

# Attach data volume
VOLUME ["/data"]

EXPOSE 11333 11334

WORKDIR /root
