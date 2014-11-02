#!/bin/bash
directoryFileName=$1
fileName=$(basename "$directoryFileName")
workDirectory="/tmp/$0"
if [ -z "$fileName" ]
then
  echo "Missing image file name. Please pass an image name."
  echo "For example: ./rotateAnimate.sh imageName.jpg"
  exit -1
fi
rm -rf "$workDirectory"
mkdir "$workDirectory"
for i in {0..360..10}
do
  outputFile="$workDirectory/$(($i+1000))$fileName"
  echo "Output file: $outputFile"
  convert "$directoryFileName" -distort ScaleRotateTranslate $i "$outputFile"
done
cd "$workDirectory"
dotGif=".gif"
echo "Creating gif file: $workDirectory/$fileName$dotGif from rotated images."
convert -loop 0 -layers optimize -limit memory 2000 * "$workDirectory/$fileName$dotGif"
xdg-open "$workDirectory/$fileName$dotGif"
