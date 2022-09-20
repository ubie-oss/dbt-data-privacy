#!/bin/bash
set -x

# Arguments
dbt_profile="default"
default_tag="dbt_data_privacy"
delete_before="1"
verbose="1"
while (($# > 0))
do
  if [[ "$1" == "--dbt-models-dir" ]]; then
    dbt_models_dir="${2}"
    shift 2
  elif [[ "$1" == "--dbt-profiles-dir" ]]; then
    dbt_profiles_dir="${2}"
    shift 2
  elif [[ "$1" == "--dbt-profile" ]]; then
    dbt_profile="${2}"
    shift 2
  elif [[ "$1" == "--dbt-target" ]]; then
    dbt_target="${2}"
    shift 2
  elif [[ "$1" == "--dbt-vars-path" ]]; then
    dbt_vars_path="${2}"
    shift 2
  elif [[ "$1" == "--dbt-data-privacy-tag" ]]; then
    default_tag="${2}"
    shift 2
  elif [[ "$1" == "--delete-before" ]]; then
    delete_before="${2}"
    shift 2
  elif [[ "$1" == "--verbose" ]]; then
    verbose="${2}"
    shift 2
  fi
done

# Turn off verbose
if [[ "$verbose" != "1" ]] ; then
  set +x
fi

#
# main
#
# Fail fast on errors, unset variables, and failures in piped commands
set -Eeuo pipefail

#if [[ -n "${dbt_vars_path+x}" ]]; then
#  dbt_vars="$(cat "${dbt_vars_path:?}")"
#fi

# Remove dbt models generated by data_privacy to remove disabled models.
echo '::group::Delete dbt models generated by dbt-data-privacy ahead of time'
set +Eeuo pipefail

if [[ "$delete_before" == "1" ]] ; then
  dbt_ls_options=()
  if [[ -n "${dbt_profiles_dir+x}" ]]; then dbt_ls_options+=("--profiles-dir" "${dbt_profiles_dir:?}"); fi
  if [[ -n "${dbt_profile+x}" ]]; then dbt_ls_options+=("--profile" "${dbt_profile:?}"); fi
  if [[ -n "${dbt_target+x}" ]]; then dbt_ls_options+=("--target" "${dbt_target:?}"); fi
  if [[ -n "${dbt_vars_path+x}" ]]; then dbt_ls_options+=("--vars" "$(cat "${dbt_vars_path:?}")"); fi
  # shellcheck disable=SC2046
  deleted_files="$(dbt --quiet ls \
      --select "\"tag:${default_tag:?}\"" \
      --output path \
      "${dbt_ls_options[@]}")"
  for deleted_file in $deleted_files
  do
    if [[ -e "$deleted_file" ]] ; then
      rm -f "$deleted_file"
      echo "delete ${deleted_file}"
    fi
  done
fi

set -Eeuo pipefail
echo '::endgroup::'

# Generate dbt models.
echo '::group::Generate dbt models with dbt-data-privacy'
set +Eeuo pipefail

# Get information about generated models
dbt_run_operation_options=()
if [[ -n "${dbt_profiles_dir+x}" ]]; then dbt_run_operation_options+=("--profiles-dir" "${dbt_profiles_dir:?}"); fi
if [[ -n "${dbt_profile+x}" ]]; then dbt_run_operation_options+=("--profile" "${dbt_profile:?}"); fi
if [[ -n "${dbt_target+x}" ]]; then dbt_run_operation_options+=("--target" "${dbt_target:?}"); fi
if [[ -n "${dbt_vars_path+x}" ]]; then dbt_run_operation_options+=("--vars" "$(cat "${dbt_vars_path:?}")"); fi
# shellcheck disable=SC2046
generated_models_json="$(dbt --quiet run-operation "dbt_data_privacy.generate_privacy_protected_models" \
    "${dbt_run_operation_options[@]}")"
echo "::set-output name=generated-models-json::${generated_models_json}"

# Generate models
generated="0"
# shellcheck disable=SC2034
echo "$generated_models_json" \
  | jq -r -c '.[]' \
  | while read -r generated_model
    do
      # Get generated features
      name="$(echo "$generated_model" | jq -r '.meta.name')"
      database="$(echo "$generated_model" | jq -r '.meta.config.database')"
      database_alias="$(echo "$generated_model" | jq -r '.meta.extra_meta.database_alias')"
      schema="$(echo "$generated_model" | jq -r '.meta.config.schema')"
      alias="$(echo "$generated_model" | jq -r '.meta.config.alias')"
      model_sql="$(echo "$generated_model" | jq -r '.model_sql')"
      schema_yaml="$(echo "$generated_model" | jq -r '.schema_yaml')"

      # Save a model
      model_path="${dbt_models_dir:?}/${database_alias:?}/${schema:?}/${alias:?}"
      model_file="${name:?}.sql"
      schema_file="schema.yml"
      mkdir -p "$model_path"
      echo "${model_sql:?}" > "${model_path}/${model_file}"
      echo "${schema_yaml:?}" > "${model_path}/${schema_file}"
      echo "create ${model_path}/${model_file}"
      echo "create ${model_path}/${schema_file}"

      # Set the flag
      generated="1"
    done

echo "::set-output name=generated::${generated}"

set -Eeuo pipefail
echo '::endgroup::'
