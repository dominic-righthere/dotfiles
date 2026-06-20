#!/usr/bin/env bash
# CPU load as a percentage number, coloured by load. Cheap ps-based sampling.
source "$CONFIG_DIR/colors.sh"

CORES=$(sysctl -n hw.logicalcpu)
SUM=$(ps -A -o %cpu | awk '{s+=$1} END {print s}')
CPU=$(awk -v s="$SUM" -v c="$CORES" 'BEGIN { v = s / c; if (v > 100) v = 100; printf "%.0f", v }')

COLOR=$PINE
[ "$CPU" -ge 60 ] && COLOR=$GOLD
[ "$CPU" -ge 85 ] && COLOR=$LOVE

sketchybar --set "$NAME" label="${CPU}%" icon.color="$COLOR" label.color="$COLOR"
