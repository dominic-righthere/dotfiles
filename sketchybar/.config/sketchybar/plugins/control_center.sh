#!/usr/bin/env bash
# Control center: toggle modules on/off (persisted) + zen mode. A toggle reloads
# the bar so rc re-adds/skips per the new state (disabled = not loaded at all).
source "$CONFIG_DIR/settings.sh"

toggle_module() {
  local m="$1" cur
  cur=$(_state_get "$m")
  if [ -z "$cur" ]; then
    _in_list "$m" "${DEFAULT_OFF[@]}" && cur=off || cur=on
  fi
  [ "$cur" = "on" ] && set_module "$m" off || set_module "$m" on
  sketchybar --reload
}

toggle_zen() {
  if zen_enabled; then set_zen off; else set_zen on; fi
  sketchybar --reload
}

# CLI form (from popup row click_script): control_center.sh toggle <m> | zen
case "$1" in
  toggle) toggle_module "$2"; exit 0 ;;
  zen)    toggle_zen;          exit 0 ;;
esac

# Event form (the gear item itself)
case "$SENDER" in
  mouse.clicked)       sketchybar --set "$NAME" popup.drawing=toggle ;;
  mouse.exited.global) sketchybar --set "$NAME" popup.drawing=off ;;
  zen_toggle)          toggle_zen ;;
esac
