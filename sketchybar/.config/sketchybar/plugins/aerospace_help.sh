#!/usr/bin/env bash
# Toggle the AeroSpace layout cheatsheet popup on click; hide it when the
# mouse leaves the bar. Wired in sketchybarrc via:
#   --subscribe aerospace_help mouse.clicked mouse.exited.global

case "$SENDER" in
  mouse.clicked)
    sketchybar --set "$NAME" popup.drawing=toggle
    ;;
  mouse.exited.global)
    sketchybar --set "$NAME" popup.drawing=off
    ;;
esac
