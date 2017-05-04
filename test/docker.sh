#!/usr/bin/env bash
set -e

source ../lib/yaml2bash.bash

eval $(docker run -i --rm ailispaw/yaml2bash -m < test.yaml)
declare -p YAML >/dev/null

# To traverse YAML structure
traverse YAML
traverse YAML_0
traverse YAML_0_users

# To count chidren of an individual variable
count YAML
count YAML_0
count YAML_0_users
