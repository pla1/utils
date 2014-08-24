#!/bin/bash
#
# Blink the scroll lock LED.
#
while true
do
 xset led 3
 sleep 0.2
 xset -led 3
 sleep 0.2
done
