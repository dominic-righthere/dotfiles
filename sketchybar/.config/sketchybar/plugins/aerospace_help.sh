#!/usr/bin/env bash
# Drives the layout glyph (icon-only, merged into the window-management island):
#   click            -> toggle the cheatsheet popup
#   hover in/out     -> tint the glyph
#   leave the bar    -> hide the popup
#   aerospace_mode   -> light it up as the "LAYOUT" indicator ($MODE)
source "$CONFIG_DIR/colors.sh"

case "$SENDER" in
  mouse.clicked)
    sketchybar --set "$NAME" popup.drawing=toggle
    ;;
  mouse.entered)
    sketchybar --set "$NAME" icon.color=$FOAM
    ;;
  mouse.exited)
    sketchybar --set "$NAME" icon.color=$IRIS
    ;;
  mouse.exited.global)
    sketchybar --set "$NAME" popup.drawing=off
    ;;
  aerospace_mode)
    if [ "$MODE" = "layout" ]; then
      sketchybar --animate sin 10 --set "$NAME" \
        background.drawing=on background.color=$IRIS \
        icon.color=$BASE label="LAYOUT" label.drawing=on label.color=$BASE
    else
      sketchybar --animate sin 10 --set "$NAME" \
        background.drawing=off label.drawing=off icon.color=$IRIS popup.drawing=off
    fi
    ;;
esac
