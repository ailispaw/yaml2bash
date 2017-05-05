#!/usr/bin/env bash

traverse() {
  local prefix=${1//[/_}; prefix=${prefix//]/}
  if declare -p "${prefix}" 2>/dev/null | grep -q '^declare \-A'; then
    local keys="${prefix}[KEYS]"
    for key in ${!keys}; do
      traverse "${prefix}_$key"
    done
  else
    echo "${prefix}=${!prefix}"
  fi
}

count() {
  local prefix=${1//[/_}; prefix=${prefix//]/}
  if declare -p "${prefix}" 2>/dev/null | grep -q '^declare \-A'; then
    local keys="${prefix}[KEYS]"
    keys=(${!keys})
    echo ${#keys[@]}
  elif [ -n "${!prefix}" ]; then
    echo 1
  else
    echo 0
  fi
}
