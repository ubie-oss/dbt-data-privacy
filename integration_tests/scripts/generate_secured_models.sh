#!/bin/bash
set -ex


# Constants
INTEGRATION_TESTS_DIR="$(dirname "$(readlink -f "$0")")/.."

# Default values
dbt_profiles_dir="${INTEGRATION_TESTS_DIR}/profiles"
dbt_models_dir="${INTEGRATION_TESTS_DIR}/models"
legacy_schema="true"

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
  elif [[ "$1" == "--modern-schema" ]]; then
    legacy_schema="false"
    shift 1
  fi
done

# Run a dbt command to generate SQL files
generated_models=$(dbt --quiet run-operation generate_privacy_protected_models \
    --profiles-dir "${dbt_profiles_dir:?}" \
    --target "${dbt_target:?}" \
    --vars "$(cat "${vars_path:?}")" \
    --args "{legacy_schema: ${legacy_schema}}")

echo "${generated_models}" |
	jq -r -c '.[]' |
	while read -r generated_model; do
		# Get generated features
		# shellcheck disable=SC2034
		name="$(echo "${generated_model}" | jq -r '.meta.name')"
		database="$(echo "${generated_model}" | jq -r '.meta.config.database')"
		database_alias="$(echo "${generated_model}" | jq -r '.meta.extra_meta.database_alias')"
		schema="$(echo "${generated_model}" | jq -r '.meta.config.schema')"
		alias="$(echo "${generated_model}" | jq -r '.meta.config.alias')"
		model_sql="$(echo "${generated_model}" | jq -r '.model_sql')"
		schema_yaml="$(echo "${generated_model}" | jq -r '.schema_yaml')"

		# Save a model
		model_path="${dbt_models_dir:?}/${database_alias:?}/${schema:?}/${alias:?}"
		model_file="${name}.sql"
		schema_file="schema.yml"
		echo "create ${model_path}"
		echo "create ${model_file}"
		mkdir -p "${model_path}"
		echo "${model_sql}" >"${model_path}/${model_file}"
		echo "${schema_yaml}" >"${model_path}/${schema_file}"
	done
