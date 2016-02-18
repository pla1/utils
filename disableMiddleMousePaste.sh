#!/bin/bash
#
# Disable middle mouse button paste function. Words on Ubuntu 14.04 with ThinkPad keyboard ASIN: B00F3U4TQS
#
/usr/bin/xmodmap -e "pointer = 1 9 3 4 5 6 7 8 2"
