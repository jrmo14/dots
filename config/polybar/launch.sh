#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

kill -9 $(ps aux | grep "python3 .*music_control.py" | grep -v grep | awk '${print $1}')

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar main -c $HOME/.config/polybar/config.ini &
  done
else
  polybar main -c $HOME/.config/polybar/config.ini &
fi

$HOME/.config/polybar/scripts/music_control.py &
