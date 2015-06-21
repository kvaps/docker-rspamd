#!/bin/bash

log=/var/log/rmilter/rmilter.log

trap '{
    echo "stoping rmilter"
    echo $(date +"%F %T") rmilter stop >> $log
    pkill rmilter
    exit 0
}' EXIT

echo "starting rmilter"
echo $(date +"%F %T") rmilter start >> $log
/sbin/runuser _rmilter -c "/sbin/rmilter -c /etc/rmilter.conf" &>> $log
tail -f -n1 /var/log/rmilter/rmilter.log
