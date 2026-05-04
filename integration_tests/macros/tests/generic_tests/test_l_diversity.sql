{# Unit tests target l_diversity_test_query_sql (public SQL builder), not the generic test macro. #}
{% macro test_l_diversity_sql_fragments() %}
  {{- return(adapter.dispatch("test_l_diversity_sql_fragments", "dbt_data_privacy_integration_tests")()) -}}
{% endmacro %}

{% macro bigquery__test_l_diversity_sql_fragments() %}
  {%- set sql = dbt_data_privacy.l_diversity_test_query_sql(
      ref("example_l_diverse_release"),
      ["qi_a", "qi_b"],
      "sensitive",
      3,
      10
  ) -%}

  {% do assert_str_in_value("FROM", sql) %}
  {% do assert_str_in_value("GROUP BY", sql) %}
  {% do assert_str_in_value("COUNT(DISTINCT", sql) %}
  {% do assert_str_in_value("distinct_sensitive_count", sql) %}
  {% do assert_str_in_value("group_size", sql) %}
  {% do assert_str_in_value("WHERE distinct_sensitive_count < 3", sql) %}
  {% do assert_str_in_value("total_violating_groups", sql) %}
  {% do assert_str_in_value("QUALIFY", sql) %}
  {% do assert_str_in_value("ROW_NUMBER()", sql) %}
{% endmacro %}
