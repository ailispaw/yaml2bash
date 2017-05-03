#!/usr/bin/env bash

FILE=$1

if [ -z "${FILE}" ]; then
  echo "Usage $(basename $0) <file-name>" >&2
  exit 1
fi

../lib/yaml2bash "${FILE}"

source ../lib/yaml2bash.bash

eval $(../lib/yaml2bash "${FILE}")

echo "--------------------------------------------------------------------------------"
echo "Traversing"
echo "--------------------------------------------------------------------------------"

traverse YAML

echo "--------------------------------------------------------------------------------"
echo "Counting"
echo "--------------------------------------------------------------------------------"

echo "count(YAML)=$(count YAML)"
