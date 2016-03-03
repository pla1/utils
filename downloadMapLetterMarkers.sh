#!/bin/bash
#
# Download markers for Google Maps with a letter in the marker.
#
rm -rf /tmp/markers

for letter in A B C D E F G H I J K L M N O P Q R S T U V W X Y Z 1 2 3 4 5 6 7 8 9 0
do
  for scale in 1 2 3 4
  do
    for file in spotlight-waypoint-a.png spotlight-waypoint-b.png
    do
      directory="/tmp/markers/$scale/$file/$letter"
      mkdir -p "$directory"
      wget --output-document="$directory/marker.png" "https://mts.googleapis.com/vt/icon/name=icons/spotlight/$file&text=A&psize=16&font=fonts/Roboto-Regular.ttf&color=ff000000&ax=44&ay=48&scale=$scale"
    done
  done
done
