#!/usr/bin/env bash
# Highlight the focused workspace pill. Receives the workspace id as $1 and
# the focused workspace in $FOCUSED_WORKSPACE (from aerospace_workspace_change).
source "$CONFIG_DIR/colors.sh"

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --animate sin 10 --set "$NAME" \
    background.drawing=on label.color=$BASE
else
  sketchybar --animate sin 10 --set "$NAME" \
    background.drawing=off label.color=$SUBTLE
fi
