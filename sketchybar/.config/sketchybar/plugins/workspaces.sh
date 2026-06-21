#!/usr/bin/env bash
# Driver for all workspace pills: highlight the focused one (rose fill), keep
# workspaces-with-windows bright, dim the empties. Cheap: two aerospace queries
# total (focused + non-empty list), no per-workspace counts.
source "$CONFIG_DIR/colors.sh"

focused="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"
nonempty="$(aerospace list-workspaces --monitor all --empty no 2>/dev/null)"

for sid in $(aerospace list-workspaces --all 2>/dev/null); do
  if [ "$sid" = "$focused" ]; then
    sketchybar --animate sin 10 --set "space.$sid" background.drawing=on label.color=$WS_ACTIVE_FG
  elif printf '%s\n' "$nonempty" | grep -qx "$sid"; then
    sketchybar --set "space.$sid" background.drawing=off label.color=$WS_INACTIVE_FG
  else
    sketchybar --set "space.$sid" background.drawing=off label.color=$WS_EMPTY_FG
  fi
done
