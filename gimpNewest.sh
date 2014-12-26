#!/bin/bash
FILE=`ls ~/Pictures/*.png -Art | tail -n 1`
gimp "$FILE"

