#!/usr/bin/env bash
# Driver for the per-session Claude indicators (the `claude` anchor item polls this).
# Reads the tmux-agent-notifier state dirs, builds an ordered list of ACTIVE sessions
# (waiting first, then working; idle excluded), writes a slot->session map for the
# hover handler, pulses the anchor robot, and lights one ● dot per session.
# Cheap: greps small state files (no capture-pane). No notifier = no dirs = all hidden.
source "$CONFIG_DIR/colors.sh"

ACTIVE_DIR="$HOME/.local/share/agent-notifier/active"
NOTIF_DIR="$HOME/.local/share/agent-notifier/notifications"
MAP="${XDG_CACHE_HOME:-$HOME/.cache}/sketchybar/claude.slots"
PHASE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/sketchybar/claude.phase"
SLOTS=12
NOW=$(date +%s)

field() { grep -m1 "^$2=" "$1" 2>/dev/null | cut -d= -f2-; }

# Collect entries as "state|key|session" — waiting first (so they take the low slots).
entries=()
collect() {  # <dir> <type> <max_age>
  local dir="$1" want="$2" max="$3" f ts
  [ -d "$dir" ] || return
  for f in "$dir"/*; do
    [ -f "$f" ] || continue
    [ "$(field "$f" TYPE)" = "$want" ] || continue
    ts=$(field "$f" TIMESTAMP); [ $((NOW - ${ts:-0})) -lt "$max" ] || continue
    entries+=( "$want|$(basename "$f")|$(field "$f" SESSION)" )
  done
}
collect "$NOTIF_DIR"  waiting 86400
collect "$ACTIVE_DIR" working 3600
count=${#entries[@]}

# slot -> session map for the hover handler
: > "$MAP"
idx=0
for e in "${entries[@]}"; do echo "$idx|$e" >> "$MAP"; idx=$((idx + 1)); done

# Anchor robot: pulse foam (or gold if anything is waiting); hidden when none active.
any_waiting=0
for e in "${entries[@]}"; do [ "${e%%|*}" = "waiting" ] && { any_waiting=1; break; }; done
phase=$(cat "$PHASE_FILE" 2>/dev/null); if [ "$phase" = "1" ]; then phase=0; else phase=1; fi
echo "$phase" > "$PHASE_FILE"
if [ "$count" -gt 0 ]; then
  if [ "$any_waiting" = "1" ]; then base=$GOLD; dim=0x66f6c177; else base=$FOAM; dim=0x669ccfd8; fi
  col=$base; [ "$phase" = "1" ] && col=$dim
  sketchybar --animate sin 20 --set claude drawing=on icon.color="$col"
else
  sketchybar --set claude drawing=off
fi

# Dots: one per active session, coloured by state; overflow folded into the last slot.
args=()
i=0
while [ "$i" -lt "$SLOTS" ]; do
  if [ "$i" -lt "$count" ]; then
    if [ "$i" -eq $((SLOTS - 1)) ] && [ "$count" -gt "$SLOTS" ]; then
      args+=( --set claudesess.$i drawing=on icon="+$((count - SLOTS + 1))" icon.color=$SUBTLE )
    else
      col=$FOAM; [ "${entries[$i]%%|*}" = "waiting" ] && col=$GOLD
      args+=( --set claudesess.$i drawing=on icon="●" icon.color=$col )
    fi
  else
    args+=( --set claudesess.$i drawing=off )
  fi
  i=$((i + 1))
done
sketchybar "${args[@]}"
