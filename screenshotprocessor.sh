#!/bin/bash
# Screenshot Processor
# Called from incron when a file arrives in ~/Pictures.
# Copies file to /tmp/ss and adds a drop shadow.
# Directory /tmp/ss is used so that I don't have to weed through
# dozens of files in ~/Pictures when I embed the screenshot in an email.
# Also copies the image file to the clipboard.
# incrontab entry sample below:
# /home/user_joe/Pictures IN_CLOSE_WRITE /home/user_joe/utils/screenshotprocessor.sh $@/$#
#
export DISPLAY=:0
filePath="$1"
file=$(basename "$filePath")
rm -rf /tmp/ss
mkdir /tmp/ss
cp "$filePath" /tmp/ss/.
newFilePath="/tmp/ss/$file"
logger "$0 Processing $filePath to $newFilePath"
convert "$newFilePath" \( -clone 0 -background black -shadow 80x3+0+8 \) -reverse -background none -layers merge +repage "$newFilePath"
/usr/bin/curl -v -i -F "filedata=@$newFilePath" "http://up.pla1.net"
/usr/bin/python ~/utils/image2clipboard.py "$newFilePath"
/usr/bin/notify-send --icon=/usr/share/icons/Humanity/apps/48/gnome-screenshot.svg "Screenshot ready" "File is $newFilePath"
xdg-open http://l.pla1.net &
logger "$0 Screenshot ready $newFilePath"
