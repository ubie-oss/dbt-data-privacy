{% macro test_get_column_meta_block() %}
  {{- return(adapter.dispatch("test_get_column_meta_block", "dbt_data_privacy_integration_tests")()) -}}
{% endmacro %}

{% macro default__test_get_column_meta_block() %}
  {# Test for dbt 1.10 or later #}
  {% set column_1_10 = {
    "config": {
      "meta": {"data_privacy": {"level": "confidential"}}
    }
  } %}
  {% set result_1_10 = dbt_data_privacy.get_column_meta_block(column_1_10) %}
  {% set expected_1_10 = {"data_privacy": {"level": "confidential"}} %}
  {{ assert_equals(result_1_10, expected_1_10) }}

  {# Test for dbt 1.9 or earlier #}
  {% set column_1_9 = {
    "meta": {"data_privacy": {"level": "internal"}}
  } %}
  {% set result_1_9 = dbt_data_privacy.get_column_meta_block(column_1_9) %}
  {% set expected_1_9 = {"data_privacy": {"level": "internal"}} %}
  {{ assert_equals(result_1_9, expected_1_9) }}

  {# Test when no meta is defined #}
  {% set column_no_meta = {} %}
  {% set result_no_meta = dbt_data_privacy.get_column_meta_block(column_no_meta) %}
  {% set expected_no_meta = none %}
  {{ assert_equals(result_no_meta, expected_no_meta) }}
{% endmacro %}
