{% macro test_udf_hash() %}
  {{- return(adapter.dispatch("test_udf_hash", "dbt_data_privacy_integration_tests")()) -}}
{% endmacro %}

{% macro bigquery__test_udf_hash() %}
  {%- set result = dbt_data_privacy.udf_hash("dummy_column", udf_function="MY_UDF") -%}
  {{ assert_equals(result, "MY_UDF(CAST(dummy_column AS STRING))") }}

  {%- set result = dbt_data_privacy.udf_hash("dummy_column", udf_function="MY_UDF", data_type="ARRAY") -%}
  {{ assert_equals(result, "ARRAY(SELECT MY_UDF(CAST(e AS STRING)) FROM UNNEST(dummy_column) AS e)") }}
{% endmacro %}
