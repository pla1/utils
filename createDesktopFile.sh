#!/bin/bash
executable=$1
filename=$2
description=$3
icon=$4
if [[ -z "$executable" || -z "$filename" || -z "$description" || -z "$icon" ]]
then
  echo "There are 4 required parameters. They are the executable, the desktop file name, the description and the icon file name."
  echo "For example: ./createDesktopFile.sh /usr/bin/xbmc xbmc.desktop 'XBMC Media Center' /usr/share/app-install/icons/xbmc.png"
  exit 0
fi
echo "[Desktop Entry]" > "$filename"
echo "Name=$description" >> "$filename"
echo "Type=Application" >> "$filename"
echo "Icon=$icon" >> "$filename"
echo "Exec=$executable" >> "$filename"
chmod +x "$filename"

