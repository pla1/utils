#!/bin/bash
# Take and store photos using gphoto2
folder=~/Pictures/$(date +"%Y/%m/%d")
echo "Pictures will be stored in $folder"
mkdir -p "$folder"
while true :
do
	gphoto2 --capture-image --get-file capt0000.jpg --folder / --hook-script test-hook.sh --force-overwrite
	now=$(date +"%Y-%m-%d-%H-%M-%S")
	file="image-$now.jpg"
	echo "Storing $folder/$file"
	mv capt0000.jpg "$folder/$file"
	sleep 60;
done

