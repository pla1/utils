#!/bin/bash
#
# Rename files in directory with date and time.
#
directory="$1"
if [ $# -ne 1 ]
then
  echo "Pass the directory surrounded with quotes containing the files to rename."
  exit -1
fi
echo "Directory: $directory"
for fileNameFull in $directory
do
  newFileName=$(date +"%Y_%m_%d_%H_%M_%S" -r "$fileNameFull")
  fileNameOnly=$(basename "$fileNameFull")
  fileSuffix="${fileNameOnly##*.}"
  fileDirectory=$(dirname "$fileNameFull");
  echo "$fileNameFull renamed to $fileDirectory/$newFileName.$fileSuffix"
  mv "$fileNameFull" "$fileDirectory/$newFileName.$fileSuffix"
done
