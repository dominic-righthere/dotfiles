# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.
It is the **deep maintainer/AI reference**; [`README.md`](README.md) is the user-facing overview — keep both in sync when behaviour changes.

## Repository Overview

This is a dotfiles repository designed for setting up consistent development environments across multiple platforms: Ubuntu/Debian Linux, macOS, and iSH (Alpine Linux on iOS). The repository contains configuration files and automated setup scripts for a complete terminal-based development environment with vim, tmux, zsh, and modern development tools.

## Setup and Installation

### Primary Setup Command
```bash
bash init.sh
```

This is the main entry point that:
1. Runs stow operations to symlink configuration files
2. Detects OS (iSH Alpine, Ubuntu/Debian, or macOS) and runs appropriate setup
3. Installs packages based on detected OS
4. Sets up vim-plug (on Ubuntu/macOS)
5. Sets up tmux and zsh (zsh setup runs last)

### Platform-Specific Package Installation

**For Ubuntu/Debian:**
```bash
source ./packages/apt.sh
```
Installs: zsh, bash, git, stow, tmux, vim, curl, wget, build-essential, python3, python3-pip, nvm, pyenv (with dependencies)

Note: Neovim is NOT installed via apt due to outdated versions. Install manually via:
- AppImage (recommended): Download from https://github.com/neovim/neovim/releases
- Snap: `sudo snap install nvim --classic`
- Build from source: https://github.com/neovim/neovim/wiki/Building-Neovim

Neovim configuration: Automatically clones and sets up kickstart.nvim from https://github.com/dominic-righthere/kickstart.nvim.git

**For iSH/Alpine Linux:**
```bash
source ./packages/apk.sh
```
Installs: zsh, bash, openssh, git, stow, tmux, vim, neovim, shadow

**For macOS:**
```bash
./packages/homebrew.sh        # installs Homebrew if missing, then `brew bundle` the Brewfile
# or directly:  brew bundle --file packages/Brewfile
```
Packages are declared in **`packages/Brewfile`** (curated, not a full dump). It installs `stow`,
`pyenv`, `nvm`, `neovim`, `tmux`, `jq`, dev CLI (gh/fd/uv/go/…), and the macOS WM/bar stack
(`borders`, `sketchybar`, cask `aerospace`, `font-hack-nerd-font`). Taps: `felixkratz/formulae`
(borders/sketchybar), `nikitabobko/tap` (aerospace).
- `init.sh` runs this on macOS **before** stowing (so `stow` exists). `setup/stow.sh` guards on it.
- Re-sync the Brewfile from the live machine, then hand-trim: `brew bundle dump --force --describe --file packages/Brewfile`.
- sketchybar needs Hack Nerd Font for its glyphs. AeroSpace needs Accessibility permission (manual, macOS-gated).

## Configuration Management

### Stow Usage
The repository uses GNU Stow with **per-tool packages**. Each top-level directory is a stow package mirroring its target path under `~`.

```bash
# From repo root, restow all packages idempotently:
stow -t ~ -R zsh tmux vim aerospace borders sketchybar

# Stow a single package:
stow -t ~ aerospace

# Unstow:
stow -D -t ~ aerospace
```

Or run the helper which also cleans up conflicting plain files:
```bash
bash setup/stow.sh
```

Managed packages:
- `zsh/.zshrc` - Zsh configuration with oh-my-zsh
- `tmux/.tmux.conf` - Tmux configuration with rose-pine theme
- `vim/.vimrc` - Vim configuration with vim-plug and CoC
- `aerospace/.config/aerospace/aerospace.toml` - AeroSpace tiling WM (macOS)
- `borders/.config/borders/bordersrc` - JankyBorders active-window highlight (macOS). Launched by AeroSpace's `after-startup-command`; Rose Pine iris border, no shortcuts (focus-watching daemon)
- `sketchybar/.config/sketchybar/` - SketchyBar status bar (macOS). Rose Pine Moon theme; flush black bar + island components. **Modular** — each feature is a toggleable module. Launched by AeroSpace; requires Hack Nerd Font + `jq`. See "SketchyBar module system" below.
  - Bar layout: `[layout][workspaces] … [lyrics] · monitoring[cpu 󰚩 ● ● ●] · system[input audio battery clock] · [⚙ control center]`. Two right-hand islands: **monitoring** (`MONITORING_ITEMS` in `sketchybarrc`: cpu + the per-session Claude dots) and **system** (`SYSTEM_ITEMS`).

### AeroSpace Layout Management

AeroSpace is a tree-based tiler — there are **no grid presets** (`2x2`, `3x3`, `1|2,3` are built, not selected). Two aids make this easy/discoverable:

**Layout mode** (`aerospace.toml` → `[mode.layout.binding]`): press `⌥⇧T` to enter; the bar shows a `LAYOUT` indicator. Single keys (actions stay in the mode; `esc`/`enter`/`q` exit):

| Key | Action |
|-----|--------|
| `h` `j` `k` `l` | focus target window |
| `⇧`+`hjkl` | `join-with` (build a nested split — makes `1\|2,3` / grids) |
| `t` | toggle horizontal ↔ vertical |
| `a` / `f` | accordion / float |
| `b` | `balance-sizes` (even out → clean grid) |
| `r` | `flatten-workspace-tree` (reset to one row) |
| `-` / `=` | resize |
| `?` | toggle the cheatsheet popup (only in layout mode) |

**Cheatsheet popup** (SketchyBar): click the layout pill (`layout` item, `󰕴` glyph, far **left** of the bar) — or press `?` while in layout mode — → popup of the shortcuts + recipes. The same pill is the layout-mode indicator: `aerospace.toml` fires `sketchybar --trigger aerospace_mode MODE=layout|main` on enter/exit, and `plugins/layout.sh` restyles it (→ `● LAYOUT`).

Recipe examples: `1|2,3` = focus the right window, `⌥⇧T` then `⇧K` (join up). `2×2` = join two pairs, then `b`. `two rows` = `⌥/` until the container is vertical.

**Notch / bar geometry** (design system: invisible black shell + Rose Pine islands):
- *Bar shell* is flush **solid black**, borderless, `notch_width=0` (`sketchybarrc` → `--bar height=44 y_offset=0 border_width=0 color=$BAR_COLOR`). Black-on-black makes the notch dissolve into the bar — no outline frames it. The visual design lives on the component "islands" (the `workspaces` + `system` brackets), not the shell. Tune blackness via `BAR_COLOR` in `colors.sh` (`0xff000000` flat ↔ `0x40000000` frosted).
- *Window* top border clearing the notch — and **the bar not being covered by windows** — is a **separate** concern, controlled by AeroSpace's `[gaps] outer.top` (the bar has `topmost=off` and reserves no space, so the WM must leave the gap). Set to `[ { monitor."built-in" = 12 }, 44 ]`: the notched built-in needs only `12` (its menu bar already reserves most of the 44px bar), every **external** display needs `44` to clear the full bar — without it, windows cover the bar on a second screen. If the notch still clips a window's top border on the built-in, raise `12` toward `~37`; if there's too much gap on an external, lower `44` toward `40`.

### SketchyBar module system

Each bar feature is a **module** you can toggle on/off (like extensions). Structure:
- `sketchybarrc` — orchestrator: bar shell, events, then loads only the **enabled** modules.
- `settings.sh` — module registry (`MODULES`, `ESSENTIALS`, `DEFAULT_OFF`) + state helpers.
  On/off state persists in `~/.cache/sketchybar/modules.state` — **outside the repo** (the config
  dir is a stow symlink), so toggles never dirty git and survive reload/reboot.
- `colors.sh` — Rose Pine Moon palette + tokens; sourced by rc and every plugin. Edit colors here.
- `items/<module>.sh` — one self-contained file per module; sourced **only when enabled** →
  a disabled module is never added (zero runtime cost, not just hidden).
- `plugins/<x>.sh` — update/click scripts run by SketchyBar at runtime.

**Control center** (`⚙`, far-right): click → popup with a checkbox per non-essential module +
a zen row. Toggling runs `plugins/control_center.sh` which flips state then `sketchybar --reload`
(rc re-adds/skips per the new state). **Zen mode** (`⌥⇧Z` or the popup row) hides all but the
essentials (`workspaces`, `clock`, `control_center`).

**Modules & performance** (how they're loaded):

| Module | Trigger | Cost | Default |
|--------|---------|------|---------|
| workspaces | event `aerospace_workspace_change` + one `space_driver` poll 3s | 2 aerospace queries/refresh | on (essential) |
| layout | events only (click/hover/mode) | ~0 idle | on |
| input_source | poll 1s | `defaults read`, <10ms | on |
| cpu | poll 2s | `ps` sample, cheap | on |
| claude | `claude` anchor polls 2s (drives the dot slots) | greps `~/.local/share/agent-notifier/{active,notifications}` (cheap); 12 dot-set calls batched | on |
| audio | event `volume_change` + on-click | `system_profiler` only on popup-open (~300ms), volume via `osascript` | on |
| battery | poll 120s + `power_source_change` | `pmset`, cheap | on |
| clock | poll 10s | `date` | on (essential) |
| lyrics | poll 2s while playing | `osascript`/`curl` | **off** |
| control_center | events only | ~0 idle | on (essential) |

**Claude indicator** (`claude` module, in the `monitoring` island) — **per-session**: a leading `󰚩`
robot anchor (steady identity — foam, or amber if anything's waiting) followed by **one `●` dot per
ACTIVE session** (foam = working, gold = waiting; idle excluded) that gently **breathes** (blinks
between full and ~50% alpha each tick) — so the dot count = how many are active at a glance.
**Hover a dot** → popup with that session's name · tmux window · message. (Note: animating `icon.color`
via `--animate` doesn't apply to these items here — and a *batched* `--animate … --set a --set b`
silently no-ops — so the breathe is a plain phase-alternated set; per-item `--animate` for one `--set`
does work elsewhere, e.g. the workspace focus highlight.)
- Reads the **external** tmux-agent-notifier state (`~/.local/share/agent-notifier/{active,notifications}`,
  written by Claude Code hooks). No notifier → dirs absent → everything stays hidden (safe/portable).
- Architecture: `items/claude.sh` creates the anchor + a fixed pool of 12 `claudesess.N` dot slots
  (capped, with a `+N` overflow on the last slot). The anchor's `plugins/claude.sh` driver (poll 2s)
  orders sessions (waiting first), writes a slot→session map to `~/.cache/sketchybar/claude.slots`,
  pulses the anchor, and batches the dot updates. Each dot's `plugins/claude_session.sh` reads that map
  on hover to build its popup. Detail (counts/navigation) still lives on the tmux side.

**Multi-display**: when >1 monitor is connected, the workspace pills group by display — a subtle
`󰍹` glyph + a thin divider lead each monitor's group (e.g. `󰍹 1 2 3 q w e │ 󰍹 a s d`). Single
display → flat list, no markers. Grouping is recomputed at load; the `space_driver` **auto-reloads
on display change** (connect / disconnect / mirror) — it compares a monitor signature each 3s tick
(+ the `display_change` event) against `~/.cache/sketchybar/monitors.sig` and reloads only when it
changes (no manual `sketchybar --reload` needed, no reload loop).

Audio is **read-only** (shows device + AirPods L/R battery + volume; scroll=volume, click=popup,
right-click=mute) — no device switching (would need `brew install switchaudio-osx`). Input source
maps the current source → `EN`/`한`/`あ`; if it doesn't flip for the Korean/Japanese IMEs on your
Mac, `brew install macism` and swap the read line in `plugins/input_source.sh`.

**Menu-bar → SketchyBar coverage**: workspaces, layout, input source, audio (+ Bluetooth/AirPods),
cpu, battery, clock, control-center toggles, zen, lyrics (now-playing, off). Easy future modules
(not built): WiFi, a calendar popup on the clock, media transport controls, Focus/DnD, brightness,
a Spotlight/Raycast launcher — add as `items/<name>.sh` + a `plugins/<name>.sh` and register in
`settings.sh`.

### Manual Configuration Steps Required

**Vim Setup:**
- Vim-plug installation script exists in `setup/vim.sh` but may need to be run manually
- Currently vim-plug is NOT installed (no ~/.vim/autoload/plug.vim found)
- Run `source ./setup/vim.sh` to install vim-plug, then `:PlugInstall` in Vim
- CoC extensions (coc-tsserver) are configured but need vim-plug installation first

**Tmux Setup:**
- TPM (Tmux Plugin Manager) is auto-installed
- Hit `prefix + I` in tmux to install plugins
- On macOS, tmux-temp plugin requires additional setup:
  ```bash
  git clone https://github.com/narugit/smctemp
  cd smctemp
  sudo make install
  ```
- Windows/panes start at index 1 (`base-index`/`pane-base-index`). Sessions also start at 1:
  a `session-created` hook (`~/.tmux/session-from-1.sh`, stowed from `tmux/.tmux/`) renames a new
  `0` session to the next free number. `prefix + g` opens a 1-based session menu
  (`~/.tmux/session-menu.sh`, press `1` for the first session); `prefix + s` keeps the default tree.

**Zsh Setup:**
- oh-my-zsh is auto-installed
- Plugins (zsh-autosuggestions, zsh-syntax-highlighting) are auto-cloned
- **nvm and pyenv are lazy-loaded** for fast startup (~0.18s vs ~0.45s eager): nvm.sh is deferred
  until the first `nvm`/`node`/`npm`/`npx` call; pyenv does the fast `pyenv init --path` eagerly
  (so `python` works) and defers the full `pyenv init -` to the first `pyenv` call.

**iSH-Specific Setup:**
- SSH key generation for GitHub: `ssh-keygen -t ed25519 -C "github" -f ~/.ssh/ed25519_github`
- Manual step required: Copy public key to GitHub settings
- Note: SSH keys not currently set up in this environment

## Architecture

### Directory Structure
- `zsh/`, `tmux/`, `vim/`, `aerospace/`, `borders/`, `sketchybar/` - One stow package per tool. Each mirrors the target path under `~` (top-level dotfiles at the package root; XDG configs under `<pkg>/.config/<tool>/`).
- `setup/` - Setup scripts for individual tools
- `packages/` - Package installation scripts for different platforms
- `utils/` - Utility scripts (nerd-fonts.sh)
- `tailscale/` - Tailscale-specific configurations

### Setup Script Flow
1. `init.sh` - Main orchestrator
2. `setup/stow.sh` - Manages dotfile symlinking
3. Platform detection and package installation
4. `setup/vim.sh` - vim-plug installation
5. `setup/neovim.sh` - Clone kickstart.nvim config
6. `setup/tmux.sh` - TPM setup
7. `setup/zsh.sh` - oh-my-zsh and plugins setup

### Key Environment Variables
- `ZSH_CUSTOM` - oh-my-zsh custom directory
- `PYENV_ROOT` - Python environment management
- Various PATH additions for development tools

## Current Environment Status

**System Information:**
- Platform: macOS (Darwin)
- Shell: zsh (/bin/zsh)
- Package Manager: Homebrew

**Vim/Neovim:**
- Vim: Configuration in configs/.vimrc with vim-plug, CoC, and JavaScript/TypeScript support
- vim-plug: Installed via setup/vim.sh
- Leader key mapped to spacebar
- Neovim: Separate modern config using kickstart.nvim (Lua-based)
  - Repository: https://github.com/dominic-righthere/kickstart.nvim.git
  - Auto-cloned to ~/.config/nvim during setup
  - Includes LSP, Treesitter, Telescope, and modern Neovim plugins

**Zsh:**
- robbyrussell theme
- oh-my-zsh: Properly installed and configured
- Plugins: zsh-autosuggestions and zsh-syntax-highlighting installed
- Python (pyenv), Node (nvm), and Google Cloud SDK integration working
- .zshrc: Properly symlinked to dotfiles

**Tmux:**
- Tmux 3.5a installed via Homebrew (/opt/homebrew/bin/tmux)
- .tmux.conf: Properly symlinked to dotfiles
- Rose Pine Moon theme configured
- All plugins installed: tmux, tmux-battery, tmux-continuum, tmux-cpu, tmux-resurrect, tmux-sensible, tmux-temp, tpm
- Status bar with battery, CPU, temperature monitoring
- Session persistence with resurrect/continuum

**Development Tools:**
- Git: Available and configured
- Stow: /opt/homebrew/bin/stow (used for dotfile management)
- NVM: Installed via Homebrew, shell function working
- Pyenv: Shell function working
- SSH: No GitHub keys currently configured