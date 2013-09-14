#!/bin/bash
# Remote desktop using 90% of screen size
device=$1
y=$(xrandr --current | grep '*' | uniq | awk '{print $1}' |  cut -d 'x' -f2)
x=$(xrandr --current | grep '*' | uniq | awk '{print $1}' |  cut -d 'x' -f1)
MaxRes=$(($x-100))"x"$(($y-80))
echo "$MaxRes to remote station $device"
rdesktop -d hometelco.lcl -g $MaxRes $device
