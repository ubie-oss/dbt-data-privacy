{% macro test_macros() %}
  {{- return(adapter.dispatch("test_macros", "dbt_data_privacy_integration_tests")()) -}}
{% endmacro %}

{% macro bigquery__test_macros() %}
  {#
    utils
  #}
  {% do test_get_data_privacy_configs() %}
  {% do test_get_data_privacy_targets() %}
  {% do test_get_data_privacy_config_by_target() %}
  {% do test_get_secured_expression_by_method() %}
  {% do test_get_secured_expression_by_level() %}
  {% do test_get_secured_columns() %}
  {% do test_is_macro_expression() %}
  {% do test_get_nodes() %}
  {% do test_create_deep_dict() %}
  {% do test_deep_merge_dicts() %}
  {% do test_restructure_secured_columns() %}

  {#
    pseudonymization
  #}
  {% do test_sha256() %}
  {% do test_sha512() %}
  {% do test_extract_email_domain() %}
  {% do test_get_secured_expression_by_method() %}

  {#
    codegen
  #}
  {% do test_format_model_config() %}
  {% do test_generate_secured_model_schema_v2() %}
  {% do test_generate_privacy_protected_model_sql() %}

  {#
    public
  #}
  {% do test_generate_privacy_protected_models() %}
  {% do test_get_unique_ids_with_data_privacy_meta() %}


{% endmacro %}
