#!/bin/sh
set -e

ip addr

nohup /usr/local/bin/net_speeder eth0 "ip" >/dev/null 2>&1 &

exec ss-server -s $SERVER_ADDR \
               -p $SERVER_PORT \
               -k $PASSWORD \
               -m $METHOD \
               -t $TIMEOUT \
               -d $DNS_ADDR \
               --fast-open \
               -u


