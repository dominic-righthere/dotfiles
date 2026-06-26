#!/usr/bin/env bash
# Driver for the per-session Claude indicators (the `claude` anchor item polls this).
# Reads the tmux-agent-notifier state dirs, builds an ordered list of ACTIVE sessions
# (waiting first, then working; idle excluded), writes a slot->session map for the
# hover handler, keeps the anchor robot steady, and lights one ● dot per session that
# gently BREATHES (alternating alpha each tick). Cheap: each state file is read once
# (builtins, no grep/basename subprocesses). No notifier = no dirs = all hidden.
source "$CONFIG_DIR/colors.sh"

ACTIVE_DIR="$HOME/.local/share/agent-notifier/active"
NOTIF_DIR="$HOME/.local/share/agent-notifier/notifications"
MAP="${XDG_CACHE_HOME:-$HOME/.cache}/sketchybar/claude.slots"
PHASE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/sketchybar/claude.phase"
SLOTS=12
NOW=$(date +%s)

# Collect entries as "state|key|session" — waiting first (so they take the low slots).
entries=()
collect() {  # <dir> <type> <max_age>
  local dir="$1" want="$2" max="$3" f type ts sess k v
  [ -d "$dir" ] || return
  for f in "$dir"/*; do
    [ -f "$f" ] || continue
    type=""; ts=""; sess=""
    while IFS='=' read -r k v; do
      case "$k" in TYPE) type=$v ;; TIMESTAMP) ts=$v ;; SESSION) sess=$v ;; esac
    done < "$f"
    [ "$type" = "$want" ] || continue
    [ $((NOW - ${ts:-0})) -lt "$max" ] || continue
    entries+=( "$want|${f##*/}|$sess" )
  done
}
collect "$NOTIF_DIR"  waiting 86400
collect "$ACTIVE_DIR" working 3600
count=${#entries[@]}

# slot -> session map for the hover handler
: > "$MAP"
idx=0
for e in "${entries[@]}"; do echo "$idx|$e" >> "$MAP"; idx=$((idx + 1)); done

# breathing phase (flips each tick → the dots ease between full and dim alpha)
phase=$(cat "$PHASE_FILE" 2>/dev/null); if [ "$phase" = "1" ]; then phase=0; else phase=1; fi
echo "$phase" > "$PHASE_FILE"

# Anchor robot: STEADY identity — foam, or gold if anything is waiting; hidden when none.
any_waiting=0
for e in "${entries[@]}"; do [ "${e%%|*}" = "waiting" ] && { any_waiting=1; break; }; done
if [ "$count" -gt 0 ]; then
  rcol=$FOAM; [ "$any_waiting" = "1" ] && rcol=$GOLD
  sketchybar --set claude drawing=on icon.color="$rcol"
else
  sketchybar --set claude drawing=off
fi

# Dots: one per active session, gently blinking between full and ~50% alpha each
# tick (full on phase 0, half on phase 1) so the row "breathes". Plain batched set —
# reliable here (an `--animate`'d color set does not apply to these items). Overflow
# on the last slot is steady.
WORK_HUE=9ccfd8   # foam
WAIT_HUE=f6c177   # gold
alpha=ff; [ "$phase" = "1" ] && alpha=80
args=()
i=0
while [ "$i" -lt "$SLOTS" ]; do
  if [ "$i" -lt "$count" ]; then
    if [ "$i" -eq $((SLOTS - 1)) ] && [ "$count" -gt "$SLOTS" ]; then
      args+=( --set claudesess.$i drawing=on icon="+$((count - SLOTS + 1))" icon.color=$SUBTLE )
    else
      hue=$WORK_HUE; [ "${entries[$i]%%|*}" = "waiting" ] && hue=$WAIT_HUE
      args+=( --set claudesess.$i drawing=on icon="●" icon.color="0x${alpha}${hue}" )
    fi
  else
    args+=( --set claudesess.$i drawing=off )
  fi
  i=$((i + 1))
done
sketchybar "${args[@]}"
