{% macro test_macros() %}
  {{- return(adapter.dispatch("test_macros", "dbt_data_privacy_integration_tests")()) -}}
{% endmacro %}

{% macro bigquery__test_macros() %}
  {#
    utils
  #}
  {% do test_is_macro_expression() %}
  {% do test_get_nodes() %}
  {% do test_get_system_config() %}

  {#
    pseudonymization
  #}
  {% do test_sha256() %}
  {% do test_sha512() %}
  {% do test_extract_email_domain() %}

  {#
    codegen
  #}
  {% do test_format_model_config() %}
  {% do test_generate_secured_model_schema_v2() %}
  {% do test_generate_privacy_protected_model_sql() %}
  {% do test_generate_privacy_protected_models() %}


{% endmacro %}
