#!/bin/bash
set -ex


# Constants
INTEGRATION_TESTS_DIR="$(dirname "$(readlink -f "$0")")"

# Default values
dbt_profiles_dir="${INTEGRATION_TESTS_DIR}/profiles"

# Parse options and arguments
while (($# > 0)); do
  if [[ "$1" == "--profiles-dir" ]]; then
    dbt_profiles_dir="${2}"
    shift 2
  elif [[ "$1" == "--target" ]]; then
    dbt_target="${2}"
    shift 2
  elif [[ "$1" == "--vars-path" ]]; then
    vars_path="${2}"
    shift 2
  fi
done

dbt deps --profiles-dir "${INTEGRATION_TESTS_DIR}/profiles" --target "${dbt_target:?}"

# Unit tests
dbt run-operation test_macros \
    --profiles-dir "${dbt_profiles_dir}" \
    --target "${dbt_target:?}" \
    --vars "$(cat "${vars_path:?}")"
