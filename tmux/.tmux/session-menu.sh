#!/bin/sh
# 1-based session switcher: a numbered menu where pressing 1 jumps to the first
# session, 2 the second, ... (tmux's choose-tree quick-keys are 0-based and not
# configurable). Bound to `prefix + g`.
i=1
set --
for s in $(tmux list-sessions -F '#{session_name}' | sort -V); do
  [ "$i" -gt 9 ] && break
  set -- "$@" "$i: $s" "$i" "switch-client -t \"$s\""
  i=$((i + 1))
done
[ "$#" -eq 0 ] && exit 0
tmux display-menu -T " sessions " -x C -y C "$@"
