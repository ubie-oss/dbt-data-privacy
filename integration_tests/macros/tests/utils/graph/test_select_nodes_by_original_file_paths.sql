{% macro test_select_nodes_by_original_file_paths() %}
  {% set nodes = dbt_data_privacy.get_nodes("model") | list %}
  {% set original_file_paths = [
      "models/restricted_layer/dbt_data_privacy_restricted_layer/consents/restricted_layer__dbt_data_privacy_restricted_layer__consents.sql",
    ] %}
  {% set result = dbt_data_privacy.select_nodes_by_original_file_paths(nodes, original_file_paths=original_file_paths) %}
  {{ assert_equals(result | length, 1) }}

  {% set original_file_paths = [
      "models/restricted_layer/dbt_data_privacy_restricted_layer/users/restricted_layer__dbt_data_privacy_restricted_layer__users.sql",
    ] %}
  {% set result = dbt_data_privacy.select_nodes_by_original_file_paths(nodes, original_file_paths=original_file_paths) %}
  {{ assert_equals(result | length, 1) }}

  {% set original_file_paths = [
      "models/restricted_layer/dbt_data_privacy_restricted_layer/consents/restricted_layer__dbt_data_privacy_restricted_layer__consents.sql",
      "models/restricted_layer/dbt_data_privacy_restricted_layer/users/restricted_layer__dbt_data_privacy_restricted_layer__users.sql",
    ] %}
  {% set result = dbt_data_privacy.select_nodes_by_original_file_paths(nodes, original_file_paths=original_file_paths) %}
  {{ assert_equals(result | length, 2) }}
{% endmacro %}
