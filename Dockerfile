FROM centos:centos6
MAINTAINER kvaps <kvapss@gmail.com>

RUN mv /etc/localtime /etc/localtime.old; ln -s /usr/share/zoneinfo/Europe/Moscow /etc/localtime
RUN localedef -v -c -i en_US -f UTF-8 en_US.UTF-8; $(exit 0)
#RUN localedef -v -c -i ru_RU -f UTF-8 ru_RU.UTF-8; $(exit 0)
ENV LANG en_US.UTF-8

RUN yum -y install epel-release

RUN yum -y install git gcc cmake libevent-devel glib2-devel gmime-devel lua lua-devel openssl-devel pcre-devel sqlite-devel hiredis-devel sendmail-devel bison flex

RUN git clone --recursive https://github.com/vstakhov/rspamd.git /usr/src/rspamd

#Install Rspamd
WORKDIR /usr/src/rspamd

RUN cmake -DCMAKE_INSTALL_PREFIX= .
RUN make -j2
RUN make install

RUN adduser --system --home /var/run/rspamd --no-create-home rspamd
RUN mkdir -p /var/lib/rspamd /var/run/rspamd /var/log/rspamd
RUN chown rspamd:rspamd /var/lib/rspamd /var/run/rspamd /var/log/rspamd

RUN git clone https://github.com/vstakhov/rmilter /usr/src/rmilter
 
#Install Rmilter
WORKDIR /usr/src/rmilter

RUN cmake -DCMAKE_INSTALL_PREFIX=  . 
RUN make -j2
RUN make install

RUN adduser --system --no-create-home rmilter
RUN mkdir -p /var/lib/rmilter /var/run/rmilter /var/log/rmilter /etc/rmilter
RUN chown rmilter:rmilter /var/lib/rmilter /var/run/rmilter /var/log/rmilter
RUN cp /usr/src/rmilter/rmilter.conf.sample /etc/rmilter/rmilter.conf

WORKDIR /root
