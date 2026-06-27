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

# Gather candidates from both state dirs as "ts|state|key|session". One session
# can appear in BOTH dirs at once — a waiting/finished notification is written
# without clearing the active "working" record (same filename key in each) — so
# we must dedupe by key, else one session renders as two dots (foam + gold).
cands=()
gather() {  # <dir> <type> <max_age>
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
    cands+=( "${ts:-0}|$want|${f##*/}|$sess" )
  done
}
gather "$NOTIF_DIR"  waiting 86400   # gathered first → wins timestamp ties
gather "$ACTIVE_DIR" working 3600

# Dedupe by key, keeping the NEWEST timestamp per session: a fresh waiting
# notification supersedes the stale working record (→ the dot turns gold in
# place); a session that resumed work supersedes a stale notification (→ foam).
ukeys=""
for c in "${cands[@]}"; do
  IFS='|' read -r ts state key sess <<< "$c"
  case " $ukeys " in *" $key "*) : ;; *) ukeys="$ukeys $key" ;; esac
done
entries=()
for key in $ukeys; do
  best_ts=-1; best_state=""; best_sess=""
  for c in "${cands[@]}"; do
    IFS='|' read -r ts state k sess <<< "$c"
    [ "$k" = "$key" ] || continue
    if [ "${ts:-0}" -gt "$best_ts" ]; then best_ts=$ts; best_state=$state; best_sess=$sess; fi
  done
  entries+=( "$best_state|$key|$best_sess" )
done

# Order waiting first so they take the low (leftmost) slots.
ordered=()
for e in "${entries[@]}"; do [ "${e%%|*}" = "waiting" ] && ordered+=( "$e" ); done
for e in "${entries[@]}"; do [ "${e%%|*}" = "working" ] && ordered+=( "$e" ); done
entries=( "${ordered[@]}" )
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
