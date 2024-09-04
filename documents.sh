#!/bin/bash

files=$(fd --type f .pdf$ $HOME/Documents -I --print0 | sed 's/\x0/\n/g' |sed "s|^$HOME/Documents/||")
selection="$(rofi -no-lazy-grab -sep "\n" -dmenu -i -p 'Pdfs' \
-hide-scrollbar true -bw 0 -lines 5 -line-padding 10 -padding 20 -width 30 -xoffset 8 -yoffset 32 \
-location 1 -columns 2 -show-icons -icon-theme "Papirus" -theme $HOME/.config/rofi/menu.rasi <<< $files)"
if [ ! -z "$selection" ]; then
  evince "$HOME/Documents/$selection"
fi
