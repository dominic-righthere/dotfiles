#!/usr/bin/env bash
# Battery level + charge state, tinted by remaining charge. Material Design
# battery glyphs (same family as the rest of the bar) so charging renders.
source "$CONFIG_DIR/colors.sh"

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

[ -z "$PERCENTAGE" ] && exit 0

case "${PERCENTAGE}" in
  9[0-9]|100) ICON="󰁹"; COLOR=$FOAM ;;   # full
  [6-8][0-9]) ICON="󰂀"; COLOR=$FOAM ;;   # ~70
  [3-5][0-9]) ICON="󰁾"; COLOR=$GOLD ;;   # ~50
  [1-2][0-9]) ICON="󰁻"; COLOR=$GOLD ;;   # ~20
  *)          ICON="󰂃"; COLOR=$LOVE ;;   # alert (<10)
esac

if [ -n "$CHARGING" ]; then
  ICON="󰂄"          # charging bolt
  COLOR=$PINE
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="${PERCENTAGE}%"
