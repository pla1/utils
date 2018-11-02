#!/bin/bash
#
# Execute dig on a domain name against some popular DNS servers
#
hostName="$1"
typeQuery="$2"

if [ -z "$hostName" ]
then
  echo -e "Please pass a host name.\nFor example: ./dnsQuery.sh gmail.com MX"
  exit -1
fi

if [ -z "$typeQuery" ]
then
  echo -e "Please pass a query type.\nFor example: ./dnsQuery.sh google.com SOA"
fi

for dns in "8.8.8.8    " "8.8.4.4    " "208.67.220.220" "208.67.222.222" "64.20.26.145" "64.20.26.17" \
"8.26.56.26" "8.20.247.20" "209.244.0.3" "156.154.70.1" "156.154.71.1" "216.146.36.36" "172.98.193.42" "192.99.85.244" \
"18.215.88.41" "198.206.14.241" "195.46.39.39" "195.46.39.40" "84.200.69.80" "84.200.70.40"
do
  echo -e "$dns says:\t $(dig +noall +answer @$dns -t $typeQuery $hostName)"
done
