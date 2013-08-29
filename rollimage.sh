#!/bin/bash
# Create animated GIF with the Ubuntu logo.
cd /mnt/disk0/tmp
j=0
rm _ubuntu*.png
for i in {100..150}
do
        let j=j+35
	convert -roll +$j+$j  ubuntu.png _ubuntu$i.png
done
convert -limit memory 2000 -loop 0 -resize 400 -dispose previous _ubuntu*.png ubuntu.gif
xdg-open ubuntu.gif
