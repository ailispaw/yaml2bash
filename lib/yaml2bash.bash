#!/usr/bin/env bash

traverse() {
  local prefix=$1
  if declare -p "${prefix}" 2>/dev/null | grep -q '^declare \-A'; then
    local tmp="${prefix}[KEYS]"
    for e in ${!tmp}; do
      traverse "${prefix}_$e"
    done
  else
    echo "${prefix}=${!prefix}"
  fi
}

count() {
  local prefix=$1
  if declare -p "${prefix}" 2>/dev/null | grep -q '^declare \-A'; then
    local tmp="${prefix}[KEYS]"
    local tmp2=(${!tmp})
    echo ${#tmp2[@]}
  elif [ -n "${!prefix}" ]; then
    echo 1
  else
    echo 0
  fi
}
