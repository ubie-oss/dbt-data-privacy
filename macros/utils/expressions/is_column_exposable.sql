{% macro is_column_exposable(column) %}
  {% set tagged_columns = dbt_data_privacy.get_columns_by_policy_tag({"column": column}, "column_exposable") %}
  {% if tagged_columns | length > 0 %}
    {% do return(true) %}
  {% endif %}
  {% do return(false) %}
{% endmacro %}

{% macro column_conditions_for_column(column_conditions, column) %}
  {% if column_conditions is none %}
    {{ return(none) }}
  {% endif %}
  {% set resolved = dbt_data_privacy.deep_copy_dict(column_conditions) %}
  {% do resolved.update({"is_column_exposable": dbt_data_privacy.is_column_exposable(column)}) %}
  {{ return(resolved) }}
{% endmacro %}
