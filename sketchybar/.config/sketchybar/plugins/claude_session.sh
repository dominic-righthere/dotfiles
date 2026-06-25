#!/usr/bin/env bash
# Hover handler for a single Claude session dot (claudesess.<i>). On hover it looks
# up which session this slot currently represents (via the driver's slot map) and
# shows a small popup with that session's name, tmux window, and message.
source "$CONFIG_DIR/colors.sh"

MAP="${XDG_CACHE_HOME:-$HOME/.cache}/sketchybar/claude.slots"
field() { grep -m1 "^$2=" "$1" 2>/dev/null | cut -d= -f2-; }

case "$SENDER" in
  mouse.exited)
    sketchybar --set "$NAME" popup.drawing=off
    exit 0 ;;
  mouse.entered) : ;;   # fall through to build + show
  *) exit 0 ;;
esac

idx="${NAME##*.}"                                  # claudesess.3 -> 3
line=$(grep -m1 "^${idx}|" "$MAP" 2>/dev/null)     # "3|working|claude_x_1|session"
IFS='|' read -r _ state key session <<< "$line"

dir="$HOME/.local/share/agent-notifier/active"
[ "$state" = "waiting" ] && dir="$HOME/.local/share/agent-notifier/notifications"
file="$dir/$key"
msg=$(field "$file" MESSAGE)
win=$(field "$file" WINDOW_NAME)

if [ "$state" = "waiting" ]; then icon="󰂚"; col=$GOLD; else icon="󰚩"; col=$FOAM; fi

sketchybar --remove "/${NAME}.row\..*/" >/dev/null 2>&1
sketchybar --add item "${NAME}.row.0" "popup.${NAME}" \
           --set "${NAME}.row.0" \
                 icon="$icon" icon.color="$col" icon.padding_left=10 icon.padding_right=8 \
                 label="${session:-session}${win:+  ·  $win}" label.color=$TEXT label.padding_right=16 \
                 background.drawing=off
if [ -n "$msg" ]; then
  sketchybar --add item "${NAME}.row.1" "popup.${NAME}" \
             --set "${NAME}.row.1" \
                   icon.drawing=off label="$msg" label.color=$SUBTLE \
                   label.padding_left=10 label.padding_right=16 background.drawing=off
fi
sketchybar --set "$NAME" popup.drawing=on
