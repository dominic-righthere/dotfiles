#!/usr/bin/env bash
# Drives the layout glyph (icon-only, merged into the window-management island,
# styled like the other items — white, no highlight):
#   click            -> toggle the cheatsheet popup
#   hover in/out     -> subtle tint
#   leave the bar    -> hide the popup
#   aerospace_mode   -> subtle gold tint while in layout mode (no bg highlight)
source "$CONFIG_DIR/colors.sh"

case "$SENDER" in
  mouse.clicked)
    sketchybar --set "$NAME" popup.drawing=toggle
    ;;
  mouse.entered)
    sketchybar --set "$NAME" icon.color=$FOAM
    ;;
  mouse.exited)
    sketchybar --set "$NAME" icon.color=$TEXT
    ;;
  mouse.exited.global)
    sketchybar --set "$NAME" popup.drawing=off
    ;;
  aerospace_mode)
    if [ "$MODE" = "layout" ]; then
      sketchybar --set "$NAME" icon.color=$GOLD
    else
      sketchybar --set "$NAME" icon.color=$TEXT popup.drawing=off
    fi
    ;;
esac
