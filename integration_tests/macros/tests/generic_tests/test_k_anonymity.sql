{# Unit tests target k_anonymity_test_query_sql (public SQL builder), not the generic test macro. #}
{% macro test_k_anonymity_sql_fragments() %}
  {{- return(adapter.dispatch("test_k_anonymity_sql_fragments", "dbt_data_privacy_integration_tests")()) -}}
{% endmacro %}

{% macro bigquery__test_k_anonymity_sql_fragments() %}
  {%- set sql = dbt_data_privacy.k_anonymity_test_query_sql(
      ref("example_k_anonymous_release"),
      ["qi_a", "qi_b"],
      5,
      10
  ) -%}

  {% do assert_str_in_value("FROM", sql) %}
  {% do assert_str_in_value("GROUP BY", sql) %}
  {% do assert_str_in_value("group_size", sql) %}
  {% do assert_str_in_value("WHERE group_size < 5", sql) %}
  {% do assert_str_in_value("total_violating_groups", sql) %}
  {% do assert_str_in_value("QUALIFY", sql) %}
  {% do assert_str_in_value("ROW_NUMBER()", sql) %}
{% endmacro %}
