#!/bin/bash
# Module: battery — level + charge state (tinted in the plugin).
sketchybar --add item battery right \
           --set battery update_freq=120 icon.color=$GOLD script="$PLUGIN_DIR/battery.sh" \
           --subscribe battery system_woke power_source_change
SYSTEM_ITEMS+=( battery )
