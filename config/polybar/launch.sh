#!/usr/bin/env bash

# Kill previously started pollybars.
killall -q polybar

# Start the bar for each screen.
for m in $(polybar --list-monitors | cut -d":" -f1); do
  MONITOR=$m polybar --config=$HOME/.config/polybar/config.ini bar 2>&1 | tee -a /tmp/polybar_${m}.log & disown
done

