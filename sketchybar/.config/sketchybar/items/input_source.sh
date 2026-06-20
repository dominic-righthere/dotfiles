#!/bin/bash
# Module: input_source — current keyboard language (EN / 한 / あ).
sketchybar --add item input_source right \
           --set input_source update_freq=1 icon="󰗊" icon.color=$IRIS label="…" \
                 script="$PLUGIN_DIR/input_source.sh"
SYSTEM_ITEMS+=( input_source )
