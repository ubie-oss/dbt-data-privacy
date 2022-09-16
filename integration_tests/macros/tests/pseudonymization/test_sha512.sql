{% macro test_sha512() %}
  {{- return(adapter.dispatch("test_sha512", "dbt_data_privacy_integration_tests")()) -}}
{% endmacro %}

{% macro bigquery__test_sha512() %}
  {%- set result = dbt_data_privacy.sha512("dummy_column") -%}
  {{ assert_equals(result, "SHA512(CAST(dummy_column AS STRING))") }}

  {%- set result = dbt_data_privacy.sha512("dummy_column", data_type="ARRAY") -%}
  {{ assert_equals(result, "ARRAY(SELECT SHA512(CAST(e AS STRING)) FROM UNNEST(dummy_column) AS e)") }}
{% endmacro %}
