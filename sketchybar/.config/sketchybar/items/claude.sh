#!/bin/bash
# Module: claude — Claude Code session indicator. Driven by the tmux-agent-notifier
# state files (~/.local/share/agent-notifier/{active,notifications}). Shows a robot
# that gently pulses foam while a session is RUNNING and amber while one is WAITING
# for an answer; hidden when idle/none. Lives in the monitoring island (with cpu).
sketchybar --add item claude right \
           --set claude \
                 update_freq=1 \
                 icon="󰚩" \
                 icon.color=$FOAM \
                 label.drawing=off \
                 drawing=off \
                 script="$PLUGIN_DIR/claude.sh"
MONITORING_ITEMS+=( claude )
