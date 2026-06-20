#!/bin/bash
# Module: audio — volume + output device (read-only). scroll=volume,
# left-click=popup, right-click=mute.
sketchybar --add item audio right \
           --set audio icon="󰕾" icon.color=$FOAM label="…" \
                 popup.align=right popup.y_offset=6 \
                 script="$PLUGIN_DIR/audio.sh" \
           --subscribe audio volume_change mouse.scrolled mouse.clicked mouse.exited.global

# Popup: current output device (+ Bluetooth battery) and the volume level.
sketchybar --add item audio.device popup.audio \
           --set audio.device icon="󰋋" icon.color=$FOAM label="…" label.color=$TEXT \
                 icon.padding_left=12 label.padding_right=16 background.drawing=off
sketchybar --add item audio.level popup.audio \
           --set audio.level icon="󰕾" icon.color=$SUBTLE label="…" label.color=$SUBTLE \
                 icon.padding_left=12 label.padding_right=16 background.drawing=off

SYSTEM_ITEMS+=( audio )
