{% macro test_get_secured_expression_by_level() %}
  {{- return(adapter.dispatch("test_get_secured_expression_by_level", "dbt_data_privacy_integration_tests")()) -}}
{% endmacro %}

{% macro bigquery__test_get_secured_expression_by_level() %}
  {% set data_handling_standards = get_test_data_handling_standards() %}

  {%- set result = dbt_data_privacy.get_secured_expression_by_level(data_handling_standards, "column1", "public", data_type=none) -%}
  {%- set expected = 'column1' -%}
  {{ assert_equals(result, expected) }}

  {%- set result = dbt_data_privacy.get_secured_expression_by_level(data_handling_standards, "column1", "internal", data_type=none) -%}
  {%- set expected = 'column1' -%}
  {{ assert_equals(result, expected) }}

  {%- set result = dbt_data_privacy.get_secured_expression_by_level(data_handling_standards, "column1", "confidential", data_type=none) -%}
  {%- set expected = 'SHA256(CAST(column1 AS STRING))' -%}
  {{ assert_equals(result, expected) }}

  {%- set result = dbt_data_privacy.get_secured_expression_by_level(data_handling_standards, "column1", "restricted", data_type=none) -%}
  {%- set expected = none -%}
  {{ assert_equals(result, expected) }}
{% endmacro %}
