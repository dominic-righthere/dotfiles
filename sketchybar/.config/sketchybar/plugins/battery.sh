#!/usr/bin/env bash
# Battery level + charge state, tinted by remaining charge.
source "$CONFIG_DIR/colors.sh"

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

[ -z "$PERCENTAGE" ] && exit 0

case "${PERCENTAGE}" in
  9[0-9]|100) ICON=""; COLOR=$FOAM ;;
  [6-8][0-9]) ICON=""; COLOR=$FOAM ;;
  [3-5][0-9]) ICON=""; COLOR=$GOLD ;;
  [1-2][0-9]) ICON=""; COLOR=$GOLD ;;
  *)          ICON=""; COLOR=$LOVE ;;
esac

if [ -n "$CHARGING" ]; then
  ICON=""
  COLOR=$PINE
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="${PERCENTAGE}%"
