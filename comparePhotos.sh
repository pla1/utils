#!/bin/bash
files="/mnt/disk0/tmp/*.png"
previousFile=""
threshold="0.59"
for file in $files
do
  difference=$(convert $previousFile $file -compose Difference -composite  -format '%[fx:mean*100]' info:)
  echo "Difference between file1: $previousFile and file2: $file is: $difference"
  if [[ $(echo "if (${difference} > ${threshold}) 1 else 0" | bc) -eq 1 ]]
  then
    xdg-open "$file"
    xdg-open "$previousFile"
    exit
  fi
  previousFile=$file
done
