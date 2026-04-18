#!/bin/false
# This file is intended to be sourced by .zshrc configuration script, not executed directly.

# Globals
readonly plugins_dir="${XDG_DATA_HOME:-${HOME}/.local/share}/zsh/plugins"

# Logging
log_section() {
  printf ":: %s\n" "${1:-}"
}

log_step() {
  printf " => %s...\n" "${1:-}"
}

log_item() {
  printf " %s...\n" "${1:-}"
}

log_info() {
  printf "%s\n" "${1:-}"
}

log_warning() {
  printf "warning: %s\n" "${1:-}" >&2
}

log_error() {
  printf "error: %s\n" "${1:-}" >&2
}

# Plugins are defined as "username/repo:source_file" pairs.
# The colon-delimited format maps each repository to its entry point file
# in a single array, since source file names do not always match the
# repository name. This also preserves load order, which is critical:
# fzf-tab must load after compinit but before widget-wrapping plugins,
# and zsh-vi-mode must load last as it overrides widget bindings.
plugins=(
  "romkatv/powerlevel10k:powerlevel10k.zsh-theme"
  "Aloxaf/fzf-tab:fzf-tab.plugin.zsh"
  "zsh-users/zsh-autosuggestions:zsh-autosuggestions.zsh"
  "zdharma-continuum/fast-syntax-highlighting:fast-syntax-highlighting.plugin.zsh"
  "jeffreytse/zsh-vi-mode:zsh-vi-mode.plugin.zsh"
)

# Clone zsh plugins if not already installed
_clone_zsh_plugin() {
  local repo
  local name
  repo="${1}"
  name="${2}"

  log_step "Cloning ${name}"

  if ! git clone --quiet --depth=1 "https://github.com/${repo}.git" "${plugins_dir}/${name}"; then
    log_error "Failed to clone ${name}"
    return 1
  fi
}

# Source zsh plugins in the order they are defined.
# Note: fpath is not populated here because fzf-tab requires compinit to run
# before it is sourced, but fpath must be populated before compinit. Supporting
# fpath would require a two-pass loading strategy.
_load_and_init_zsh_plugins() {
  local plugin_repo
  local plugin_file
  local plugin_name

  mkdir -p "${plugins_dir}"

  for plugin in "${@}"; do
    plugin_repo="${plugin%%:*}"
    plugin_file="${plugin##*:}"
    plugin_name="${plugin_repo##*/}"

    if [[ ! -f "${plugins_dir}/${plugin_name}/${plugin_file}" ]]; then
      _clone_zsh_plugin "${plugin_repo}" "${plugin_name}" || continue
    fi

    source "${plugins_dir}/${plugin_name}/${plugin_file}"
  done
}

# Update a single plugin, returning to the original directory on completion or failure
_update_zsh_plugin_internal() {
  local plugin
  local name
  plugin="${1}"
  name="$(basename "${plugin}")"

  log_item "Checking ${name}"

  pushd "${plugin}" >/dev/null || return 1
  git fetch >/dev/null 2>&1

  local local_commit
  local remote_commit
  local_commit="$(git rev-parse HEAD)"
  remote_commit="$(git rev-parse @{u})"

  if [[ "${local_commit}" != "${remote_commit}" ]]; then
    log_info "Local commit: ${local_commit}"
    log_info "Remote commit: ${remote_commit}"
    printf "Do you want to update %s? [Y/y to update, any other key to skip]: " "${name}"
    read -r choice

    case "${choice}" in
    [Yy])
      log_step "Updating ${name}"
      git pull
      ;;
    *)
      log_item "Skipping ${name}"
      ;;
    esac
  fi

  popd >/dev/null || return 1
}

# Update all installed plugins
update_zsh_plugins() {
  log_section "Updating zsh plugins"

  mkdir -p "${logs_dir}"
  pushd "${plugins_dir}" >/dev/null || return 1

  for plugin in "${plugins_dir}"/*; do
    if [[ -d "${plugin}/.git" ]]; then
      _update_zsh_plugin_internal "${plugin}"
    fi
  done

  popd >/dev/null || return 1

  log_info "Log file: ${logs_file}"
  log_info "Done"
}

_load_and_init_zsh_plugins "${plugins[@]}"

# Unset private functions and variables to avoid polluting the global namespace.
# update_zsh_plugins is intentionally kept available for interactive use.
unset -f _clone_zsh_plugin
unset -f _load_and_init_zsh_plugins
unset plugins
