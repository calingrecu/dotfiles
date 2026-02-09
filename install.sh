#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Respect existing XDG vars, but provide sane defaults.
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

backup_if_exists() {
  local target="$1"
  if [ -e "$target" ] || [ -L "$target" ]; then
    local ts
    ts="$(date +%Y%m%d%H%M%S)"
    mv -f "$target" "${target}.bak.${ts}"
  fi
}

link_file() {
  local src="$1"
  local dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    if [ "$(readlink "$dest" 2>/dev/null || true)" = "$src" ]; then
      return
    fi
    backup_if_exists "$dest"
  fi
  ln -s "$src" "$dest"
}

link_dir() {
  local src="$1"
  local dest="$2"
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    if [ "$(readlink "$dest" 2>/dev/null || true)" = "$src" ]; then
      return
    fi
    backup_if_exists "$dest"
  fi
  ln -s "$src" "$dest"
}

# zsh: keep .zshenv in $HOME, everything else in $ZDOTDIR.
link_file "$DOTFILES_DIR/zsh/.zshenv" "$HOME/.zshenv"

ZDOTDIR="$XDG_CONFIG_HOME/zsh"
mkdir -p "$ZDOTDIR"
link_file "$DOTFILES_DIR/zsh/.zshrc" "$ZDOTDIR/.zshrc"
link_file "$DOTFILES_DIR/zsh/.zprofile" "$ZDOTDIR/.zprofile"
link_file "$DOTFILES_DIR/zsh/aliases" "$ZDOTDIR/aliases"
link_dir "$DOTFILES_DIR/zsh/external" "$ZDOTDIR/external"

# nvim
link_dir "$DOTFILES_DIR/nvim" "$XDG_CONFIG_HOME/nvim"

# tmux
link_file "$DOTFILES_DIR/tmux/tmux.conf" "$XDG_CONFIG_HOME/tmux/tmux.conf"

echo "Dotfiles installed from $DOTFILES_DIR"
