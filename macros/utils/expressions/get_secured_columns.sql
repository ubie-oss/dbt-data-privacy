{% macro get_secured_columns(data_handling_standards, columns) %}
  {% set secured_columns = {} %}
  {%- set column_conditions = dbt_data_privacy.analyze_column_conditions(columns) %}

  {%- for column_name, column_info in columns.items() -%}
    {%- if "data_privacy" in column_info.meta and column_info.meta.data_privacy.level %}
      {% set expression = dbt_data_privacy.get_secured_expression_by_level(
          data_handling_standards,
          column_name,
          column_info.meta.data_privacy.level,
          column_conditions=column_conditions) %}
      {%- if expression is not none -%}
        {% do secured_columns.update({
          column_name: {
            "secured_expression": expression,
          }
        }) %}
      {%- endif -%}
    {% else %}
      {{ exceptions.warn("column {} doesn't have any 'data_privacy' block.".format(column_name)) }}
    {%- endif -%}
  {%- endfor %}

  {% do return(secured_columns) %}
{% endmacro %}
