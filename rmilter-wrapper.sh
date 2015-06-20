#!/bin/bash
trap '{ echo "stoping rmilter"; pkill rmilter; exit 0; }' EXIT
echo "starting rmilter"
/sbin/runuser _rmilter -c "/sbin/rmilter -c /etc/rmilter.conf"
sleep infinity
