#!/bin/sh
# Make auto-named tmux sessions start at 1 instead of 0.
# tmux has no native "session base-index", so on session-created we rename a
# session named "0" to the lowest free integer >= 1. Named sessions are untouched.
tmux has-session -t '=0' 2>/dev/null || exit 0
i=1
while tmux has-session -t "=$i" 2>/dev/null; do
  i=$((i + 1))
done
tmux rename-session -t '=0' "$i"
