{% macro column_conditions_for_column(column_conditions, column) %}
  {% if column_conditions is none %}
    {{ return(none) }}
  {% endif %}
  {% set resolved = dbt_data_privacy.deep_copy_dict(column_conditions) %}
  {% do resolved.update({"is_column_exposable": dbt_data_privacy.is_column_exposable(column)}) %}
  {{ return(resolved) }}
{% endmacro %}
