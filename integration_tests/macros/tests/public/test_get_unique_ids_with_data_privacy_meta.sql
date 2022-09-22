{% macro test_get_unique_ids_with_data_privacy_meta() %}
  {{- return(adapter.dispatch("test_get_unique_ids_with_data_privacy_meta", "dbt_data_privacy_integration_tests")()) -}}
{% endmacro %}

{% macro bigquery__test_get_unique_ids_with_data_privacy_meta() %}
  {% set unique_ids = dbt_data_privacy.get_unique_ids_with_data_privacy_meta(verbose=false) | sort %}
  {{ assert_equals(unique_ids | length, 4) }}
  {{ assert_equals(unique_ids[0],
      "model.dbt_data_privacy_integration_tests.restricted_layer__dbt_data_privacy_restricted_layer__consents") }}
  {{ assert_equals(unique_ids[1],
      "model.dbt_data_privacy_integration_tests.restricted_layer__dbt_data_privacy_restricted_layer__items") }}
  {{ assert_equals(unique_ids[2],
      "model.dbt_data_privacy_integration_tests.restricted_layer__dbt_data_privacy_restricted_layer__orders") }}
  {{ assert_equals(unique_ids[3],
      "model.dbt_data_privacy_integration_tests.restricted_layer__dbt_data_privacy_restricted_layer__users") }}

  {% set target_unique_ids = [
      "model.dbt_data_privacy_integration_tests.restricted_layer__dbt_data_privacy_restricted_layer__consents",
      "model.dbt_data_privacy_integration_tests.restricted_layer__dbt_data_privacy_restricted_layer__items",
  ] %}
  {% set unique_ids = dbt_data_privacy.get_unique_ids_with_data_privacy_meta(unique_ids=target_unique_ids, verbose=false) | sort %}
  {{ assert_equals(unique_ids | length, 2) }}
  {{ assert_equals(unique_ids[0],
      "model.dbt_data_privacy_integration_tests.restricted_layer__dbt_data_privacy_restricted_layer__consents") }}
  {{ assert_equals(unique_ids[1],
      "model.dbt_data_privacy_integration_tests.restricted_layer__dbt_data_privacy_restricted_layer__items") }}
{% endmacro %}
