#!/bin/bash
SECONDS=10
logger "$0 Sleeping for $SECONDS seconds"
sleep $SECONDS
logger "$0 changing monitor to portrait mode."
xrandr -o left
sleep 3
logger "$0 Start Gplus auto-refresh kiosk"
/home/htplainf/utils/osdTime.sh &
dimensions=$(xrandr | grep '*' | cut -d ' ' -f 4)
width=$(echo $dimensions | cut -d 'x' -f 2)
width=$(($width - 100))
echo "Width: $width"
#cairo-clock --xposition $width --yposition 0 --ontop &
/home/htplainf/utils/refreshGplus.sh &

