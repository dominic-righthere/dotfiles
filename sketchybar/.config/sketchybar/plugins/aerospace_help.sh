#!/usr/bin/env bash
# Drives the layout help pill:
#   click            -> toggle the cheatsheet popup
#   hover in/out     -> brighten/restore the pill
#   leave the bar    -> hide the popup
#   aerospace_mode   -> flip into / out of the "LAYOUT" indicator ($MODE)
# Wired in sketchybarrc; aerospace.toml triggers aerospace_mode on enter/exit.
source "$CONFIG_DIR/colors.sh"

case "$SENDER" in
  mouse.clicked)
    sketchybar --set "$NAME" popup.drawing=toggle
    ;;
  mouse.entered)
    sketchybar --animate sin 10 --set "$NAME" background.color=$HL_MED
    ;;
  mouse.exited)
    sketchybar --animate sin 10 --set "$NAME" background.color=$OVERLAY
    ;;
  mouse.exited.global)
    sketchybar --set "$NAME" popup.drawing=off
    ;;
  aerospace_mode)
    if [ "$MODE" = "layout" ]; then
      sketchybar --animate sin 10 --set "$NAME" \
        label="● LAYOUT" label.color=$BASE icon.color=$BASE background.color=$IRIS
    else
      sketchybar --animate sin 10 --set "$NAME" \
        label="layout" label.color=$SUBTLE icon.color=$IRIS background.color=$OVERLAY \
        popup.drawing=off
    fi
    ;;
esac
