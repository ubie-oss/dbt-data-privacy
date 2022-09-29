{% macro test_get_tags_by_original_file_paths() %}
  {% set target_original_file_paths = [
      "models/restricted_layer/dbt_data_privacy_restricted_layer/consents/restricted_layer__dbt_data_privacy_restricted_layer__consents.sql",
  ] %}
  {% set result = dbt_data_privacy.get_tags_by_original_file_paths(original_file_paths=target_original_file_paths, verbose=false) %}
  {{ assert_equals(result, ['tag_in_consents']) }}

  {% set target_original_file_paths = [
      "models/restricted_layer/dbt_data_privacy_restricted_layer/users/restricted_layer__dbt_data_privacy_restricted_layer__users.sql",
  ] %}
  {% set result = dbt_data_privacy.get_tags_by_original_file_paths(original_file_paths=target_original_file_paths, verbose=false) %}
  {{ assert_equals(result, ['tag_in_users']) }}

  {% set target_original_file_paths = [
      "models/restricted_layer/dbt_data_privacy_restricted_layer/consents/restricted_layer__dbt_data_privacy_restricted_layer__consents.sql",
      "models/restricted_layer/dbt_data_privacy_restricted_layer/users/restricted_layer__dbt_data_privacy_restricted_layer__users.sql",
  ] %}
  {% set result = dbt_data_privacy.get_tags_by_original_file_paths(original_file_paths=target_original_file_paths, verbose=false) %}
  {{ assert_equals(result, ['tag_in_consents', 'tag_in_users']) }}

  {% set target_original_file_paths = [
      "models/restricted_layer/dbt_data_privacy_restricted_layer/consents/restricted_layer__dbt_data_privacy_restricted_layer__consents.sql",
      "models/restricted_layer/dbt_data_privacy_restricted_layer/users/restricted_layer__dbt_data_privacy_restricted_layer__users.sql",
  ] %}
  {% set result = dbt_data_privacy.get_tags_by_original_file_paths(
        original_file_paths=target_original_file_paths, has_data_privacy_meta=true, verbose=false) %}
  {{ assert_equals(result, ['tag_in_consents', 'tag_in_users']) }}
{% endmacro %}
