#!/bin/bash
#
# Alert me when my Bolt EV is no longer in transit.
#
if [ $# -ne 3 ]
then
  echo -e "Pass your email address, VIN and Chevrolet domain name.\nExample: ./monitorBoltEvTransit.sh me@gmail.com XXXXXXXXXXXXXXXXX jimmybobchevy.com"
  exit -1
fi
emailAddress="$1"
VIN="$2"
domainName="$3"
while true
do
  result=$(curl --silent "http://$domainName/VehicleSearchResults?make=Chevrolet&model=Bolt%20EV" | grep "$VIN"  | grep -i transit)
  if [ -z "$result" ]
  then
    msg="Chevrolet Bolt EV $VIN is no longer in transit. - $(date)"
    echo "$msg" | /usr/bin/mail -s "$msg" "$emailAddress"
    logger "$0 $msg"
    exit
  fi
  echo "Sleeping. VIN $VIN still in transit according to $domainName. $(date)"
  sleep 10m
done
