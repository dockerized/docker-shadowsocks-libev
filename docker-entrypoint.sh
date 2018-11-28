#!/bin/sh
set -e

exec ss-server -s $SERVER_ADDR \
               -s $SERVER_ADDR_IPV6 \
               -d $DNS_ADDRS \               
               -p $SERVER_PORT \
               -k $PASSWORD \
               -m $METHOD \
               -t $TIMEOUT \
               --plugin obfs-server \
               --plugin-opts "${OBFS_OPTS}" \
               --fast-open \
               -u \
               --no-delay \
               --reuse-port 