#!/usr/bin/env bash
# Volume level + icon. The volume_change event supplies the percentage in $INFO.
source "$CONFIG_DIR/colors.sh"

if [ "$SENDER" = "volume_change" ]; then
  VOLUME="$INFO"

  case "$VOLUME" in
    [6-9][0-9]|100)   ICON="󰕾" ;;
    [3-5][0-9])       ICON="󰖀" ;;
    [1-9]|[1-2][0-9]) ICON="󰕿" ;;
    *)                ICON="󰖁" ;;
  esac

  if [ "$VOLUME" -eq 0 ] 2>/dev/null; then
    COLOR=$MUTED
  else
    COLOR=$FOAM
  fi

  sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="$VOLUME%"
fi
