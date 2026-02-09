echo "***** Starting zsh script $(date +%H:%M:%S)"

zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

autoload -U compinit; compinit
_comp_options+=(globdots)

source ~/dotfiles/zsh/external/completion.zsh
source ~/dotfiles/zsh/external/bd.zsh
source "$XDG_CONFIG_HOME/zsh/aliases"

fpath=($ZDOTDIR/external $fpath)

autoload -Uz prompt_purification_setup; prompt_purification_setup

setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# enable VI mode
bindkey -v
export KEYTIMEOUT=1

autoload -Uz cursor_mode && cursor_mode

if [ $(command -v "fzf") ]; then
   source /usr/share/fzf/completion.zsh
   source /usr/share/fzf/key-bindings.zsh
fi

export EDITOR="nvim"
export VISUAL="nvim"

alias vim="nvim"

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export JAVA_HOME=/usr/lib/jvm/default

export PATH="$PATH:$HOME/.local/bin"

. "$HOME/.config/local/share/../bin/env"

export GPG_TTY=$(tty)

export HF_HOME="$HOME/.cache/huggingface"

# Big, shared, sane history
HISTSIZE=200000
SAVEHIST=200000
HISTFILE=~/.zsh_history

setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY

bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Ctrl+r → interactive fuzzy history
bindkey '^R' fzf-history-widget

echo "****** Ending zsh script $(date +%H:%M:%S)"
