#!/usr/bin/env bash

vol=$(wpctl get-volume $1)

if [[ $vol == *"MUTED"* ]]; then
	echo "0" > $WOBSOCK
else
	# Convert volume like 0.55 or 1.00 to 55 and 100, respectively
	vol_pct=$(wpctl get-volume $1 | sed 's/[^0-9]//g' | sed 's/^0//g')
	# Pipe to wob socket (configured in hyprland.conf) for on-screen display
	echo "$vol_pct" > $WOBSOCK
fi

