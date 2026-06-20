#!/usr/bin/env bash
# Driver for all workspace pills: highlight the focused one (rose fill), dim
# empties, and set each pill's per-window dots. One pass over all workspaces.
source "$CONFIG_DIR/colors.sh"

focused="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"
nonempty="$(aerospace list-workspaces --monitor all --empty no 2>/dev/null)"

for sid in $(aerospace list-workspaces --all 2>/dev/null); do
  # Only non-empty workspaces need a (slightly pricier) window count.
  if printf '%s\n' "$nonempty" | grep -qx "$sid"; then
    count=$(aerospace list-windows --workspace "$sid" --count 2>/dev/null)
  else
    count=0
  fi
  [ -z "$count" ] && count=0

  # dots: one '·' per window, capped at 5 then '+'
  dots=""; n=$count; [ "$n" -gt 5 ] && n=5
  d=0; while [ "$d" -lt "$n" ]; do dots="${dots}·"; d=$((d+1)); done
  [ "$count" -gt 5 ] && dots="${dots}+"

  if [ "$sid" = "$focused" ]; then
    sketchybar --animate sin 10 --set "space.$sid" background.drawing=on label.color=$WS_ACTIVE_FG
  elif [ "$count" -eq 0 ]; then
    sketchybar --set "space.$sid" background.drawing=off label.color=$WS_EMPTY_FG
  else
    sketchybar --set "space.$sid" background.drawing=off label.color=$WS_INACTIVE_FG
  fi
  sketchybar --set "space.$sid.dots" label="$dots"
done
