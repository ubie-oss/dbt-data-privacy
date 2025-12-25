{% macro get_secured_columns_v2(data_handling_standards, columns) %}
  {% set secured_restructured_columns = {} %}

  {% set column_conditions = dbt_data_privacy.analyze_column_conditions(data_handling_standards, columns) %}

  {% set restructured_columns = dbt_data_privacy.restructure_columns(columns) %}
  {# Iterate over keys to avoid collision with column named "items" #}
  {% for top_level_column_name in restructured_columns %}
    {% set top_level_restructure_column = restructured_columns[top_level_column_name] %}
    {% set secured_top_level_restructure_column = dbt_data_privacy.get_secured_restructured_column(
      data_handling_standards=data_handling_standards,
      column_conditions=column_conditions,
      restructured_column=top_level_restructure_column,
      relative_path=[top_level_column_name],
      depth=0) %}

    {% do secured_restructured_columns.update({top_level_column_name: secured_top_level_restructure_column}) %}
  {% endfor %}

  {{ return(secured_restructured_columns) }}
{% endmacro %}
