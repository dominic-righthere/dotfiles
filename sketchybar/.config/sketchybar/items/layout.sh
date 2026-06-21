#!/bin/bash
# Module: layout — tiling cheatsheet glyph (icon-only), merged into the
# window-management island next to the workspaces. Click (or ? in layout mode)
# toggles the popup; aerospace.toml triggers aerospace_mode to light it up as
# the LAYOUT indicator. The island background is provided by the workspaces
# bracket, so this item draws no background of its own (until layout mode).
sketchybar --add item aerospace_help left \
           --set aerospace_help \
                 icon="󰕴" \
                 icon.color=$IRIS \
                 label.drawing=off \
                 background.drawing=off \
                 background.color=$IRIS \
                 background.height=22 \
                 background.corner_radius=6 \
                 popup.align=left \
                 popup.y_offset=6 \
                 script="$PLUGIN_DIR/aerospace_help.sh" \
           --subscribe aerospace_help mouse.clicked mouse.entered mouse.exited mouse.exited.global aerospace_mode

# Cheatsheet rows ("key|description") built as popup children.
help_rows=(
  "󰕴|AeroSpace layout cheatsheet"
  "⌥ /|tiles — toggle h ↔ v"
  "⌥ ,|accordion"
  "⌥ hjkl|focus window"
  "⌥⇧ hjkl|move window"
  "⌥⇧ -/=|resize"
  "⌥⇧ T|◆ enter LAYOUT mode:"
  "h j k l|· focus target window"
  "⇧ hjkl|· join → build a split"
  "t|· toggle horizontal/vertical"
  "a · f|· accordion · float"
  "b|· balance (even grid)"
  "r|· reset (flatten)"
  "?|· show/hide this help"
  "esc|· exit layout mode"
  "1│2,3|focus right win → ⇧K"
  "two rows|⌥ / until vertical"
  "2×2|join two pairs → b"
)
i=0
for row in "${help_rows[@]}"; do
  key="${row%%|*}"; desc="${row#*|}"
  sketchybar --add item aerospace_help.$i popup.aerospace_help \
             --set aerospace_help.$i \
                   icon="$key" icon.color=$IRIS \
                   icon.padding_left=12 icon.padding_right=10 \
                   label="$desc" label.color=$TEXT \
                   label.padding_right=14 background.drawing=off
  i=$((i+1))
done
