#!/bin/false
# This file is intended to be sourced by .zshrc configuration script, not executed directly.

alias ls="eza --color=auto --icons=auto --group-directories-first"
alias ll="eza --color=auto --icons=auto --group-directories-first --long --git"
alias la="eza --color=auto --icons=auto --group-directories-first --long --git --all --group"

# kubectl
if [[ -x "$(command -v kubectl)" ]]; then
  alias k="kubectl"
fi

# kubectx
if [[ -x "$(command -v kubectx)" ]]; then
  alias kx="kubectx"
  alias ks="kubens"
fi
