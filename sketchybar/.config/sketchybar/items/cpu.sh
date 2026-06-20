#!/bin/bash
# Module: cpu — load as a number (fits the island), colour by load.
sketchybar --add item cpu right \
           --set cpu update_freq=2 icon="󰓅" icon.color=$PINE label="…" \
                 script="$PLUGIN_DIR/cpu.sh"
SYSTEM_ITEMS+=( cpu )
