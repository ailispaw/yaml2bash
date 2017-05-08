#!/usr/bin/env bash
set -e

eval $(docker run -i --rm ailispaw/yaml2bash -m < test.yaml)
declare -p Y2B >/dev/null

# To traverse YAML structure
y2b_traverse Y2B
y2b_traverse Y2B_0
y2b_traverse Y2B_0_users

# To count chidren of an individual variable
y2b_count Y2B
y2b_count Y2B_0
y2b_count Y2B_0_users
