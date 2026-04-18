# XDG Base Directories
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_STATE_HOME="${HOME}/.local/state"

# Applications and development tools
export EDITOR="nvim"
export VISUAL="nvim"

export GNUPGHOME="$XDG_DATA_HOME"/gnupg

export GOCACHE="${XDG_CACHE_HOME}/go"
export GOPATH="${XDG_DATA_HOME}/go"
export K9S_CONFIG_DIR="${XDG_CONFIG_HOME}/k9s"
export KUBECONFIG="${XDG_CONFIG_HOME}/kube/config"
export KUBE_EDITOR="nvim"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME"/npm
export NPM_CONFIG_INIT_MODULE="$XDG_CONFIG_HOME"/npm/config/npm-init.js
export NPM_CONFIG_TMP="$XDG_RUNTIME_DIR"/npm
export PYTHON_HISTORY="$XDG_STATE_HOME"/python_history

# PATH - deduplicate entries automatically
typeset -U path
path+=(
  "${GOPATH}/bin"
  "${HOME}/.local/bin"
)
