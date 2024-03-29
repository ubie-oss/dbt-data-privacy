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

# Install the `dbt-data-privacy` package
dbt deps --profiles-dir "${INTEGRATION_TESTS_DIR}/profiles" --target "${dbt_target:?}"

# Integration tests
dbt build --profiles-dir "${dbt_profiles_dir:?}" \
    --target "${dbt_target:?}" \
    --vars "$(cat "${vars_path:?}")" \
    --full-refresh
