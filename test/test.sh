#!/usr/bin/env bash
set -e

../src/yaml2bash test.yaml

source ../lib/yaml2bash.bash

eval $(../src/yaml2bash test.yaml)
declare -p YAML >/dev/null

echo "--------------------------------------------------------------------------------"
echo "Traversing"
echo "--------------------------------------------------------------------------------"

traverse YAML

echo "--------------------------------------------------------------------------------"
echo "Reference"
echo "--------------------------------------------------------------------------------"
echo "YAML_hostname=${YAML_hostname}"
echo "YAML_users_0_name=${YAML_users_0_name}"
echo "YAML_users_0_gecos=${YAML_users_0_gecos}"
echo "YAML_users_0_system=${YAML_users_0_system}"
echo "YAML_users_1_name=${YAML_users_1_name}"
echo "YAML_users_2_name=${YAML_users_2_name}"
echo "YAML_users_2_tests_array_0=${YAML_users_2_tests_array_0}"
echo "YAML_users_2_tests_array_1_0=${YAML_users_2_tests_array_1_0}"
echo "YAML_users_2_tests_array_1_1=${YAML_users_2_tests_array_1_1}"
echo "YAML_users_2_tests_array_2_0=${YAML_users_2_tests_array_2_0}"
echo "YAML_users_2_tests_array_2_1=${YAML_users_2_tests_array_2_1}"
echo "YAML_users_2_tests_array_3=${YAML_users_2_tests_array_3}"
echo "YAML_users_2_tests_flow_0=${YAML_users_2_tests_flow_0}"
echo "YAML_users_2_tests_flow_1=${YAML_users_2_tests_flow_1}"
echo "YAML_users_2_tests_flow_2_0=${YAML_users_2_tests_flow_2_0}"
echo "YAML_users_2_tests_flow_2_1=${YAML_users_2_tests_flow_2_1}"
echo "YAML_users_2_tests_flow_3_map=${YAML_users_2_tests_flow_3_map}"
echo "YAML_users_2_tests_literal=${YAML_users_2_tests_literal}"
echo "YAML_users_2_tests_folded=${YAML_users_2_tests_folded}"
echo "YAML_users_2_tests_mapping_name=${YAML_users_2_tests_mapping_name}"
echo "YAML_users_2_tests_mapping_array_0=${YAML_users_2_tests_mapping_array_0}"
echo "YAML_users_2_tests_mapping_array_1=${YAML_users_2_tests_mapping_array_1}"
echo "YAML_users_2_tests_json_literal=${YAML_users_2_tests_json_literal}"
echo "YAML_users_2_tests_json_folded=${YAML_users_2_tests_json_folded}"

echo "--------------------------------------------------------------------------------"
echo "Counting"
echo "--------------------------------------------------------------------------------"

echo "count(YAML)=$(count YAML)"
echo "count(YAML[users])=$(count YAML[users])"
echo "count(YAML[users][0][name])=$(count YAML[users][0][name])"
echo "count(YAML[users][1][name])=$(count YAML[users][1][name])"
echo "count(YAML[users][1][name][x])=$(count YAML[users][1][name][x])"
echo "count(YAML[users][2][tests][array])=$(count YAML[users][2][tests][array])"
echo "count(YAML[users][2][tests][flow])=$(count YAML[users][2][tests][flow])"
echo "count(YAML[users][2][tests][literal])=$(count YAML[users][2][tests][literal])"
echo "count(YAML[users][2][tests][folded])=$(count YAML[users][2][tests][folded])"
echo "count(YAML[users][2][tests][mapping])=$(count YAML[users][2][tests][mapping])"
echo "count(YAML[users][2][tests][json])=$(count YAML[users][2][tests][json])"

echo "--------------------------------------------------------------------------------"
echo "Getting Keys"
echo "--------------------------------------------------------------------------------"

echo "keys(YAML)=$(keys YAML)"
echo "keys(YAML[users])=$(keys YAML[users])"
echo "keys(YAML[users][0])=$(keys YAML[users][0])"

echo "--------------------------------------------------------------------------------"
echo "Getting a Single Value (same as Reference)"
echo "--------------------------------------------------------------------------------"

echo "YAML_users_0_name=${YAML_users_0_name}"
echo "value(YAML[users][0][name])=$(value YAML[users][0][name])"
echo "YAML_users_2_tests_literal=${YAML_users_2_tests_literal}"
echo "value(YAML[users][2][tests][literal])=$(value YAML[users][2][tests][literal])"

echo "--------------------------------------------------------------------------------"
echo "Convert to Json"
echo "--------------------------------------------------------------------------------"

echo "json(YAML)=$(json YAML)"
echo "json(YAML[users])=$(json YAML[users])"
echo "json(YAML[users][0])=$(json YAML[users][0])"
echo "json(YAML[users][0][name])=$(json YAML[users][0][name])"
echo "json(YAML[users][2][tests][literal])=$(json YAML[users][2][tests][literal])"
