#!/bin/bash
#
# This will playback YouTube videos. It reads a text file 
# containing the video IDs which was built with the 
# server companion script RemoteYouTubePlayerServer.sh. 
# You should have some kind of Flash block installed on 
# your browser so the videos don't playback on your browser. 
#
# NOTE: This script will fail if the YouTube video ID 
#       contains a dash. For example: id=-s-pxB7kIsQ

lastid=""
echo "Waiting for download links..."
while(true); do
  if [[ -f /mnt/disk0/mythtv/yt/yt.txt ]]; then
    tail -n 1 /mnt/disk0/mythtv/yt/yt.txt > /tmp/yt2.txt
    . /tmp/yt2.txt
    if [[ "$id" != "$lastid" ]]; then
	COOKIE_FILE=/var/tmp/youtube-dl-cookies.txt
	mplayer -fs -cache 2048 -cookies -cookies-file ${COOKIE_FILE} $(/home/htplainf/youtube-dl/youtube-dl -g --cookies ${COOKIE_FILE} $id)	
    fi
    lastid="$id"
  fi
  sleep 1
done

