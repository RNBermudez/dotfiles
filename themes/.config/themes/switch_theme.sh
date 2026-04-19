#!/usr/bin/env bash
# Description: Switch themes interactively (fzf) or via argument.
#
# Prerequisites: fd, fzf
#
# Usage: ./switch_theme.sh [theme]

set -euo pipefail

usage() {
  awk '/^# Usage:/{p=1} p && /^#?$/{exit} p{sub(/^# ?/,""); print}' "$0" >&2
  exit 2
}

# Globals
config_dir="${XDG_CONFIG_HOME:-${HOME}/.config}"
themes_dir="${config_dir}/themes"

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

# Some apps do not have a stow package, thus they directories must be created
auto_create_dirs=(
  eza
)

# Maps theme template files to their symlink destinations on the config dir
declare -A theme_links=(
  [atuin]="atuin/themes/theme.toml"
  [bat]="bat/themes/theme.tmTheme"
  [btop]="btop/themes/theme.theme"
  [delta]="git/themes/theme.gitconfig"
  [dunst]="dunst/dunstrc.d/theme.conf"
  [eza]="eza/theme.yml"
  [foot]="foot/theme.ini"
  [fuzzel]="fuzzel/theme.ini"
  [fzf]="zsh/config/fzf_theme.zsh"
  [ghostty]="ghostty/themes/theme"
  [hyprland]="hypr/modules/theme.conf"
  [hyprland_uwsm]="uwsm/env-hyprland"
  [k9s]="k9s/theme.yaml"
  [p10k]="p10k/colors.zsh"
  [waybar_css]="waybar/style.css"
  [waybar]="waybar/config.jsonc"
  [yazi]="yazi/theme.toml"
  [zathura]="zathura/themes/themerc"
)

# Maps
declare -A reload_commands=(
  [bat]="bat cache --build"
  [btop]="pkill -USR2 btop || true"
  [dunst]="dunstctl reload"
  [foot]="systemctl --user restart foot-server.service"
  [ghostty]="pkill -SIGUSR2 ghostty"
  [hyprland]="hyprctl reload"
  [waybar]="systemctl --user restart waybar.service"
)

# Functions
apply_theme() {
  local theme
  local theme_path
  theme="${1}"
  theme_path="${themes_dir}/${theme}"

  if [[ ! -d "${theme_path}" ]]; then
    log_error "theme ${theme} not found in ${themes_dir}"
    exit 1
  fi

  log_section "Applying theme $(echo "${theme}" | tr '-' ' ' | sed 's/\b./\u&/g')"

  for app in "${!theme_links[@]}"; do
    local src
    local dest
    local dest_dir
    src="${theme_path}/${app}"
    dest="${config_dir}/${theme_links[${app}]}"
    dest_dir="$(dirname "${dest}")"

    log_item "${app}"

    if [[ ! -d "${dest_dir}" ]]; then
      if [[ " ${auto_create_dirs[*]} " == *" ${app} "* ]]; then
        log_step "creating ${dest_dir}"
        mkdir -p "${dest_dir}"
      else
        log_warning "config for ${app} not found, skipping"
        continue
      fi
    fi

    if [[ ! -f "${src}" ]]; then
      log_warning "no theme file found, skipping"
      continue
    fi

    cp "${src}" "${dest}"

    if [[ -v "reload_commands[${app}]" ]]; then
      log_step "reloading ${app}"
      bash -c "${reload_commands[${app}]}" >/dev/null 2>&1 || log_warning "failed to reload ${app}"
    fi
  done
}

# Main
[[ $# -gt 1 ]] && usage

if [[ -z "${1:-}" ]]; then
  log_section "Selecting theme"

  theme=$(fd --type d -E 'matugen' -d 1 --format "{/}" -C "${themes_dir}/" -0 |
    fzf --read0)
  [[ -z "${theme}" ]] && exit 1
else
  theme="${1}"
fi

apply_theme "${theme}"

log_info "Done"
