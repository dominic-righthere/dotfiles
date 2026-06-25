#!/usr/bin/env bash
# Claude Code session indicator + hover popup. Reads the tmux-agent-notifier state
# dirs (~/.local/share/agent-notifier/{active,notifications}, written by Claude Code
# hooks). Bar item: a 󰚩 robot that pulses foam while any session is WORKING and amber
# while any is WAITING for an answer (waiting wins); hidden when idle/none. Hover the
# robot for a popup listing the waiting + working sessions (detail stays on demand).
# Cheap: greps a handful of small state files, no capture-pane. No notifier = no dirs
# = stays hidden (safe/portable).
source "$CONFIG_DIR/colors.sh"

ACTIVE_DIR="$HOME/.local/share/agent-notifier/active"
NOTIF_DIR="$HOME/.local/share/agent-notifier/notifications"
PHASE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/sketchybar/claude.phase"
NOW=$(date +%s)

field() { grep -m1 "^$2=" "$1" 2>/dev/null | cut -d= -f2-; }   # field <file> <KEY>

# any_state <dir> <type> <max_age> -> 0 if a fresh match exists
any_state() {
  local dir="$1" want="$2" max="$3" f
  [ -d "$dir" ] || return 1
  for f in "$dir"/*; do
    [ -f "$f" ] || continue
    [ "$(field "$f" TYPE)" = "$want" ] || continue
    [ $((NOW - $(field "$f" TIMESTAMP || echo 0))) -lt "$max" ] && return 0
  done
  return 1
}

ROW_I=0
add_row() {   # icon color text
  sketchybar --add item "claude.row.$ROW_I" popup.claude \
             --set "claude.row.$ROW_I" \
                   icon="$1" icon.color="$2" icon.padding_left=10 icon.padding_right=8 \
                   label="$3" label.color=$TEXT label.padding_right=16 background.drawing=off
  ROW_I=$((ROW_I + 1))
}

build_popup() {
  sketchybar --remove '/claude.row\..*/' >/dev/null 2>&1
  local f ts s m working=0
  # waiting (actionable) first
  if [ -d "$NOTIF_DIR" ]; then
    for f in "$NOTIF_DIR"/*; do
      [ -f "$f" ] || continue
      [ "$(field "$f" TYPE)" = waiting ] || continue
      ts=$(field "$f" TIMESTAMP); [ $((NOW - ${ts:-0})) -lt 86400 ] || continue
      s=$(field "$f" SESSION); m=$(field "$f" MESSAGE)
      add_row "󰂚" "$GOLD" "${s}${m:+  —  $m}"
    done
  fi
  # working (cap the list so a big fleet doesn't make a giant popup)
  if [ -d "$ACTIVE_DIR" ]; then
    for f in "$ACTIVE_DIR"/*; do
      [ -f "$f" ] || continue
      [ "$(field "$f" TYPE)" = working ] || continue
      ts=$(field "$f" TIMESTAMP); [ $((NOW - ${ts:-0})) -lt 3600 ] || continue
      working=$((working + 1))
      [ "$working" -le 10 ] && add_row "󰚩" "$FOAM" "$(field "$f" SESSION)"
    done
  fi
  [ "$working" -gt 10 ] && add_row "󰧞" "$SUBTLE" "+$((working - 10)) more working"
  [ "$ROW_I" -eq 0 ]   && add_row "󰧞" "$SUBTLE" "no active sessions"
}

case "$SENDER" in
  mouse.entered)
    build_popup
    sketchybar --set "$NAME" popup.drawing=on
    exit 0 ;;
  mouse.exited|mouse.exited.global)
    sketchybar --set "$NAME" popup.drawing=off
    exit 0 ;;
esac

# --- default (poll): state detection + breathing pulse ---
running=0; waiting=0
any_state "$ACTIVE_DIR" working 3600  && running=1
any_state "$NOTIF_DIR"  waiting 86400 && waiting=1

phase=$(cat "$PHASE_FILE" 2>/dev/null)
if [ "$phase" = "1" ]; then phase=0; else phase=1; fi
echo "$phase" > "$PHASE_FILE"

if [ "$waiting" = "1" ]; then
  col=$GOLD; [ "$phase" = "1" ] && col=0x66f6c177
  sketchybar --animate sin 20 --set "$NAME" drawing=on icon.color="$col"
elif [ "$running" = "1" ]; then
  col=$FOAM; [ "$phase" = "1" ] && col=0x669ccfd8
  sketchybar --animate sin 20 --set "$NAME" drawing=on icon.color="$col"
else
  sketchybar --set "$NAME" drawing=off
fi
