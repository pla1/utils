#!/bin/bash
#
# Download file handler. incron is montioring ~/Downloads. 
# This script will be called when files are created in the Downloads folder. 
#
file="$1"
#fileType=$(/usr/bin/file "$1" | cut -d':' -f2)
/usr/bin/logger "$0 $1 created."
exit


if [[ "$file" == *mpg* ]]
then
  logger "$0 launching mplayer on file $file"
  /usr/bin/mplayer "$file"
else
  logger "$0 is not a mpg file."
fi

