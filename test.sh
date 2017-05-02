#!/usr/bin/env bash

./lib/yaml2bash ./examples/test.yaml

source ./lib/yaml2bash.bash

eval $(./lib/yaml2bash ./examples/test.yaml)

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
echo "count(YAML_users)=$(count YAML_users)"
echo "count(YAML_users_0_name)=$(count YAML_users_0_name)"
echo "count(YAML_users_1_name)=$(count YAML_users_1_name)"
echo "count(YAML_users_1_name_x)=$(count YAML_users_1_name_x)"
echo "count(YAML_users_2_tests_array)=$(count YAML_users_2_tests_array)"
echo "count(YAML_users_2_tests_flow)=$(count YAML_users_2_tests_flow)"
echo "count(YAML_users_2_tests_literal)=$(count YAML_users_2_tests_literal)"
echo "count(YAML_users_2_tests_folded)=$(count YAML_users_2_tests_folded)"
echo "count(YAML_users_2_tests_mapping)=$(count YAML_users_2_tests_mapping)"
echo "count(YAML_users_2_tests_json)=$(count YAML_users_2_tests_json)"
