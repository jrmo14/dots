#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Kill music helper
kill -9 $(ps ax | grep "python3 .*music_control.py" | grep -v grep | awk '{print $1}')

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done


if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar top &
  done
else
  polybar top &
fi

$HOME/.config/polybar/scripts/music_control.py &
