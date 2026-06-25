#!/bin/bash
# Module: workspaces — hybrid rose pills, grouped by monitor when >1 display is
# connected (a subtle 󰍹 monitor glyph + a thin divider lead each display's
# group). The focused pill gets the rose fill; pills with windows are bright,
# empty ones dimmed (the hidden space_driver does that). The layout glyph is
# merged into this same island. Single display → flat list, no markers.
# NB: macOS /bin/bash is 3.2 — no associative arrays; query per-monitor instead.

qwerty_order=( 1 2 3 4 5 6 7 8 9 0 q w e r t y u i o p a s d f g h j k l z x c v b n m )

# Seed the monitor signature so the driver only reloads on an ACTUAL display
# change (connect / disconnect / mirror), not on every poll. Must match the
# command the driver uses in plugins/workspaces.sh.
printf '%s' "$(aerospace list-monitors --format '%{monitor-id}|%{monitor-name}' 2>/dev/null | sort)" \
  > "${XDG_CACHE_HOME:-$HOME/.cache}/sketchybar/monitors.sig"

mon_ids=$(aerospace list-monitors --format '%{monitor-id}' 2>/dev/null | sort -n)
mon_count=$(printf '%s\n' "$mon_ids" | grep -c .)

add_pill() {
  sketchybar --add item space.$1 left \
             --set space.$1 \
                   label="$1" \
                   label.color=$WS_INACTIVE_FG \
                   icon.drawing=off \
                   background.color=$WS_ACTIVE_BG \
                   background.drawing=off \
                   background.height=22 \
                   background.corner_radius=6 \
                   click_script="aerospace workspace $1"
}

ws_items=()
first_group=1

for mid in $mon_ids; do
  mon_ws=$(aerospace list-workspaces --monitor "$mid" 2>/dev/null)
  [ -z "$mon_ws" ] && continue

  # qwerty-sorted workspaces for this monitor, then any stragglers
  group=()
  for key in "${qwerty_order[@]}"; do
    printf '%s\n' "$mon_ws" | grep -qx "$key" && group+=("$key")
  done
  for ws in $mon_ws; do
    printf '%s\n' "${group[@]}" | grep -qx "$ws" || group+=("$ws")
  done
  [ ${#group[@]} -eq 0 ] && continue

  if [ "$mon_count" -gt 1 ]; then
    if [ "$first_group" -eq 0 ]; then
      sketchybar --add item wsdiv.$mid left \
                 --set wsdiv.$mid icon.drawing=off label.drawing=off width=2 \
                       background.drawing=on background.color=$OVERLAY \
                       background.height=16 background.corner_radius=1 \
                       padding_left=6 padding_right=6
      ws_items+=( wsdiv.$mid )
    fi
    sketchybar --add item wsmon.$mid left \
               --set wsmon.$mid icon="󰍹" icon.color=$SUBTLE label.drawing=off \
                     padding_left=4 padding_right=2 icon.padding_left=2 icon.padding_right=4
    ws_items+=( wsmon.$mid )
  fi

  for sid in "${group[@]}"; do
    add_pill "$sid"
    ws_items+=( space.$sid )
  done
  first_group=0
done

# Hidden driver: highlight focus + dim empties, on focus change + a light 3s poll.
sketchybar --add item space_driver left \
           --set space_driver drawing=off update_freq=3 \
                 script="$PLUGIN_DIR/workspaces.sh" \
           --subscribe space_driver aerospace_workspace_change display_change

# Island wraps the layout glyph (if enabled) + the grouped markers/pills.
bracket_items=()
module_enabled layout && bracket_items+=( layout )
bracket_items+=( "${ws_items[@]}" )

if [ ${#ws_items[@]} -gt 0 ]; then
  sketchybar --add bracket workspaces "${bracket_items[@]}" \
             --set workspaces \
                   background.color=$ISLAND_BG \
                   background.corner_radius=10 \
                   background.border_width=2 \
                   background.border_color=$ISLAND_BORDER
fi
