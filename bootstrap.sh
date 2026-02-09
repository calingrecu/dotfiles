#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Respect existing XDG vars, but provide sane defaults.
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

have() { command -v "$1" >/dev/null 2>&1; }

require_pacman() {
  if ! have pacman; then
    echo "pacman not found; this bootstrap is for Arch Linux."
    exit 1
  fi
}

require_sudo() {
  if ! have sudo; then
    echo "sudo not found; cannot install system packages."
    exit 1
  fi
}

install_pacman_pkgs() {
  local pkgs=(
    # Core shell + tooling
    git
    sudo
    curl
    zsh
    zsh-syntax-highlighting
    zsh-autosuggestions
    fzf
    ripgrep
    ctags
    fd
    htop
    just
    links
    man-db
    man-pages
    ranger
    rsync
    tmux
    neovim

    # Build tools (for telescope-fzf-native.nvim and similar)
    base-devel
    base
    cmake

    # Python + uv
    python
    uv

    # Node.js toolchain
    nodejs
    npm
    pnpm
    yarn

    # Misc
    openai-codex
  )

  sudo pacman -Syu --noconfirm
  sudo pacman -S --needed --noconfirm "${pkgs[@]}"
}

install_neovim_node_host() {
  if ! have npm; then
    echo "npm not found; skipping Neovim node host install."
    return
  fi

  local nvim_data="$XDG_DATA_HOME/nvim"
  local host_bin="$nvim_data/node_modules/.bin/neovim-node-host"
  if [ -x "$host_bin" ]; then
    return
  fi

  mkdir -p "$nvim_data"
  npm install --no-progress --silent --prefix "$nvim_data" neovim
}

print_uv_note() {
  cat <<'EOF'
Python tooling note:
  - Use per-project environments with uv (no global tools).
  - Example: cd /path/to/project && uv venv && uv pip install -r requirements.txt
  - For pyproject.toml projects: uv sync
EOF
}

main() {
  require_pacman
  require_sudo
  install_pacman_pkgs
  install_neovim_node_host
  INSTALL_PYTHON=0 "$DOTFILES_DIR/install.sh"
  print_uv_note
  echo "Bootstrap complete."
}

main "$@"
