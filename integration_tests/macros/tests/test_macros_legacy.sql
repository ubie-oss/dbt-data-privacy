{% macro test_macros_legacy() %}
  {{- return(adapter.dispatch("test_macros_legacy", "dbt_data_privacy_integration_tests")()) -}}
{% endmacro %}

{% macro bigquery__test_macros_legacy() %}

  {#
    utils
  #}
  {% do test_contains_pseudonymized_unique_identifiers_legacy() %}
  {% do test_restructure_columns_legacy() %}
  {% do test_get_secured_restructured_column_legacy() %}
  {% do test_get_secured_columns_v2_legacy() %}
  {% do test_convert_restructured_column_to_expression_legacy() %}
  {% do test_flatten_restructured_column_for_schema_legacy() %}
  {% do test_flatten_restructured_columns_for_schema_legacy() %}
  {% do test_get_columns_by_policy_tag_legacy() %}
  {% do test_convert_to_nested_dict_legacy() %}

  {#
    pseudonymization
  #}
  {% do test_get_secured_columns_legacy() %}

  {#
    codegen
  #}
  {% do test_generate_secured_model_schema_v2_legacy() %}

{% endmacro %}
