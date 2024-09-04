#!/bin/bash
rofi -show drun -display-drun "apps" \
-bw 0 -lines 10 -line-padding 10 -padding 20 -width 30 -xoffset 8 -yoffset 32 -location 1 \
-show-icons -icon-theme "Papirus" -theme $HOME/.config/rofi/menu.rasi
