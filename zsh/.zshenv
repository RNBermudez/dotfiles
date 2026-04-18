# XDG Base Directories
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_STATE_HOME="${HOME}/.local/state"

# Applications and development tools
export EDITOR="nvim"
export VISUAL="nvim"

export KUBE_EDITOR="nvim"
export KUBECONFIG="${XDG_CONFIG_HOME}/kube/config"

export K9S_CONFIG_DIR="${XDG_CONFIG_HOME}/k9s"

export GOPATH="${XDG_DATA_HOME}/go"
export GOCACHE="${XDG_CACHE_HOME}/go"

# PATH - deduplicate entries automatically
typeset -U path
path+=(
  "${GOPATH}/bin"
  "${HOME}/.local/bin"
)
