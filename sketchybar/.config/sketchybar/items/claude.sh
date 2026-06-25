#!/bin/bash
# Module: claude — per-session Claude Code indicators in the monitoring island.
# A leading 󰚩 robot (identity, gently pulses) followed by one ● dot per ACTIVE
# session (foam = running, gold = waiting; idle excluded) so the dot count = how
# many are active at a glance. Hover a dot for that session's name + message.
# Driven by the tmux-agent-notifier state dirs. Capped at CLAUDE_SLOTS (+N overflow).
CLAUDE_SLOTS=12

# Dot pool. Added high->low so the on-screen order is robot ●0 ●1 … (each right-add
# goes to the left of the previous, so the last-added robot sits left of dot 0).
i=$((CLAUDE_SLOTS - 1))
while [ "$i" -ge 0 ]; do
  sketchybar --add item claudesess.$i right \
             --set claudesess.$i \
                   icon="●" icon.font="Hack Nerd Font:Bold:11.0" icon.color=$FOAM \
                   icon.padding_left=2 icon.padding_right=2 \
                   label.drawing=off drawing=off \
                   popup.align=center popup.y_offset=6 \
                   script="$PLUGIN_DIR/claude_session.sh" \
             --subscribe claudesess.$i mouse.entered mouse.exited
  MONITORING_ITEMS+=( claudesess.$i )
  i=$((i - 1))
done

# Leading robot anchor + poll driver (manages the dots above).
sketchybar --add item claude right \
           --set claude \
                 update_freq=2 \
                 icon="󰚩" icon.color=$FOAM icon.padding_right=2 \
                 label.drawing=off drawing=off \
                 script="$PLUGIN_DIR/claude.sh"
MONITORING_ITEMS+=( claude )
