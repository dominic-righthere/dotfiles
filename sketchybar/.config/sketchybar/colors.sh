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
export BAR_COLOR=0xcc232136     # translucent base so the blur shows through
export BAR_BORDER=0x40c4a7e7    # faint iris edge, echoes the window border
export TRANSPARENT=0x00000000
