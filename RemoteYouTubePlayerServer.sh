#!/bin/sh
# Remote YouTube Player Server script. When you click 
# on YouTube URL this script will build append the 
# video ID to a text file that the Client will read. 
# The video will play back on the Client. This Client 
# will be running the companion script RemoteYouTubePlayerClient.sh. 
#
# NOTE: This script must run with root privaleges because of the ngrep command. 
#
# GIT URL for this script: git://github.com/pla1/utils.git
# GIT URL for youtube-dl: https://github.com/rg3/youtube-dl/
# This script based off of this: https://github.com/tlvince/ytmp

INTERFACE=eth0

rm /tmp/yt.txt 2> /dev/null
rm /mnt/disk0/mythtv/yt/yt.txt 2> /dev/null

FILTERS="
    s/GET \/ HTTP\/1\.1\.//                                                 # Unwanted GET headers
    s/.*=\([_a-zA-Z0-9-]\{11,11\}\)[ &].*/id=\1/              		    # Youtube video ID
    s/.*video_id%22%3A%22\([_a-zA-Z0-9-]\{11,11\}\).*/id=\1/                # Youtube channel video ID
"

ngrep -W byline -qil 'get|session' tcp dst port 80 -d "$INTERFACE" | \
egrep --line-buffered -i "(get\ /watch|GET \/[0-9]* .*|^session_token.*)" | \
sed --unbuffered -e "$FILTERS" >> /mnt/disk0/mythtv/yt/yt.txt




