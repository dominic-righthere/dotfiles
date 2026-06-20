#!/bin/bash
# Rose Pine Moon palette — single source of truth for the bar's colors.
# Matches the tmux theme and the JankyBorders iris ring.
# Format: 0xAARRGGBB.  Palette: https://rosepinetheme.com/palette/

# Base tones
export BASE=0xff232136
export SURFACE=0xff2a273f
export OVERLAY=0xff393552
export MUTED=0xff6e6a86
export SUBTLE=0xff908caa
export TEXT=0xffe0def4

# Accents
export LOVE=0xffeb6f92
export GOLD=0xfff6c177
export ROSE=0xffea9a97
export PINE=0xff3e8fb0
export FOAM=0xff9ccfd8
export IRIS=0xffc4a7e7

# Highlights
export HL_LOW=0xff2a283e
export HL_MED=0xff44415a
export HL_HIGH=0xff56526e

# Semantic helpers
export ACCENT=$IRIS
export TRANSPARENT=0x00000000

# Bar shell — deliberately black & borderless so the MacBook notch dissolves
# into it (black-on-black). Tunable: 0xff000000 = fully flat, 0x40000000 = frosted.
export BAR_COLOR=0xf0000000
export BAR_BORDER=$TRANSPARENT  # no border = nothing outlines the notch

# Component "islands" — the design lives here, not on the bar shell.
export ISLAND_BG=$SURFACE
export ISLAND_BORDER=$OVERLAY

# Workspace pills (hybrid: the "before" rose look, kept inside the island)
export WS_ACTIVE_BG=0xffebbcba   # rose fill on the focused workspace
export WS_ACTIVE_FG=$BASE        # dark text on the rose pill
export WS_INACTIVE_FG=$TEXT      # bright text when not focused
export WS_EMPTY_FG=$MUTED        # dimmed id for empty workspaces
export DOT_COLOR=$FOAM           # the per-window dots
