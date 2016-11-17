#!/bin/sh
set -e

exec ss-server -s $SERVER_ADDR \
               -p $SERVER_PORT \
               -k $PASSWORD \
               -m $METHOD \
               -t $TIMEOUT \
               -d $DNS_ADDR \
               -d $DNS_ADDR_2 \
               --fast-open \
               -u


