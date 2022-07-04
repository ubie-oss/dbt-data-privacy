{% macro test_macros() %}
  {{- return(adapter.dispatch("test_macros", "dbt_data_privacy_integration_tests")()) -}}
{% endmacro %}

{% macro bigquery__test_macros() %}

  {#
    codegen
  #}
  {% do test_generate_privacy_protected_model_sql() %}
  {% do test_extract_model_configurations() %}

  {#
    pseudonymization
  #}
  {% do test_sha256() %}
  {% do test_sha512() %}

  {#
    utils
  #}
  {% do test_get_nodes() %}
  {% do test_get_system_config() %}

{% endmacro %}
