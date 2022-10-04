{% macro test_macros() %}
  {{- return(adapter.dispatch("test_macros", "dbt_data_privacy_integration_tests")()) -}}
{% endmacro %}

{% macro bigquery__test_macros() %}
  {#
    utils
  #}
  {% do test_get_data_privacy_configs() %}
  {% do test_get_data_privacy_objectives() %}
  {% do test_get_data_privacy_config_by_objective() %}
  {% do test_get_secured_expression_by_method() %}
  {% do test_get_secured_expression_by_level() %}
  {% do test_get_secured_columns() %}
  {% do test_is_macro_expression() %}
  {% do test_get_nodes() %}
  {% do test_create_deep_dict() %}
  {% do test_convert_to_nested_dict() %}
  {% do test_restructure_columns() %}
  {% do test_get_secured_restructured_column() %}
  {% do test_get_secured_columns_v2() %}
  {% do test_deep_merge_dicts() %}
  {% do test_restructure_secured_columns() %}
  {% do test_get_columns_by_policy_tag() %}
  {% do test_contains_pseudonymized_unique_identifiers() %}

  {# graph #}
  {% do test_select_nodes_by_unique_ids() %}
  {% do test_select_nodes_by_original_file_paths() %}
  {% do test_select_nodes_by_tags() %}

  {#
    pseudonymization
  #}
  {% do test_sha256() %}
  {% do test_sha512() %}
  {% do test_udf_hash() %}
  {% do test_extract_email_domain() %}
  {% do test_get_secured_expression_by_method() %}
  {% do test_conditional_hash() %}

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
  {% do test_get_tags_by_original_file_paths() %}

{% endmacro %}
