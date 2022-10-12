{% macro test_get_secured_expression_by_method() %}
  {{- return(adapter.dispatch("test_get_secured_expression_by_method", "dbt_data_privacy_integration_tests")()) -}}
{% endmacro %}

{% macro bigquery__test_get_secured_expression_by_method() %}
  {%- set result = dbt_data_privacy.get_secured_expression_by_method("column_a", "RAW") -%}
  {%- set expected = 'column_a' -%}
  {{ assert_equals(result, expected) }}
  {%- set result = dbt_data_privacy.get_secured_expression_by_method("column_a", "raw") -%}
  {%- set expected = 'column_a' -%}
  {{ assert_equals(result, expected) }}

  {%- set result = dbt_data_privacy.get_secured_expression_by_method("column_a", "SHA256") -%}
  {%- set expected = 'SHA256(CAST(column_a AS STRING))' -%}
  {{ assert_equals(result, expected) }}
  {%- set result = dbt_data_privacy.get_secured_expression_by_method("column_a", "SHA256", data_type="ARRAY") -%}
  {%- set expected = 'ARRAY(SELECT SHA256(CAST(e AS STRING)) FROM UNNEST(column_a) AS e)' -%}
  {{ assert_equals(result, expected) }}

  {%- set result = dbt_data_privacy.get_secured_expression_by_method("column_a", "SHA512") -%}
  {%- set expected = 'SHA512(CAST(column_a AS STRING))' -%}
  {{ assert_equals(result, expected) }}
  {%- set result = dbt_data_privacy.get_secured_expression_by_method("column_a", "SHA512", data_type="ARRAY") -%}
  {%- set expected = 'ARRAY(SELECT SHA512(CAST(e AS STRING)) FROM UNNEST(column_a) AS e)' -%}
  {{ assert_equals(result, expected) }}

  {%- set result = dbt_data_privacy.get_secured_expression_by_method("column_a", "DROPPED") -%}
  {%- set expected = None -%}
  {{ assert_equals(result, expected) }}
{% endmacro %}
