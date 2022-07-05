{% macro test_extract_email_domain() %}
  {{- return(adapter.dispatch("test_extract_email_domain", "dbt_data_privacy_integration_tests")()) -}}
{% endmacro %}

{% macro bigquery__test_extract_email_domain() %}
  {%- set result = dbt_data_privacy.extract_email_domain("column_a") -%}
  {%- set expected = 'IF(column_a LIKE "%@%", SPLIT(column_a, "@")[OFFSET(0)], column_a)' -%}
  {{ assert_equals(result, expected) }}

  {%- set result = dbt_data_privacy.extract_email_domain('"test@example.com"') -%}
  {%- set expected = 'IF("test@example.com" LIKE "%@%", SPLIT("test@example.com", "@")[OFFSET(0)], "test@example.com")' -%}
  {{ assert_equals(result, expected) }}
{% endmacro %}
