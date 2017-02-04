#!/bin/sh
set -e

exec ss-server -s $SERVER_ADDR \
               -p $SERVER_PORT \
               -k $PASSWORD \
               -m $METHOD \
               -t $TIMEOUT \
               --fast-open \
               -u


