#!/bin/bash
# Toggle conky 
result=`ps -A | grep -w conky`
if  [ -z "$result" ]
then conky &
else killall conky
fi

