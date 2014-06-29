
#!/bin/bash
while :
do
	win=$(xdotool search --onlyvisible "Google+" | head -1)
	echo "Window: $win"
	xdotool type --window $win "l"
	sleep 10s
done

