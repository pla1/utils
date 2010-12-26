#!/bin/bash 
# Take and store photos using gphoto2
while true :
do
	gphoto2 --capture-image --get-file capt0000.jpg --folder /store_00010001 --hook-script test-hook.sh --force-overwrite
	NOW=$(date +"%Y-%m-%d-%H-%M-%S")
	OUTFILE="image-$NOW.jpg"
	echo $OUTFILE
	cp capt0000.jpg $OUTFILE
	sleep 10;
done

