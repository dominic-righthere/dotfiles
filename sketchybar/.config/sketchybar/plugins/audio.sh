#!/usr/bin/env bash
# Audio (read-only): inline volume + a popup with output device & Bluetooth
# battery. scroll = volume, left-click = popup, right-click = mute.
source "$CONFIG_DIR/colors.sh"

read_vol()  { osascript -e 'output volume of (get volume settings)' 2>/dev/null; }
read_mute() { osascript -e 'output muted of (get volume settings)' 2>/dev/null; }

vol_icon() { # $1=volume $2=muted
  if [ "$2" = "true" ] || [ "${1:-0}" -eq 0 ]; then echo "󰖁"; return; fi
  if   [ "$1" -ge 60 ]; then echo "󰕾"
  elif [ "$1" -ge 30 ]; then echo "󰖀"
  else                       echo "󰕿"; fi
}

refresh_inline() { # $1=optional volume
  local v m icol
  v="${1:-$(read_vol)}"; m=$(read_mute)
  icol=$FOAM; [ "$m" = "true" ] && icol=$MUTED
  sketchybar --set audio icon="$(vol_icon "$v" "$m")" icon.color="$icol" label="${v}%"
}

refresh_popup() {
  local v m name batt icon label
  v=$(read_vol); m=$(read_mute)
  # current default output device name (slow call — only runs on click)
  name=$(system_profiler SPAudioDataType 2>/dev/null \
         | awk '/^        [^ ].*:$/{d=$0} /Default Output Device: Yes/{print d; exit}' \
         | sed 's/^ *//; s/ *:$//; s/^"//; s/"$//')
  [ -z "$name" ] && name="Output"
  icon="󰓃"; label="$name"
  case "$name" in
    *[Pp]ods*|*AirPod*)
      icon="󰋋"
      # AirPods L/R battery (only on popup open, only for AirPods)
      bt=$(system_profiler SPBluetoothDataType 2>/dev/null)
      l=$(printf '%s\n' "$bt" | awk -F': ' '/Left Battery Level/  {gsub(/[^0-9]/,"",$2); print $2; exit}')
      r=$(printf '%s\n' "$bt" | awk -F': ' '/Right Battery Level/ {gsub(/[^0-9]/,"",$2); print $2; exit}')
      if   [ -n "$l" ] && [ -n "$r" ]; then label="$name · L$l R$r%"
      elif [ -n "$l" ];                 then label="$name · ${l}%"; fi
      ;;
  esac
  sketchybar --set audio.device icon="$icon" label="$label"
  sketchybar --set audio.level label="volume ${v}%$([ "$m" = "true" ] && echo " · muted")"
}

case "$SENDER" in
  mouse.scrolled)
    cur=$(read_vol); [ -z "$cur" ] && exit 0
    if [ "$(printf '%.0f' "${SCROLL_DELTA:-0}" 2>/dev/null)" -gt 0 ] 2>/dev/null; then
      new=$((cur + 5))
    else
      new=$((cur - 5))
    fi
    [ "$new" -lt 0 ] && new=0; [ "$new" -gt 100 ] && new=100
    osascript -e "set volume output volume $new"
    refresh_inline "$new"
    ;;
  mouse.clicked)
    if [ "$BUTTON" = "right" ]; then
      osascript -e 'set volume output muted not (output muted of (get volume settings))'
      refresh_inline
    else
      refresh_popup
      sketchybar --set audio popup.drawing=toggle
    fi
    ;;
  mouse.exited.global)
    sketchybar --set audio popup.drawing=off
    ;;
  *)  # volume_change or first run
    refresh_inline "${INFO}"
    ;;
esac
