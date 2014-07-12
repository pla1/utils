#!/bin/bash
#
# Send email when domain name is about to expire.
#
# https://github.com/pla1/utils/blob/master/checkDomainNameExpiration.sh
#
function log {
  logger "$0 $1"
  echo "$0 $1"
}
DOMAIN_NAME=$1
EMAIL_ADDRESS=$2
if [ -z "$DOMAIN_NAME" ]  || [ -z "$EMAIL_ADDRESS" ]
then
  echo "Please pass the domain name in the first parameter. Email address should be the second parameter."
  exit -1
fi
LABEL="   Expiration Date: "
THRESHOLD_DAYS=35
expirationDate=$(whois "$DOMAIN_NAME" | grep "$LABEL" | cut -d':' -f 2)
if [ -z "$expirationDate" ]
then
  message="WHOIS query did not return a date string for domain name $DOMAIN_NAME"
  log "$message"
  echo "$message" | mail -s "$message" "$EMAIL_ADDRESS"
  exit
fi
d1=$(date -d "$expirationDate" +%s)
d2=$(date -d "now" +%s)
days=$(( (d1 - d2) / 86400 ))
log "Domain name $DOMAIN_NAME expires in $days days"
if [[ $days -lt $THRESHOLD_DAYS ]]
then
  message="Domain name registration expires in $days days for domain name $DOMAIN_NAME. Expiration date from WHOIS: $expirationDate"
  log "$message"
  echo $message | /usr/bin/mail -s "$message" "$EMAIL_ADDRESS"
fi
