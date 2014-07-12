#!/bin/bash
#
# Send email when domain name expires in 30 days or less.
#
DOMAIN_NAME=$1
EMAIL_ADDRESS=$2
if [ -z "$DOMAIN_NAME" ]  || [ -z "$EMAIL_ADDRESS" ]
then
  echo "Please pass the domain name in the first parameter. Email address should be the second parameter."
  exit -1
fi
LABEL="   Expiration Date: "
THRESHOLD_DAYS=30
dateString=$(whois "$DOMAIN_NAME" | grep "$LABEL" | cut -d':' -f 2)
if [ -z "$dateString" ]
then
  message="WHOIS query did not return a date string for domain name $DOMAIN_NAME"
  echo "$message"
  echo "$message" | /usr/bin/mail -s "$message" "patrick.archibald@hometelco.com"
  exit
fi
d1=$(date -d "$dateString" +%s)
d2=$(date -d "now - 30 days" +%s)
days=$(( (d1 - d2) / 86400 ))
echo "Domain name $DOMAIN_NAME expires in $days days"
if [[ $days -lt $THRESHOLD_DAYS ]]
then
  message="Domain name registration expires in $days for domain name $DOMAIN_NAME"
  echo "$message"
  echo $message | /usr/bin/mail -s "$message" "$EMAIL_ADDRESS"
fi
