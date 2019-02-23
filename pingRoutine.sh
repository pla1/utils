#!/bin/bash
#
# PING a device forever and log to text file
#
if [ "$#" -ne 1 ]
then
  echo "Missing parameter: IP"
  echo "Example: $0 8.8.8.8"
  exit -1
fi
logFile="ping_$1.txt"
echo "Log file: $logFile"
rm -f "$logFile"
while true
do
  date >> "$logFile"
  ping -c 60 -q "$1" >> "$logFile"
done
