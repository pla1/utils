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
script="/tmp/vse/ffmpeg-concat.sh"
GOOGLE_MAPS_API_KEY=$(printenv GOOGLE_MAPS_API_KEY)
echo "/home/htplainf/projects/bot/node_modules/.bin/ffmpeg-concat -t fade -o /tmp/vse/fade.mp4 \\" > "$script"
chmod +x "$script"
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
    echo "$outputFile \\" >> "$script"
    echo "file '$outputFile'">>/tmp/vse/fileList.txt
    echo "Start: $startTime Output file: $outputFile"
    ffmpeg -y -ss "$startTime" -t $clipLength -i "$file" -codec copy -map 0:3 -f rawvideo /tmp/GOPR0001.bin
    /home/htplainf/projects/go/bin/gopro2json -i /tmp/GOPR0001.bin -o "$outputFile".json
    firstCoordinate=$(grep -Po '"lat":[0-9]+\.[0-9]+,"lon":-?[0-9]+\.[0-9]+' "$outputFile".json | head -1)
    echo "First coordinate: $firstCoordinate"
    if [ ! -z "$firstCoordinateXXX" ]
    then
      latitude=$(echo "$firstCoordinate" | cut -d':' -f2 | cut -d',' -f1)
      longitude=$(echo "$firstCoordinate" | cut -d':' -f3 | cut -d',' -f1)
      wget "https://maps.googleapis.com/maps/api/staticmap?key=$GOOGLE_MAPS_API_KEY&size=400x400&markers=color:red%7Clabel:C%7C$latitude,$longitude" --output-document "$outputFile".png
      convert -verbose "$outputFile".png -alpha on -background none \
        \( +clone -channel A -evaluate multiply 0 +channel -fill white -draw "ellipse 200,200 190,190 0,360" \) \
        \( -clone 0,1 -compose DstOut -composite \) \
        \( -clone 0,1 -compose DstIn -composite \)  \
        -delete 0,1 circle.png
      convert circle-1.png -alpha on -channel a -evaluate multiply 0.90 +channel "$outputFile"_transparent.png
      ffmpeg  -hide_banner -loglevel panic -ss "$startTime" -t $clipLength -i "$file" -i "$outputFile"_transparent.png -filter_complex "[0:v][1:v] overlay=0:680" -pix_fmt yuv420p -c:a copy "$outputFile"
    else
      ffmpeg  -hide_banner -loglevel panic -ss "$startTime" -t $clipLength -i "$file" -c copy "$outputFile"
    fi
    ((i+=300))
    ((fileNumber++))
  done
done
ffmpeg -f concat -safe 0 -i /tmp/vse/fileList.txt -c copy /tmp/vse/final.mp4
sh "$script"
