#!/usr/bin/env bash
set -e

FILE=$1

if [ -z "${FILE}" ]; then
  echo "Usage $(basename $0) <file-name>" >&2
  exit 1
fi

../src/yaml2bash "${FILE}"

source ../lib/yaml2bash.bash

eval $(../src/yaml2bash "${FILE}")
declare -p YAML >/dev/null

echo "--------------------------------------------------------------------------------"
echo "Traversing"
echo "--------------------------------------------------------------------------------"

traverse YAML

echo "--------------------------------------------------------------------------------"
echo "Counting"
echo "--------------------------------------------------------------------------------"

echo "count(YAML)=$(count YAML)"
