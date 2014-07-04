#!/bin/bash
#
# Send an email when the web page content changes.
#
URL=$1
EMAIL_ADDRESS=$2
if [[ ! "$URL" =~ http.* ]];
then
  echo "Please pass a URL as the first parameter."
  exit -1
fi
if [[ ! "$EMAIL_ADDRESS" =~ .*@.* ]];
then
  echo "Please pass an email address as the second parameter."
  exit -1
fi
function log () {
  echo "$0 $1"
  logger "$0 $1"
}

while true
do
  wget -O /tmp/alertWhenChanged.html "$URL"
  if [ -f /tmp/alertWhenChangedPrevious.html ];
  then
    DIFF_RESULT=`diff /tmp/alertWhenChanged.html /tmp/alertWhenChangedPrevious.html`
    if [ -z $DIFF_RESULT ];
    then
      log "No change to: $URL"
    else
      log "Change detected at: $URL. Sending email and quitting."
      echo "Web page content changed $URL" | mail -s "Web page content changed." "$EMAIL_ADDRESS"
      exit 0
    fi
  fi
  cp /tmp/alertWhenChanged.html /tmp/alertWhenChangedPrevious.html
  sleep 60
done
