readonly cache_dir="${XDG_CACHE_HOME:-${HOME}/.cache}"
readonly config_dir="${XDG_CONFIG_HOME:-${HOME}/.config}"
readonly data_dir="${XDG_DATA_HOME:-${HOME}/.local/share}"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Ensure XDG directories exist.
mkdir -p \
  "${cache_dir}" \
  "${config_dir}" \
  "${data_dir}" \
  "${HOME}/.local/bin" \
  "${HOME}/.local/state" \
  "${data_dir}/zsh"

# Configure pinentry to use the correct TTY.
# See: https://wiki.archlinux.org/title/GnuPG#Configure_pinentry_to_use_the_correct_TTY
# Must be set before p10k instant prompt captures the terminal state.
export GPG_TTY=$(tty)

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${cache_dir}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${cache_dir}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Export environment variables needed for Homebrew to work
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Load completions
autoload -Uz compinit && compinit -d "${cache_dir}/zcompdump"

# Register keybindings and tool integration to be restored after zsh-vi-mode
# initializes, since zsh-vi-mode overrides widget bindings on startup.
zvm_after_init() {
  zvm_bindkey viins '^p' history-search-backward
  zvm_bindkey viins '^n' history-search-forward
  zvm_bindkey viins '^g' forward-word
  zvm_bindkey viins '^b' backward-word
  zvm_bindkey vicmd '^r' redo

  # Shell integrations
  source <(fzf --zsh)
  eval "$(atuin init zsh)"
  eval "$(zoxide init --cmd cd zsh)"
}

# Source plugin manager
source "${config_dir}/zsh/helpers/plugin-manager.zsh"

# Source the powerlevel10k theme
if [[ -f "${config_dir}/p10k/p10k.zsh" ]]; then
  source "${config_dir}/p10k/p10k.zsh"
fi

# History
HISTSIZE=10000
HISTFILE="${data_dir}/zsh/.zsh_history"
SAVEHIST="${HISTSIZE}"
HISTORY_IGNORE="(ls|ll|la|pwd|clear|reset|exit|history|bd)*"
setopt extended_history
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Shell options
setopt globdots

# FZF options
export FZF_DEFAULT_OPTS=" \
  --height=40% \
  --layout=reverse \
  --info=right \
  --margin=1 \
  --bind=ctrl-p:preview-up,\
ctrl-n:preview-down,\
ctrl-f:half-page-down,\
ctrl-b:half-page-up,\
alt-p:toggle-preview"

export FZF_DEFAULT_COMMAND='fd --hidden --follow --exclude ".git"'
export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
export FZF_ALT_C_COMMAND="${FZF_DEFAULT_COMMAND} --type dir"

_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "${1}"
}

_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "${1}"
}

file_previewer="bat --style=numbers --color=always {}"
dir_previewer="eza --almost-all --color always --tree {}"

export FZF_CTRL_T_OPTS="--preview '([ -f {} ] && ${file_previewer}) || ([ -d {} ] && ${dir_previewer}) || echo {} 2>/dev/null'"
export FZF_ALT_C_OPTS="--preview '${dir_previewer}' --bind '?:toggle-preview'"

# Completion styling
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':completion:*:ls:*' list-dirs-first true
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --almost-all --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --almost-all --color $realpath'
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview 'git diff --color=always $word | delta'
zstyle ':fzf-tab:complete:git-log:*' fzf-preview 'git log --color=always $word'
zstyle ':fzf-tab:complete:git-help:*' fzf-preview 'git help $word | bat -plman --color=always'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview 'case "$group" in "commit tag") git show --color=always $word ;; *) git show --color=always $word | delta ;; esac'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview 'case "$group" in "modified file") git diff --color=always $word | delta ;; "recent commit object name") git show --color=always $word | delta ;; *) git log --color=always $word ;; esac'
zstyle ':completion:*:git-checkout:*' sort false

# Source all config fragments
for file in "${config_dir}/zsh/config"/*.zsh; do
  source "${file}"
done
unset file
