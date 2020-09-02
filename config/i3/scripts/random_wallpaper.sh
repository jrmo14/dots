#!/bin/bash
DIR=$HOME/Pictures/wallpaper/flat/nature/mountains/*

wallpaper=$(ls -d $DIR | sort -R | tail -1)
#feh --bg-scale $wallpaper
nitrogen --set-scaled $wallpaper
