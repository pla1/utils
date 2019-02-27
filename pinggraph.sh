#!/bin/bash
#
# PING one or more IP addresses for websocketd to consume for displaying a chart via pinggraph.html
#
set -e
killChildredOnInterrupt () {
  echo "Going to kill children"
  ps --ppid $$
  kill $(ps -o pid= --ppid $$)
  exit 0
}
trap killChildredOnInterrupt EXIT
for ip in "$@"
do
  ping -n -D "$ip" &
done
while true
do
  sleep 1
done
