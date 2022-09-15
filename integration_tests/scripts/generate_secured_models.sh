#!/bin/bash
set -e

# Constants
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Arguments
dbt_profiles_dir="${PROJECT_DIR}/profiles"
dbt_models_dir="${PROJECT_DIR}/models"
dbt_profile="default"
default_tag="dbt_data_privacy"
args=()
while (($# > 0))
do
  if [[ "$1" == "--models-dir" ]]; then
    dbt_models_dir="${2}"
    shift 2
  elif [[ "$1" == "--profiles-dir" ]]; then
    dbt_profiles_dir="${2}"
    shift 2
  elif [[ "$1" == "--profile" ]]; then
    dbt_profile="${2}"
    shift 2
  elif [[ "$1" == "--target" ]]; then
    dbt_target="${2}"
    shift 2
  elif [[ "$1" == "--vars-path" ]]; then
    vars_path="${2}"
    shift 2
  elif [[ "$1" == "--default-tag" ]]; then
    default_tag="${2}"
    shift 2
  else
    args+=("${1}")
    shift 1
  fi
done

#
# main
#
# Remove dbt models generated by data_privacy to remove disabled models.
generated_files="$(dbt --quiet ls --profiles-dir "${dbt_profiles_dir:?}" \
    --profile "${dbt_profile:?}" \
    --target "${dbt_target:?}" \
    --select "tag:${default_tag}" \
    --vars "$(cat "${vars_path:?}")" \
    --output path
)"
for generated_file in $generated_files:
do
  if [[ -e "$generated_file" ]] ; then
    rm -f "$generated_file"
    echo "delete ${generated_file}"
  fi
done

# Generate dbt models.
#dbt --quiet run-operation "dbt_data_privacy.generate_privacy_protected_models" \
#    --profiles-dir "$dbt_profiles_dir" \
#    --profile "$dbt_profile" \
#    --target "$dbt_target" \
#    --vars "$(cat "${vars_path}")"
generated_models="$(dbt --quiet run-operation "dbt_data_privacy.generate_privacy_protected_models" \
    --profiles-dir "${dbt_profiles_dir:?}" \
    --profile "${dbt_profile:?}" \
    --target "${dbt_target:?}" \
    --vars "$(cat "${vars_path:?}")")"
echo "$generated_models" \
  | jq -r -c '.[]' \
  | while read -r generated_model
    do
      # Get generated features
      # shellcheck disable=SC2034
      name="$(echo "$generated_model" | jq -r '.meta.name')"
      database="$(echo "$generated_model" | jq -r '.meta.config.database')"
      database_alias="$(echo "$generated_model" | jq -r '.meta.extra_meta.database_alias')"
      schema="$(echo "$generated_model" | jq -r '.meta.config.schema')"
      alias="$(echo "$generated_model" | jq -r '.meta.config.alias')"
      model_sql="$(echo "$generated_model" | jq -r '.model_sql')"
      schema_yaml="$(echo "$generated_model" | jq -r '.schema_yaml')"

      # Save a model
      model_path="${dbt_models_dir:?}/${database_alias:?}/${schema:?}/${alias:?}"
      model_file="${name}.sql"
      schema_file="schema.yml"
      echo "create ${model_path}"
      echo "create ${model_file}"
      mkdir -p "$model_path"
      echo "$model_sql" > "${model_path}/${model_file}"
      echo "$schema_yaml" > "${model_path}/${schema_file}"
    done
