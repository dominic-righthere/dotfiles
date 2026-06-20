#!/bin/bash
# Module: clock — date + time (essential; always on).
sketchybar --add item clock right \
           --set clock update_freq=10 icon="󰃭" icon.color=$IRIS script="$PLUGIN_DIR/clock.sh"
SYSTEM_ITEMS+=( clock )
