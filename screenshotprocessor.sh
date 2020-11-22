#!/bin/bash
#
# Screenshot Processor
# Called from incron when a file arrives in ~/Pictures.
# Copies file to /tmp/ss and adds a drop shadow.
# Directory /tmp/ss is used so that I don't have to weed through
# dozens of files in ~/Pictures when I embed the screenshot in an email.
# Also copies the image file to the clipboard.
# incrontab entry sample below:
# /home/user_joe/Pictures IN_CLOSE_WRITE /home/user_joe/utils/screenshotprocessor.sh $@/$#
#
# Also uploads screenshot to Google Drive using gdrive command. You need to set the Google Drive parent
# folder id in file /etc/environment. The variable name is: GDRIVE_SCREENSHOT_FOLDER_ID
#
# Gdrive can be downloaded here: https://github.com/gdrive-org/gdrive
#
#
logger "Start $0 $1"
export DISPLAY=:0
filePath="$1"
file=$(basename "$filePath")
rm -rf /tmp/ss
mkdir /tmp/ss
cp "$filePath" /tmp/ss/.
newFilePath="/tmp/ss/$file"
convert "$newFilePath" \( -clone 0 -background black -shadow 80x3+0+8 \) -reverse -background none -layers merge +repage label:"Screenshot by PLA $(date)" -background black -fill white -font Ubuntu -gravity Center -append "$newFilePath"
gdriveParentFolder=$(cat /etc/environment | grep GDRIVE_SCREENSHOT_FOLDER_ID | cut -d '=' -f2)
logger "$0 gdrive parent folder $gdriveParentFolder"
output=$(/usr/local/bin/gdrive upload --parent "$gdriveParentFolder" "$newFilePath")
logger "OUTPUT: $output"
fileId=$(echo "$output" | tr -d '\n' | cut -d ' ' -f 3)
output=$(/usr/local/bin/gdrive info "$fileId")
viewUrl=$(echo "$output" | tr '\n' ' ' | cut -d ' ' -f 25)
echo "$viewUrl" > /tmp/viewUrl.txt
/usr/bin/xclip -selection clipboard -target text/plain -in /tmp/viewUrl.txt
sleep 1
/usr/bin/xclip -selection clipboard -target image/png  -in "$newFilePath"
/usr/bin/notify-send --icon="$newFilePath" "Screenshot ready" "File is $newFilePath"
logger "Screenshot ready $newFilePath - $0"
