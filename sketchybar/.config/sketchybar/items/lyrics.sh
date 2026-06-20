#!/bin/bash
# Module: lyrics — Apple Music synced lyrics (off by default; enable in the gear
# menu). Sits left of the system island. Polls only while music plays.
sketchybar --add item lyrics.current right \
           --set lyrics.current label.drawing=on width=0 padding_left=20 padding_right=20 \
           --add item lyrics right \
           --set lyrics update_freq=2 icon.drawing=on width=0 padding_left=15 \
                 script="$PLUGIN_DIR/lyrics.sh" \
           --subscribe lyrics media_change
