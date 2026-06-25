#!/bin/bash
# Module registry + runtime on/off state — the "extensions" control layer.
#
# How modules load: sketchybarrc loops MODULES in order; for each ENABLED module
# it sources items/<module>.sh (which adds that module's item[s]). Disabled
# modules are never added → genuinely zero runtime cost, not just hidden.
#
# State (which modules are on) is persisted OUTSIDE the repo, because the config
# dir is a stow symlink into dotfiles and we don't want runtime toggles to dirty
# git. It survives reloads and reboots.

STATE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/sketchybar"
STATE_FILE="$STATE_DIR/modules.state"
mkdir -p "$STATE_DIR"

# Module order on the bar. left-anchored ones are placed by their items file;
# everything else lands in the right-hand system cluster.
MODULES=(layout workspaces input_source cpu claude audio battery clock lyrics control_center)

# Always on (cannot be toggled off; also kept in zen mode so you can recover).
ESSENTIALS=(workspaces clock control_center)

# Off until you enable them in the gear menu.
DEFAULT_OFF=(lyrics)

# --- state helpers -----------------------------------------------------------

# _state_get <key> -> prints on|off|"" (empty if unset)
_state_get() {
  [ -f "$STATE_FILE" ] || return 0
  local v
  v=$(grep -m1 "^$1=" "$STATE_FILE" 2>/dev/null | cut -d= -f2)
  printf '%s' "$v"
}

# _state_set <key> <on|off>
_state_set() {
  local key="$1" val="$2" tmp
  tmp="$STATE_FILE.tmp"
  touch "$STATE_FILE"
  { grep -v "^$key=" "$STATE_FILE" 2>/dev/null; echo "$key=$val"; } > "$tmp"
  mv "$tmp" "$STATE_FILE"
}

_in_list() { local n="$1"; shift; for x in "$@"; do [ "$x" = "$n" ] && return 0; done; return 1; }

# module_enabled <name> -> exit 0 if it should be added this load
module_enabled() {
  local m="$1"
  # zen hides everything that isn't essential
  if zen_enabled && ! _in_list "$m" "${ESSENTIALS[@]}"; then
    return 1
  fi
  _in_list "$m" "${ESSENTIALS[@]}" && return 0
  local s; s=$(_state_get "$m")
  if [ -n "$s" ]; then
    [ "$s" = "on" ]
  else
    # no explicit state yet -> on unless listed in DEFAULT_OFF
    ! _in_list "$m" "${DEFAULT_OFF[@]}"
  fi
}

set_module() { _state_set "$1" "$2"; }   # set_module <name> on|off

zen_enabled() { [ "$(_state_get zen)" = "on" ]; }
set_zen()     { _state_set zen "$1"; }    # set_zen on|off
