{% macro get_secured_columns(columns) %}
  {% set secured_columns = {} %}
  {%- set column_conditions = dbt_data_privacy.analyze_column_conditions(columns) %}

  {%- for column_name, column_info in columns.items() -%}
    {%- if "data_privacy" in column_info.meta and column_info.meta.data_privacy.level %}
      {% set expression = dbt_data_privacy.get_secured_expression_by_level(
          column_name, column_info.meta.data_privacy.level, column_conditions=column_conditions) %}
      {%- if expression is not none -%}
        {{ expression }} AS `{{- column_name -}}`,
        {% do %}
      {%- endif -%}
    {% else %}
      {{ exceptions.raise_compiler_error("column {} doesn't have any 'data_privacy' block.".format(column_name)) }}
    {%- endif -%}
  {%- endfor %}

  {% do return(secured_columns) %}
{% endmacro %}
