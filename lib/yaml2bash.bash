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

keys() {
  local prefix=${1//[/_}; prefix=${prefix//]/}
  if declare -p "${prefix}" 2>/dev/null | grep -q '^declare \-A'; then
    local keys="${prefix}[KEYS]"
    echo ${!keys}
  fi
}

value() {
  local prefix=${1//[/_}; prefix=${prefix//]/}
  if ! declare -p "${prefix}" 2>/dev/null | grep -q '^declare \-A'; then
    echo "${!prefix}"
  fi
}

json() {
  local prefix=${1//[/_}; prefix=${prefix//]/}
  if declare -p "${prefix}" 2>/dev/null | grep -q '^declare \-A'; then
    local keys="${prefix}[KEYS]"
    local values="{"
    for key in ${!keys}; do
      values="${values} \"$key\":$(json ${prefix}_${key}),"
    done
    values="${values} }"
    echo ${values} | sed -e 's/, }/ }/g'
  else
    echo "\"$(echo ${!prefix} | sed -e 's/"/\\\"/g' -e 's/\\x/\\\\x/g')\""
  fi
}
