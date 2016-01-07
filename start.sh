#!/bin/bash

set_timezone()
{
    if [ -f /usr/share/zoneinfo/$TZ ]; then 
        rm -f /etc/localtime && ln -s /usr/share/zoneinfo/$TZ /etc/localtime
    fi
}

dir=(
    /etc/rspamd
    /var/lib/rspamd
    /var/log/rspamd
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
run()
{
    #Start command
    rspamd -f -u _rspamd -g _rspamd 
}

set_timezone

if [ ! -d /data/etc ] ; then
    move_dirs
    link_dirs
    run
else
    link_dirs
    run
fi
