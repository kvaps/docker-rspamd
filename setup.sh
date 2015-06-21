#!/bin/bash

dir=(
    /etc/rspamd
    /etc/rmilter.conf
    /etc/supervisord.conf
    /var/lib/rspamd
    /var/lib/rmilter
    /var/log/rspamd
    /var/log/rmilter 
)

move_dirs()
{
    echo "info:  start moving lib and log folders to /data volume"

    mkdir -p /data/etc
    mkdir -p /data/var/lib
    mkdir -p /data/var/log

    for i in "${dir[@]}"; do mv $i /data$i; done

    echo "info:  finished moving lib and log folders to /data volume"
}

link_dirs()
{
    echo "info:  start linking default lib and log folders to /data volume"

    for i in "${dir[@]}"; do rm -rf $i && ln -s /data$i $i ; done
 
    echo "info:  finished linking default lib and log folders to /data volume"
}

configure_supervisor()
{
    echo "info:  start configuring Supervisor"


    cat > /etc/supervisord.conf << EOF
[supervisord]
nodaemon=true

[program:rspamd]
command=/bin/rspamd -f -u _rspamd -g _rspamd 

[program:rmilter]
command=/bin/rmilter-wrapper.sh
EOF
}

if [ ! -d /data/etc ] ; then
    move_dirs
    link_dirs
    configure_supervisor
else
    link_dirs
    supervisord
fi
