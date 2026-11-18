{% macro is_column_exposable(column) %}
  {% set tagged_columns = dbt_data_privacy.get_columns_by_policy_tag({"column": column}, "column_exposable") %}
  {% if tagged_columns | length > 0 %}
    {% do return(true) %}
  {% endif %}
  {% do return(false) %}
{% endmacro %}
