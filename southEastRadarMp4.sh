#!/bin/bash
#
# Convert SE radar from GIF to MP4.
#
dateDisplay=$(date +"%Y_%m_%d_%H_%M")
outputFile="/tmp/South_East_Radar_$dateDisplay.mp4"
wget 'https://radar.weather.gov/Conus/Loop/southeast_loop.gif' --output-document=/tmp/South_East_Radar.gif
ffmpeg -i /tmp/South_East_Radar.gif "$outputFile"
xdg-open "$outputFile"
echo "$outputFile"
