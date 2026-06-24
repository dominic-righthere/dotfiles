#!/usr/bin/env bash
# Driver for all workspace pills: highlight the focused one (rose fill), keep
# workspaces-with-windows bright, dim the empties. Cheap: two aerospace queries
# total (focused + non-empty list), no per-workspace counts.
#
# Also auto-regroups the pills when the display setup changes (connect / disconnect
# / mirror): every tick it compares a monitor signature and reloads on a real
# change, so the per-monitor grouping stays correct without a manual reload.
source "$CONFIG_DIR/colors.sh"

sig="$(aerospace list-monitors --format '%{monitor-id}|%{monitor-name}' 2>/dev/null | sort)"
sig_cache="${XDG_CACHE_HOME:-$HOME/.cache}/sketchybar/monitors.sig"
if [ "$sig" != "$(cat "$sig_cache" 2>/dev/null)" ]; then
  printf '%s' "$sig" > "$sig_cache"
  sketchybar --reload
  exit 0
fi

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
