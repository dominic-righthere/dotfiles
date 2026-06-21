#!/bin/bash
# Module: workspaces — hybrid rose pills in an island. The focused pill gets the
# rose fill, workspaces with windows are bright, empty ones are dimmed (a single
# hidden space_driver handles that — no per-pill polling). If the layout module
# is on, its glyph is merged into this same island (one window-management unit).
all_workspaces=$(aerospace list-workspaces --all)
qwerty_order=( 1 2 3 4 5 6 7 8 9 0 q w e r t y u i o p a s d f g h j k l z x c v b n m )

sorted=()
for key in "${qwerty_order[@]}"; do
  echo "$all_workspaces" | grep -q "^$key$" && sorted+=("$key")
done
for sid in $all_workspaces; do
  printf '%s\n' "${sorted[@]}" | grep -q "^$sid$" || sorted+=("$sid")
done

ws_items=()
for sid in "${sorted[@]}"; do
  sketchybar --add item space.$sid left \
             --set space.$sid \
                   label="$sid" \
                   label.color=$WS_INACTIVE_FG \
                   icon.drawing=off \
                   background.color=$WS_ACTIVE_BG \
                   background.drawing=off \
                   background.height=22 \
                   background.corner_radius=6 \
                   click_script="aerospace workspace $sid"
  ws_items+=( space.$sid )
done

# Hidden driver: highlight focus + dim empties, on focus change + a light 3s poll.
sketchybar --add item space_driver left \
           --set space_driver drawing=off update_freq=3 \
                 script="$PLUGIN_DIR/workspaces.sh" \
           --subscribe space_driver aerospace_workspace_change

# Island wraps the pills (+ the merged layout glyph, if that module is enabled).
bracket_items=()
module_enabled layout && bracket_items+=( aerospace_help )
bracket_items+=( "${ws_items[@]}" )

if [ ${#ws_items[@]} -gt 0 ]; then
  sketchybar --add bracket workspaces "${bracket_items[@]}" \
             --set workspaces \
                   background.color=$ISLAND_BG \
                   background.corner_radius=10 \
                   background.border_width=2 \
                   background.border_color=$ISLAND_BORDER
fi
