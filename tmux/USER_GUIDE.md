# Beginner Manual: Understanding This tmux Configuration

This guide documents the exact `tmux/tmux.conf` in this repository.

It is written for beginners who want to understand both:

1. How to use the key mappings day to day.
2. Why each config choice exists.

## 1. What This Setup Tries to Optimize

This tmux setup is designed for a keyboard-first workflow with Vim-like movement:

- Fast pane navigation (`h/j/k/l`, `Ctrl + h/j/k/l`)
- Fast pane resizing (`Shift + h/j/k/l`, `Alt + h/j/k/l`)
- Split panes in the same project directory
- Vi-style copy mode
- Clear status line with session, windows, prefix state, host, and time

The config keeps your original preference for `Ctrl + a` as prefix, but modernizes terminal and status settings for tmux 3.x.

## 2. Key Notation Used in This Guide

- `Prefix` means tmux prefix key. In this config it is `Ctrl + a`.
- `C-x` means `Ctrl + x`.
- `M-x` means `Alt + x` (Meta).
- `S-Left` means `Shift + Left Arrow`.
- `Prefix + k` means press `Ctrl + a`, release, then press `k`.

## 3. First 5 Minutes (Quick Start)

1. Start tmux:
```bash
tmux
```
2. Split the current pane:
- `Prefix + v` for vertical split
- `Prefix + s` for horizontal split
3. Move across panes:
- `Prefix + h/j/k/l`
4. Resize panes:
- `Prefix + H/J/K/L` (5 cells each step)
5. Reload config after edits:
- `Prefix + r`

## 4. Core Config Choices Explained

### 4.1 Indexing and history

- `base-index 1`: windows start at 1 instead of 0.
- `pane-base-index 1`: panes start at 1 instead of 0.
- `renumber-windows on`: closing a window compacts numbering.
- `history-limit 100000`: larger scrollback history per pane.

Why this matters:

- 1-based indexing is easier for many people to scan quickly.
- Larger history helps when debugging logs or long command output.

### 4.2 Prefix and input responsiveness

- Unbind default `Ctrl + b`.
- Set prefix to `Ctrl + a`.
- Keep `Prefix + Ctrl + a` sending a literal prefix.
- `escape-time 10`: reduces delay when pressing `Esc` in Vim/copy-mode.
- `focus-events on`: better editor integration in pane focus changes.

### 4.3 Terminal behavior (modern tmux 3.x approach)

- `default-terminal "tmux-256color"`: use tmux's dedicated terminfo.
- `terminal-features "*:RGB"`: advertise truecolor support.
- `set-clipboard on`: enables clipboard integration when terminal supports it.
- `copy-command` auto-detection: picks first available tool in this order:
  - `wl-copy` (Wayland)
  - `pbcopy` (macOS)
  - `xclip` (X11)
  - `xsel` (X11)

Why this is better than old patterns:

- It avoids legacy `screen-256color` defaults.
- It avoids brittle `terminal-overrides` hacks from older configs.

### 4.4 Editing style and activity settings

- `mode-keys vi`: Vi keys in copy-mode.
- `status-keys vi`: Vi-style keys in command/status prompts.
- `mouse on`: scroll/select/resize support for mixed keyboard+mouse use.
- `monitor-activity on` + `visual-activity off`: track activity quietly.

### 4.5 Naming and terminal titles

- `allow-rename off`: programs cannot unexpectedly rename windows.
- `automatic-rename on`: tmux can rename windows based on active command.
- `set-titles on`: update terminal title.
- `set-titles-string "#S:#W"`: title shows session and current window.

## 5. Key Mappings, Fully Documented

### 5.1 Pane split keys

- `Prefix + v`: split vertically (`split-window -h`) in current path.
- `Prefix + s`: split horizontally (`split-window -v`) in current path.

Important detail:

- New panes inherit the active pane's directory (`#{pane_current_path}`), so you stay in the same project context.

### 5.2 Pane navigation

With prefix:

- `Prefix + h`: move left
- `Prefix + j`: move down
- `Prefix + k`: move up
- `Prefix + l`: move right

Without prefix:

- `Ctrl + h/j/k/l`: same directional pane navigation
- `Ctrl + Arrow Keys`: same directional pane navigation

### 5.3 Pane resizing

With prefix, coarse resize (5 cells):

- `Prefix + H`: resize left
- `Prefix + J`: resize down
- `Prefix + K`: resize up
- `Prefix + L`: resize right

Without prefix, fine resize (1 cell):

- `Alt + h/j/k/l`: resize left/down/up/right

### 5.4 Window switching

- `Shift + Left`: previous window
- `Shift + Right`: next window

### 5.5 Copy-mode mappings (Vi mode)

- `Prefix + Enter`: enter copy-mode
- In copy-mode:
  - `v`: begin selection
  - `y`: copy selection to tmux buffer and system clipboard, then exit copy-mode
  - `r`: toggle rectangle selection

Clipboard note:

- For your current machine, tmux will use `xclip` (or `xsel` fallback) automatically.
- If you switch to Wayland later and install `wl-clipboard`, tmux will prefer `wl-copy` automatically.

## 6. Reloading and Safe Iteration

- `Prefix + r`: reload `~/.config/tmux/tmux.conf` and show confirmation.

Recommended workflow when tuning config:

1. Edit `tmux/tmux.conf` in this repo.
2. Reload with `Prefix + r`.
3. Iterate in small changes so rollback is easy with Git history.

## 7. Status Line Guide

The status line is intentionally simple and fast:

- Left side: current session name (`#S`)
- Middle: window list (`#I:#W`)
- Right side:
  - `PREFIX` indicator (only shown when prefix is active)
  - Hostname (`#H`)
  - Current time (`%H:%M`)

Visual behavior:

- Status line uses classic black background with white text
- Window highlighting uses tmux defaults (no custom blue/green tab theme)

## 8. Migration Notes

What was intentionally modernized from the old file:

- `screen-256color` -> `tmux-256color`
- Removed legacy `terminal-overrides` alt-screen hack
- Added split-in-current-directory behavior
- Restored status line styling and widgets to match the original theme
- Enabled mouse support by default for beginner friendliness

## 9. Practice Exercises

1. Open tmux, create 3 panes, and move between them using only `Ctrl + h/j/k/l`.
2. Resize one pane with `Prefix + H/J/K/L`, then fine-tune with `Alt + h/j/k/l`.
3. Enter copy-mode, select text with `v`, copy with `y`, and paste in shell.
4. Rename a window manually, then run a command and observe rename behavior.
5. Edit `tmux/tmux.conf`, reload with `Prefix + r`, and verify status changes.

## 10. Clipboard Troubleshooting

1. Check what tmux selected as clipboard backend:
```bash
tmux show -s copy-command
```
2. If it shows `xclip`/`xsel` and copy still fails, verify `DISPLAY` is set in your tmux session.
3. If you are on Wayland, install `wl-clipboard` so `wl-copy` is available.
