#!/bin/bash
# Module: layout — tiling cheatsheet glyph (icon-only), merged into the
# window-management island next to the workspaces. Click (or ? in layout mode)
# toggles the popup; aerospace.toml triggers aerospace_mode to light it up as
# the LAYOUT indicator. The island background is provided by the workspaces
# bracket, so this item draws no background of its own (until layout mode).
sketchybar --add item layout left \
           --set layout \
                 icon="󰕴" \
                 icon.color=$TEXT \
                 label.drawing=off \
                 padding_left=2 \
                 padding_right=2 \
                 icon.padding_left=4 \
                 icon.padding_right=4 \
                 background.drawing=off \
                 popup.align=left \
                 popup.y_offset=6 \
                 popup.height=22 \
                 script="$PLUGIN_DIR/layout.sh" \
           --subscribe layout mouse.clicked mouse.entered mouse.exited mouse.exited.global aerospace_mode

# Cheatsheet — its own design: monospace Hack for the command column, a clean
# system sans for descriptions, plain-text modifiers (no uneven glyphs).
# Rows are "TYPE|command|action": T=title, H=section header, R=command row.
SANS=".AppleSystemUIFont"          # macOS system sans (SF) — any fallback is still SF
CMD_FONT="$FONT:Bold:12.0"          # Hack mono, the key column
DESC_FONT="$SANS:Regular:13.0"      # descriptions
HDR_FONT="$SANS:Bold:11.0"          # section headers
TITLE_FONT="$SANS:Bold:13.0"

rows=(
  "T|󰕴|AeroSpace shortcuts"
  "H||GLOBAL  (any time)"
  "R|opt /|tiles: toggle horizontal / vertical"
  "R|opt ,|accordion"
  "R|opt h j k l|focus window"
  "R|opt shift hjkl|move window"
  "R|opt shift - =|shrink / grow"
  "R|opt shift t|enter Layout mode"
  "R|opt shift z|toggle zen bar"
  "R|opt shift ;|service mode (reload / close all)"
  "H||LAYOUT MODE  (opt shift t)"
  "R|h j k l|focus target window"
  "R|shift h j k l|join: build a nested split"
  "R|t|toggle horizontal / vertical"
  "R|a / f|accordion / float"
  "R|b|balance sizes (even grid)"
  "R|r|reset (flatten to one row)"
  "R|- / =|resize"
  "R|?|show / hide this cheatsheet"
  "R|esc|exit Layout mode"
  "H||RECIPES"
  "R|1 + 2,3|focus the right window, then shift K"
  "R|two rows|opt / until the split is vertical"
  "R|2x2 grid|join two pairs, then b"
  "R|3x3 grid|three columns, join each, then b"
)

i=0
for row in "${rows[@]}"; do
  IFS='|' read -r kind cmd desc <<< "$row"
  name="layout.$i"
  case "$kind" in
    T)
      sketchybar --add item "$name" popup.layout \
                 --set "$name" \
                       icon="$cmd" icon.color=$FOAM icon.font="$FONT:Bold:14.0" \
                       icon.padding_left=16 icon.padding_right=10 \
                       label="$desc" label.color=$TEXT label.font="$TITLE_FONT" \
                       label.padding_right=20 background.drawing=off ;;
    H)
      sketchybar --add item "$name" popup.layout \
                 --set "$name" \
                       icon.drawing=off \
                       label="$desc" label.color=$GOLD label.font="$HDR_FONT" \
                       label.padding_left=16 label.padding_right=14 \
                       background.drawing=on background.color=$OVERLAY \
                       background.height=18 background.corner_radius=4 ;;
    R)
      sketchybar --add item "$name" popup.layout \
                 --set "$name" \
                       icon="$cmd" icon.color=$FOAM icon.font="$CMD_FONT" \
                       icon.width=140 icon.align=left \
                       icon.padding_left=16 icon.padding_right=6 \
                       label="$desc" label.color=$TEXT label.font="$DESC_FONT" \
                       label.padding_left=4 label.padding_right=20 background.drawing=off ;;
  esac
  i=$((i+1))
done
