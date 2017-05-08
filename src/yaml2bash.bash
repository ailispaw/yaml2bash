y2b_traverse() {
  local prefix=${1//[/_}; prefix=${prefix//]/}; prefix=${prefix//-/_};
  local prefix_type=$(declare -p "${prefix}" 2>/dev/null);
  if [ "${prefix_type:8:2}" == "-A" ]; then
    local k;
    local keys=($(y2b_keys "${prefix}"));
    for k in "${keys[@]}"; do
      y2b_traverse "${prefix}_${k}";
    done;
  else
    echo "${prefix}=${!prefix}";
  fi;
};

y2b_count() {
  local prefix=${1//[/_}; prefix=${prefix//]/}; prefix=${prefix//-/_};
  local prefix_type=$(declare -p "${prefix}" 2>/dev/null);
  if [ "${prefix_type:8:2}" == "-A" ]; then
    local keys=($(y2b_keys "${prefix}"));
    echo ${#keys[@]};
  elif [ -n "${!prefix}" ]; then
    echo 1;
  else
    echo 0;
  fi;
};

y2b_reverse() {
  local i;
  for (( i = ${#} ; i > 0 ; i-- )); do
    echo "${!i}";
  done;
};

y2b_keys() {
  local prefix=${1//[/_}; prefix=${prefix//]/}; prefix=${prefix//-/_};
  local prefix_type=$(declare -p "${prefix}" 2>/dev/null);
  if [ "${prefix_type:8:2}" == "-A" ]; then
    local k;
    local keys="${prefix}[KEYS]";
    local uniq_keys="";
    declare -A hash_keys;
    keys=($(y2b_reverse ${!keys}));
    for k in "${keys[@]}"; do
      if [ -z "${hash_keys[${k}]}" ]; then
        uniq_keys="${k} ${uniq_keys}";
        hash_keys[${k}]=1;
      fi;
    done;
    echo ${uniq_keys};
  fi;
};

y2b_value() {
  local prefix=${1//[/_}; prefix=${prefix//]/}; prefix=${prefix//-/_};
  local prefix_type=$(declare -p "${prefix}" 2>/dev/null);
  if [ ! "${prefix_type:8:2}" == "-A" ]; then
    echo "${!prefix}";
  fi;
};

y2b_json() {
  local prefix=${1//[/_}; prefix=${prefix//]/}; prefix=${prefix//-/_};
  local prefix_type=$(declare -p "${prefix}" 2>/dev/null);
  if [ "${prefix_type:8:2}" == "-A" ]; then
    local k;
    local keys=($(y2b_keys "${prefix}"));
    local index="${prefix}[INDEX]";
    if [ -n "${!index}" ]; then
      local values="[";
      for k in "${keys[@]}"; do
        values="${values} $(y2b_json ${prefix}_${k}),";
      done;
      echo "${values::-1} ]";
    else
      local values="{";
      for k in "${keys[@]}"; do
        values="${values} \"${k}\":$(y2b_json ${prefix}_${k}),";
      done;
      echo "${values::-1} }";
    fi;
  else
    echo "\"$(echo ${!prefix} | sed -e 's/"/\\\"/g' -e 's/\\x/\\\\x/g')\"";
  fi;
};
