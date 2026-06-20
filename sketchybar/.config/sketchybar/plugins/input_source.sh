#!/usr/bin/env bash
# Current keyboard input source -> EN / 한 / あ.
# Note: reads AppleCurrentKeyboardLayoutInputSourceID. If this doesn't flip for
# the Korean/Japanese IMEs on your Mac, `brew install macism` and swap the read
# line for `macism` (returns the active source id incl. IMEs).
src="$(defaults read com.apple.HIToolbox AppleCurrentKeyboardLayoutInputSourceID 2>/dev/null)"

case "$src" in
  *Korean*)               label="한" ;;
  *Japanese*|*Kotoeri*)   label="あ" ;;
  *ABC*|*US*|*keylayout*) label="EN" ;;
  "")                     label="?"  ;;
  *)                      label="${src##*.}" ;;
esac

sketchybar --set "$NAME" label="$label"
