#!/bin/sh

# Add custom script folder to PATH
export PATH="$PATH:${$(find $HOME/.local/bin -type d -printf %p:)%%:}"

# Options
setopt autocd	# AUtomatically cd into typed directory
stty stop undef
setopt interactive_comments

# Start graphical server on user's current tty if not already running
[ "$(tty)" = "/dev/tty1" ] && ! pidof -s Xorg >/dev/null 2>&1 && exec startx $HOME/.xinitrc

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zmodload zsh/complist
_comp_options+=(globdots)               # Include hidden files.

# Useful functions
source "$ZDOTDIR/zsh-functions"

# Normal files to source
zsh_add_file "zsh-exports"
zsh_add_file "zsh-vim-mode"
zsh_add_file "zsh-aliases"
zsh_add_file "zsh-prompt"

# FZF
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
compinit

# Plugins
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"

ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=blue,underline
ZSH_HIGHLIGHT_STYLES[precommand]=fg=blue,underline
ZSH_HIGHLIGHT_STYLES[arg0]=fg=blue

