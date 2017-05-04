#!/usr/bin/env bash
set -e

eval $(yaml2bash -p GLOBAL test.yaml)

yaml2bash_in_local() {
  eval $(yaml2bash -p LOCAL test.yaml)
  declare -p GLOBAL
  declare -p LOCAL
}

yaml2bash_in_local

declare -p GLOBAL
declare -p LOCAL
