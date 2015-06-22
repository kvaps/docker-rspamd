FROM centos:centos6
MAINTAINER kvaps <kvapss@gmail.com>

RUN mv /etc/localtime /etc/localtime.old; ln -s /usr/share/zoneinfo/Europe/Moscow /etc/localtime
RUN localedef -v -c -i en_US -f UTF-8 en_US.UTF-8; $(exit 0)
#RUN localedef -v -c -i ru_RU -f UTF-8 ru_RU.UTF-8; $(exit 0)
ENV LANG en_US.UTF-8

RUN yum -y install epel-release

RUN yum -y install supervisor git gcc cmake libevent-devel glib2-devel gmime-devel lua lua-devel openssl-devel pcre-devel sqlite-devel hiredis-devel sendmail-devel bison flex logrotate

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

#Install Rmilter
RUN git clone https://github.com/vstakhov/rmilter /usr/src/rmilter
 
WORKDIR /usr/src/rmilter

RUN cmake -DCMAKE_INSTALL_PREFIX=  . 
RUN make -j2
RUN make install

RUN adduser --system --no-create-home _rmilter
#RUN cp /usr/src/rmilter/debian/rmilter.init /etc/init.d/rspamd
RUN mkdir -p /var/lib/rmilter /var/run/rmilter /var/log/rmilter
RUN chown _rmilter:_rmilter /var/lib/rmilter /var/run/rmilter /var/log/rmilter
RUN cp /usr/src/rmilter/rmilter.conf.sample /etc/rmilter.conf

ADD rmilter-wrapper.sh /bin/rmilter-wrapper.sh
RUN chmod +x /bin/rmilter-wrapper.sh

ADD start.sh /bin/start.sh
ENTRYPOINT ["/bin/start.sh"]

# Attach data volume
VOLUME ["/data"]

WORKDIR /root
