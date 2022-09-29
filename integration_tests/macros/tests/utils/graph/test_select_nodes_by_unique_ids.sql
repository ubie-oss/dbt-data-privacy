{% macro test_select_nodes_by_unique_ids() %}
  {% set nodes = dbt_data_privacy.get_nodes("model") | list %}
  {% set unique_ids = [
      "model.dbt_data_privacy_integration_tests.restricted_layer__dbt_data_privacy_restricted_layer__consents",
    ] %}
  {% set result = dbt_data_privacy.select_nodes_by_unique_ids(nodes, unique_ids=unique_ids) %}
  {{ assert_equals(result | length, 1) }}

  {% set unique_ids = [
      "model.dbt_data_privacy_integration_tests.restricted_layer__dbt_data_privacy_restricted_layer__items",
    ] %}
  {% set result = dbt_data_privacy.select_nodes_by_unique_ids(nodes, unique_ids=unique_ids) %}
  {{ assert_equals(result | length, 1) }}

  {% set unique_ids = [
      "model.dbt_data_privacy_integration_tests.restricted_layer__dbt_data_privacy_restricted_layer__items",
      "model.dbt_data_privacy_integration_tests.restricted_layer__dbt_data_privacy_restricted_layer__consents",
    ] %}
  {% set result = dbt_data_privacy.select_nodes_by_unique_ids(nodes, unique_ids=unique_ids) %}
  {{ assert_equals(result | length, 2) }}
{% endmacro %}
