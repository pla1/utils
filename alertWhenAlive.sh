#!/bin/bash
#
# Send email when device is PINGable. 
#
if test -z $1
        then
                echo "Missing IP Address or host name"
                echo "Usage: ./alertwhenalive 10.1.2.3"
                exit -1
fi
while true
do
  if ping "$1" -c 1 | grep '1 received'
  then
    message="$1 is alive"
    echo "$message" | mail -s "$message" patrick.archibald@gmail.com
    exit 0
  fi
  sleep 1
done
