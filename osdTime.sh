#!/bin/bash
while true
do
  date +"%I:%m %p"  | osd_cat -d 30 --pos top --align right --font "-misc-fixed-bold-r-normal-*-50-*-*-100-*-*-*-*"
done
