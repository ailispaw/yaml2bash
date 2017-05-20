#!/usr/bin/env bash
set -e

../src/yaml2bash test.yaml

eval $(../src/yaml2bash test.yaml)

echo "--------------------------------------------------------------------------------"
echo "Traversing"
echo "--------------------------------------------------------------------------------"

y2b_traverse Y2B

echo "--------------------------------------------------------------------------------"
echo "Reference"
echo "--------------------------------------------------------------------------------"
echo "Y2B_hostname=${Y2B_hostname}"
echo "Y2B_users_0_name=${Y2B_users_0_name}"
echo "Y2B_users_0_gecos=${Y2B_users_0_gecos}"
echo "Y2B_users_0_primary_group=${Y2B_users_0_primary_group}"
echo "Y2B_users_0_system=${Y2B_users_0_system}"
echo "Y2B_users_1_name=${Y2B_users_1_name}"
echo "Y2B_users_2_name=${Y2B_users_2_name}"
echo "Y2B_users_2_tests_array_0=${Y2B_users_2_tests_array_0}"
echo "Y2B_users_2_tests_array_1_0=${Y2B_users_2_tests_array_1_0}"
echo "Y2B_users_2_tests_array_1_1=${Y2B_users_2_tests_array_1_1}"
echo "Y2B_users_2_tests_array_2_0=${Y2B_users_2_tests_array_2_0}"
echo "Y2B_users_2_tests_array_2_1=${Y2B_users_2_tests_array_2_1}"
echo "Y2B_users_2_tests_array_3=${Y2B_users_2_tests_array_3}"
echo "Y2B_users_2_tests_flow_0=${Y2B_users_2_tests_flow_0}"
echo "Y2B_users_2_tests_flow_1=${Y2B_users_2_tests_flow_1}"
echo "Y2B_users_2_tests_flow_2_0=${Y2B_users_2_tests_flow_2_0}"
echo "Y2B_users_2_tests_flow_2_1=${Y2B_users_2_tests_flow_2_1}"
echo "Y2B_users_2_tests_flow_3_map=${Y2B_users_2_tests_flow_3_map}"
echo "Y2B_users_2_tests_literal=${Y2B_users_2_tests_literal}"
echo "Y2B_users_2_tests_folded=${Y2B_users_2_tests_folded}"
echo "Y2B_users_2_tests_mapping_name=${Y2B_users_2_tests_mapping_name}"
echo "Y2B_users_2_tests_mapping_array_0=${Y2B_users_2_tests_mapping_array_0}"
echo "Y2B_users_2_tests_mapping_array_1=${Y2B_users_2_tests_mapping_array_1}"
echo "Y2B_users_2_tests_json_literal=${Y2B_users_2_tests_json_literal}"
echo "Y2B_users_2_tests_json_folded=${Y2B_users_2_tests_json_folded}"

echo "--------------------------------------------------------------------------------"
echo "Counting"
echo "--------------------------------------------------------------------------------"

echo "y2b_count(Y2B)=$(y2b_count Y2B)"
echo "y2b_count(Y2B[users])=$(y2b_count Y2B[users])"
echo "y2b_count(Y2B[users][0][name])=$(y2b_count Y2B[users][0][name])"
echo "y2b_count(Y2B[users][1][name])=$(y2b_count Y2B[users][1][name])"
echo "y2b_count(Y2B[users][1][name][x])=$(y2b_count Y2B[users][1][name][x])"
echo "y2b_count(Y2B[users][2][tests][array])=$(y2b_count Y2B[users][2][tests][array])"
echo "y2b_count(Y2B[users][2][tests][flow])=$(y2b_count Y2B[users][2][tests][flow])"
echo "y2b_count(Y2B[users][2][tests][literal])=$(y2b_count Y2B[users][2][tests][literal])"
echo "y2b_count(Y2B[users][2][tests][folded])=$(y2b_count Y2B[users][2][tests][folded])"
echo "y2b_count(Y2B[users][2][tests][mapping])=$(y2b_count Y2B[users][2][tests][mapping])"
echo "y2b_count(Y2B[users][2][tests][json])=$(y2b_count Y2B[users][2][tests][json])"

echo "--------------------------------------------------------------------------------"
echo "Getting Keys"
echo "--------------------------------------------------------------------------------"

echo "y2b_keys(Y2B)=$(y2b_keys Y2B)"
echo "y2b_keys(Y2B[users])=$(y2b_keys Y2B[users])"
echo "y2b_keys(Y2B[users][0])=$(y2b_keys Y2B[users][0])"

echo "--------------------------------------------------------------------------------"
echo "Getting a Single Value (same as Reference)"
echo "--------------------------------------------------------------------------------"

echo "Y2B_users_0_name=${Y2B_users_0_name}"
echo "y2b_value(Y2B[users][0][name])=$(y2b_value Y2B[users][0][name])"
echo "Y2B_users_0_primary_group=${Y2B_users_0_primary_group}"
echo "y2b_value(Y2B_users[0][primary-group])=$(y2b_value Y2B_users[0][primary-group])"
echo "Y2B_users_2_tests_literal=${Y2B_users_2_tests_literal}"
echo "y2b_value(Y2B[users][2][tests][literal])=$(y2b_value Y2B[users][2][tests][literal])"

echo "--------------------------------------------------------------------------------"
echo "Convert to Json"
echo "--------------------------------------------------------------------------------"

echo "y2b_json(Y2B)=$(y2b_json Y2B)"
echo "y2b_json(Y2B[users])=$(y2b_json Y2B[users])"
echo "y2b_json(Y2B[users][0])=$(y2b_json Y2B[users][0])"
echo "y2b_json(Y2B[users][0][name])=$(y2b_json Y2B[users][0][name])"
echo "y2b_json(Y2B[users][2][tests][literal])=$(y2b_json Y2B[users][2][tests][literal])"
