# dotfiles

Personal Arch Linux dotfiles with a CLI-first setup.

This repo currently manages:

- `zsh` (shell config and aliases)
- `nvim` (language-focused Neovim setup)
- `tmux`

## Repository Layout

- `zsh/`: shell config, aliases, helper scripts
- `nvim/`: Neovim config and plugin setup
- `tmux/`: tmux config
- `install.sh`: symlink installer (backs up existing files)
- `bootstrap.sh`: Arch Linux bootstrap + installer

## Quick Start

### 1) Clone

```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
```

### 2) Install symlinks only

```bash
./install.sh
```

### 3) Full bootstrap (Arch Linux)

```bash
./bootstrap.sh
```

`bootstrap.sh` expects `pacman` and installs packages, then runs `install.sh`.

## What `install.sh` Does

It creates symlinks and auto-backs up existing targets with a timestamp suffix.

Managed links:

- `~/.zshenv` -> `zsh/.zshenv`
- `$XDG_CONFIG_HOME/zsh/.zshrc` -> `zsh/.zshrc`
- `$XDG_CONFIG_HOME/zsh/.zprofile` -> `zsh/.zprofile`
- `$XDG_CONFIG_HOME/zsh/aliases` -> `zsh/aliases`
- `$XDG_CONFIG_HOME/zsh/external` -> `zsh/external`
- `$XDG_CONFIG_HOME/nvim` -> `nvim`
- `$XDG_CONFIG_HOME/tmux/tmux.conf` -> `tmux/tmux.conf`

## Neovim Docs

- `nvim/README.md`
- `nvim/USER_GUIDE.md`

## tmux Docs

- `tmux/USER_GUIDE.md`
