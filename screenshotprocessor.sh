#!/bin/bash
#
# Called from incron when a file arrives in ~/Pictures.
# Copies file to /tmp/ss and adds a drop shadow.
#
filePath="$1"
file=$(basename "$filePath")
rm -rf /tmp/ss
mkdir /tmp/ss
cp "$filePath" /tmp/ss/.
newFilePath="/tmp/ss/$file"
logger "$0 Processing $filePath to $newFilePath"
convert "$newFilePath" \( -clone 0 -background black -shadow 80x3+0+8 \) -reverse -background none -layers merge +repage "$newFilePath"
logger "$0 Screenshot ready $newFilePath"
