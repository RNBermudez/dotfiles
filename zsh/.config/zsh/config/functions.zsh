#!/bin/false
# This file is intended to be sourced by .zshrc configuration script, not executed directly.

# cd up n directories
bd() {
  local depth="${1:-1}"
  local target=""

  if [[ ! "${depth}" =~ ^[0-9]+$ ]]; then
    printf "%s\n" "usage: bd [number]" >&2
    return 1
  fi

  repeat "${depth}" target+="../"
  cd "${target}"
}

# Base64 decode
bdec() {
  printf '%s' "${1}" | base64 -d
}

# Create a directory and cd into it
mkd() {
  if [[ "${#}" -ne 1 ]]; then
    echo "usage: mkd <directory>" >&2
    return 1
  fi

  mkdir -p -- "${1}" && builtin cd "${1}"
}

# Change the current working directory when exiting Yazi.
y() {
  local tmpfile

  tmpfile=$(mktemp -t "yazi-cwd.XXXXXX") || return 1

  trap "rm -f -- '${tmpfile}'" EXIT

  command yazi "${@}" --cwd-file="${tmpfile}"

  local ret=${?}
  local cwd

  [[ -f "${tmpfile}" ]] && read -r cwd <"${tmpfile}"
  [[ -n "${cwd}" && "${cwd}" != "${PWD}" && -d "${cwd}" ]] && builtin cd -- "${cwd}"

  return ${ret}
}

colors() {
  for i in {0..7}; do
    local bright=$((i + 8))

    printf "%02d: \x1b[48;5;%dm    \x1b[0m  %02d: \x1b[48;5;%dm    \x1b[0m\n" \
      "${i}" "${i}" "${bright}" "${bright}"
  done
}
