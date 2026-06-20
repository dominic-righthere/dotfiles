#!/bin/bash
# Module: control_center — gear at the far-right corner. Popup toggles each
# non-essential module on/off (persisted) + a zen-mode row. Essential.
sketchybar --add item control_center right \
           --set control_center \
                 icon="󰒓" icon.color=$IRIS label.drawing=off \
                 background.color=$OVERLAY background.drawing=on \
                 background.height=26 background.corner_radius=10 \
                 popup.align=right popup.y_offset=6 \
                 script="$PLUGIN_DIR/control_center.sh" \
           --subscribe control_center mouse.clicked mouse.exited.global zen_toggle

# Header
sketchybar --add item cc.header popup.control_center \
           --set cc.header icon="󰒓" icon.color=$IRIS label="Modules" label.color=$TEXT \
                 icon.padding_left=12 label.padding_right=16 background.drawing=off

# One toggle row per non-essential module
for m in "${MODULES[@]}"; do
  _in_list "$m" "${ESSENTIALS[@]}" && continue
  if module_enabled "$m"; then box="󰄬"; col=$FOAM; else box="󰄱"; col=$MUTED; fi
  sketchybar --add item cc.$m popup.control_center \
             --set cc.$m icon="$box" icon.color="$col" label="$m" label.color=$TEXT \
                   icon.padding_left=12 label.padding_right=16 background.drawing=off \
                   click_script="$PLUGIN_DIR/control_center.sh toggle $m"
done

# Zen-mode row
if zen_enabled; then zbox="󰄬"; zcol=$GOLD; else zbox="󰄱"; zcol=$MUTED; fi
sketchybar --add item cc.zen popup.control_center \
           --set cc.zen icon="$zbox" icon.color="$zcol" label="zen mode" label.color=$TEXT \
                 icon.padding_left=12 label.padding_right=16 background.drawing=off \
                 click_script="$PLUGIN_DIR/control_center.sh zen"
