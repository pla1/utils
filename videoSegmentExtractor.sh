#!/bin/bash
#
# Extract 3 second video segments every 5 minutes from cycling GoPro video files
#
convertsecs() {
 ((h=${1}/3600))
 ((m=(${1}%3600)/60))
 ((s=${1}%60))
 printf "%02d:%02d:%02d\n" $h $m $s
}
files="$1"
clipLength=3
rm -rf /tmp/vse
mkdir /tmp/vse
fileNumber=10000
for file in $files
do
  videoLength=$(/usr/bin/ffprobe -i "$file" -show_entries format=duration -v quiet -of csv="p=0")
  videoLength=$(echo "$videoLength" | awk '{print int($1+0.5)}')
  echo "$file is $videoLength seconds long"
  i=0
  while [ $i -lt "$videoLength" ]
  do
    startTime=$(convertsecs $i)
    outputFile="/tmp/vse/$fileNumber.mp4"
    echo "file '$outputFile'">>/tmp/vse/fileList.txt
    echo "Start: $startTime Output file: $outputFile"
    ffmpeg  -hide_banner -loglevel panic -ss "$startTime" -t $clipLength -i "$file" -async 1 "$outputFile"
    ((i+=300))
    ((fileNumber++))
  done
done
ffmpeg -f concat -safe 0 -i /tmp/vse/fileList.txt -c copy /tmp/vse/final.mp4
