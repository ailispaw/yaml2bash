#!/usr/bin/env bash

traverse() {
  local prefix=${1//[/_}; prefix=${prefix//]/}
  if declare -p "${prefix}" 2>/dev/null | grep -q '^declare \-A'; then
    local k
    local _keys=($(keys "${prefix}"))
    for k in "${_keys[@]}"; do
      traverse "${prefix}_${k}"
    done
  else
    echo "${prefix}=${!prefix}"
  fi
}

count() {
  local prefix=${1//[/_}; prefix=${prefix//]/}
  if declare -p "${prefix}" 2>/dev/null | grep -q '^declare \-A'; then
    local _keys=($(keys "${prefix}"))
    echo ${#_keys[@]}
  elif [ -n "${!prefix}" ]; then
    echo 1
  else
    echo 0
  fi
}

reverse() {
  local i
  for (( i = ${#} ; i > 0 ; i-- )); do
    echo "${!i}"
  done
}

keys() {
  local prefix=${1//[/_}; prefix=${prefix//]/}
  if declare -p "${prefix}" 2>/dev/null | grep -q '^declare \-A'; then
    local k
    local _keys="${prefix}[KEYS]"
    local _uniq_keys=""
    declare -A _hash_keys
    _keys=($(reverse ${!_keys}))
    for k in "${_keys[@]}"; do
      if [ -z "${_hash_keys[${k}]}" ]; then
        _uniq_keys="${k} ${_uniq_keys}"
        _hash_keys[${k}]=1
      fi
    done
    echo ${_uniq_keys}
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
    local k
    local _keys=($(keys "${prefix}"))
    local values="{"
    for k in "${_keys[@]}"; do
      values="${values} \"${k}\":$(json ${prefix}_${k}),"
    done
    values="${values} }"
    echo ${values} | sed -e 's/, }/ }/g'
  else
    echo "\"$(echo ${!prefix} | sed -e 's/"/\\\"/g' -e 's/\\x/\\\\x/g')\""
  fi
}
