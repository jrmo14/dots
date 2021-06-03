#!/bin/bash
IMAGES=$(fd ".[jpg,png]" $HOME/Pictures/wallpaper/blessed)

wallpaper=$(ls -d $IMAGES | sort -R | tail -1)
feh --bg-scale $wallpaper
