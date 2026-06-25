#!/usr/bin/env bash
# Claude Code session indicator. Reads the tmux-agent-notifier state dirs and shows:
#   waiting (any session needs an answer) -> amber robot   (takes priority)
#   running (any session working)         -> foam robot
#   neither                               -> hidden
# Each tick flips a "breathing" phase so the visible robot gently pulses (animated).
# Cheap: greps a handful of small state files, no capture-pane. No notifier = no
# state dirs = stays hidden (safe on machines without it).
source "$CONFIG_DIR/colors.sh"

ACTIVE_DIR="$HOME/.local/share/agent-notifier/active"
NOTIF_DIR="$HOME/.local/share/agent-notifier/notifications"
PHASE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/sketchybar/claude.phase"
NOW=$(date +%s)

# any_state <dir> <type> <max_age_seconds> -> exit 0 if a fresh match exists
any_state() {
  local dir="$1" want="$2" max="$3" f type ts
  [ -d "$dir" ] || return 1
  for f in "$dir"/*; do
    [ -f "$f" ] || continue
    type=$(grep -m1 '^TYPE=' "$f" | cut -d= -f2)
    [ "$type" = "$want" ] || continue
    ts=$(grep -m1 '^TIMESTAMP=' "$f" | cut -d= -f2)
    [ $((NOW - ${ts:-0})) -lt "$max" ] && return 0
  done
  return 1
}

running=0; waiting=0
any_state "$ACTIVE_DIR" working 3600  && running=1
any_state "$NOTIF_DIR"  waiting 86400 && waiting=1

# breathing pulse: alternate between full and dimmed colour each tick
phase=$(cat "$PHASE_FILE" 2>/dev/null)
if [ "$phase" = "1" ]; then phase=0; else phase=1; fi
echo "$phase" > "$PHASE_FILE"

if [ "$waiting" = "1" ]; then
  col=$GOLD; [ "$phase" = "1" ] && col=0x66f6c177          # dim amber on the off-beat
  sketchybar --animate sin 20 --set "$NAME" drawing=on icon.color="$col"
elif [ "$running" = "1" ]; then
  col=$FOAM; [ "$phase" = "1" ] && col=0x669ccfd8          # dim foam on the off-beat
  sketchybar --animate sin 20 --set "$NAME" drawing=on icon.color="$col"
else
  sketchybar --set "$NAME" drawing=off
fi
