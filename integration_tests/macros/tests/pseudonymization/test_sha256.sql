{% macro test_sha256() %}
  {{- return(adapter.dispatch("test_sha256", "dbt_data_privacy_integration_tests")()) -}}
{% endmacro %}

{% macro bigquery__test_sha256() %}
  {%- set result = dbt_data_privacy.sha256("dummy_column") -%}
  {{ assert_equals(result, "SHA256(CAST(dummy_column AS STRING))") }}

  {%- set result = dbt_data_privacy.sha256("dummy_column", data_type="ARRAY") -%}
  {{ assert_equals(result, "ARRAY(SELECT SHA256(CAST(e AS STRING)) FROM UNNEST(dummy_column) AS e)") }}
{% endmacro %}
