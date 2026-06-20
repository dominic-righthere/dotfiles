#!/usr/bin/env bash
# Live CPU load fed into the `cpu` graph. Cheap: sums ps %cpu across processes
# and divides by logical core count (no `top` spin-up each tick).
source "$CONFIG_DIR/colors.sh"

CORES=$(sysctl -n hw.logicalcpu)
SUM=$(ps -A -o %cpu | awk '{s+=$1} END {print s}')
CPU=$(awk -v s="$SUM" -v c="$CORES" 'BEGIN { v = s / c; if (v > 100) v = 100; printf "%.0f", v }')
VAL=$(awk -v p="$CPU" 'BEGIN { printf "%.2f", p / 100 }')

COLOR=$PINE
[ "$CPU" -ge 60 ] && COLOR=$GOLD
[ "$CPU" -ge 85 ] && COLOR=$LOVE

sketchybar --push cpu "$VAL" --set cpu graph.color="$COLOR" icon.color="$COLOR"
