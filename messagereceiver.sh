#!/bin/bash
port=55555
nc -l $port | while read msg; do zenity --info --text="$msg"; done
