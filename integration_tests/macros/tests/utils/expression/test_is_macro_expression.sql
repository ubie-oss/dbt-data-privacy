{% macro test_is_macro_expression() %}
  {{ assert_true(dbt_data_privacy.is_macro_expression("var('test')")) }}
  {{ assert_true(dbt_data_privacy.is_macro_expression("ref('test_model')")) }}
  {{ assert_true(dbt_data_privacy.is_macro_expression("source('test_schema', 'test_source')")) }}
  {{ assert_false(dbt_data_privacy.is_macro_expression("literal")) }}
{% endmacro %}
