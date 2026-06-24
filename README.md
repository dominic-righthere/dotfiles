# dotfiles

A cross-platform terminal + desktop development environment, managed with [GNU Stow](https://www.gnu.org/software/stow/).
One `init.sh` sets up a consistent setup across **macOS**, **Ubuntu/Debian**, and **iSH** (Alpine on iOS):
zsh, tmux, vim/neovim, and — on macOS — a tiling window-manager stack (AeroSpace + JankyBorders + SketchyBar).

## Highlights

- **Fast zsh** — oh-my-zsh with `nvm` and `pyenv` lazy-loaded (shell starts in ~0.18s instead of ~0.45s).
- **tmux** — Rose Pine Moon theme, `C-a` prefix, windows **and sessions** numbered from 1, session persistence (resurrect/continuum).
- **AeroSpace** (macOS) — tree-based tiling WM with a discoverable **layout mode** and an in-bar cheatsheet.
- **JankyBorders** (macOS) — Rose Pine active-window highlight.
- **SketchyBar** (macOS) — a modular, notch-friendly status bar with toggleable "extension" modules, a control-center popup, zen mode, and multi-display awareness.

## What's inside

Each top-level directory is a Stow package that mirrors its target path under `~`:

| Package | Target | What |
|---|---|---|
| `zsh/` | `~/.zshrc` | oh-my-zsh, lazy nvm/pyenv, `~/.zshrc.local` for machine-local config |
| `tmux/` | `~/.tmux.conf` | Rose Pine Moon, TPM plugins, session helpers |
| `vim/` | `~/.vimrc` | vim-plug + CoC (JS/TS) |
| `aerospace/` | `~/.config/aerospace/` | AeroSpace tiling WM (macOS) |
| `borders/` | `~/.config/borders/` | JankyBorders active-window ring (macOS) |
| `sketchybar/` | `~/.config/sketchybar/` | Modular status bar (macOS) |

Plus `setup/` (per-tool setup scripts), `packages/` (per-OS package installers), and `utils/`.

## Install

```bash
git clone https://github.com/dominic-righthere/dotfiles.git
cd dotfiles
bash init.sh
```

`init.sh` symlinks the Stow packages, detects the OS, and runs the appropriate setup. On **macOS**,
Homebrew packages are installed as a manual step (Homebrew prompts interactively):

```bash
./packages/homebrew.sh
```

Then, inside tmux, press `prefix + I` to install the tmux plugins.

## macOS desktop stack

> Requires [Hack Nerd Font](https://www.nerdfonts.com/) + `jq` for SketchyBar, and the
> `FelixKratz/formulae` tap for `borders` and `sketchybar` (the homebrew script adds it).

### AeroSpace — layouts

AeroSpace is a **tree-based tiler**, so there are no fixed grid presets — you build arrangements.
Two aids make it easy:

- **Layout mode** — press `⌥⇧T` to enter (the bar shows a `LAYOUT` indicator), then single keys:

  | Key | Action |
  |---|---|
  | `h j k l` | focus window |
  | `⇧ + hjkl` | join (build a split — makes `1\|2,3` / grids) |
  | `t` | toggle horizontal ↔ vertical |
  | `b` | balance sizes (even grid) |
  | `r` | reset (flatten) |
  | `esc` | exit |

- **Cheatsheet** — click the `󰕴` glyph at the far left of the bar (or press `?` in layout mode) for the full reference.

Workspaces: `⌥` + `1/2/3`, `q/w/e`, `a/s/d`. Focus `⌥hjkl`, move window `⌥⇧hjkl`.

### SketchyBar — modular status bar

A flush-black, notch-friendly bar (Rose Pine Moon) where each feature is a **toggleable module**:
workspaces, layout, input source (EN/한/あ), CPU, audio (volume + AirPods battery), battery, clock, lyrics.

- **Control center** — click the `⚙` (far right) to toggle modules on/off (persisted).
- **Zen mode** — `⌥⇧Z` (or the control-center row) hides everything but the essentials.
- **Multi-display** — workspace pills group by monitor when more than one display is connected.

### tmux

- Prefix is `C-a`. Vim-style pane navigation (`prefix + h/j/k/l`).
- Windows and sessions both start at **1**; `prefix + g` opens a 1-based session menu (`prefix + s` keeps the default tree).

## Customization

Machine-local or private config (secrets, service URLs, per-host `PATH`s) goes in **`~/.zshrc.local`**,
which `.zshrc` sources if present. It is gitignored — keep it out of the repo.

## Per-platform notes

- **Ubuntu/Debian** — `source ./packages/apt.sh` (zsh, git, stow, tmux, vim, build tools, nvm, pyenv).
  Install Neovim manually (the apt version is outdated); kickstart.nvim is cloned by `setup/neovim.sh`.
- **iSH (Alpine/iOS)** — `source ./packages/apk.sh`. Generate a GitHub SSH key with `setup/github-ssh.sh`.
- **macOS** — `./packages/homebrew.sh`. On a notched MacBook, tune the window/bar gap via AeroSpace's
  `[gaps] outer.top` if needed.

## Credits

Themes and tools by their respective authors:
[Rose Pine](https://rosepinetheme.com/), [AeroSpace](https://github.com/nikitabobko/AeroSpace),
[JankyBorders](https://github.com/FelixKratz/JankyBorders), [SketchyBar](https://github.com/FelixKratz/SketchyBar),
[oh-my-zsh](https://ohmyz.sh/), [TPM](https://github.com/tmux-plugins/tpm), [vim-plug](https://github.com/junegunn/vim-plug).
