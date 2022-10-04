{% macro get_secured_columns_v2(data_handling_standards, column_conditions, columns) %}
  {% set secured_restructured_columns = {} %}

  {% set restructured_columns = dbt_data_privacy.restructure_columns(columns) %}

  {% for top_level_column_name, top_level_restructure_column in restructured_columns.items() %}
    {% set hoge = dbt_data_privacy.get_secured_restructured_column(
      data_handling_standards=data_handling_standards,
      column_conditions=column_conditions,
      restructured_column=top_level_restructure_column,
      relative_path=[top_level_column_name],
      depth=0) %}

    {% do secured_restructured_columns.update({top_level_column_name: hoge}) %}
  {% endfor %}

  {{ return(secured_restructured_columns) }}
{% endmacro %}
