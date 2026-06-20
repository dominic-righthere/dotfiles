#!/bin/bash
# Module: workspaces — hybrid rose pills + per-window dots, grouped in an island.
# A single hidden driver (space_driver) highlights focus, dims empties, and sets
# the dots — no per-pill polling.
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
                   label.font="$FONT:Bold:12.0" \
                   label.color=$WS_INACTIVE_FG \
                   icon.drawing=off \
                   background.color=$WS_ACTIVE_BG \
                   background.drawing=off \
                   background.height=22 \
                   background.corner_radius=6 \
                   click_script="aerospace workspace $sid"
  sketchybar --add item space.$sid.dots left \
             --set space.$sid.dots \
                   icon.drawing=off label="" \
                   label.font="$FONT:Bold:9.0" label.color=$DOT_COLOR \
                   label.padding_left=0 label.padding_right=6
  ws_items+=( space.$sid space.$sid.dots )
done

# Hidden driver: refresh on focus change + a light 3s poll (counts can change
# without a focus change). Not part of the island bracket (zero width).
sketchybar --add item space_driver left \
           --set space_driver drawing=off update_freq=3 \
                 script="$PLUGIN_DIR/workspaces.sh" \
           --subscribe space_driver aerospace_workspace_change

if [ ${#ws_items[@]} -gt 0 ]; then
  sketchybar --add bracket workspaces "${ws_items[@]}" \
             --set workspaces \
                   background.color=$ISLAND_BG \
                   background.corner_radius=10 \
                   background.border_width=2 \
                   background.border_color=$ISLAND_BORDER
fi
