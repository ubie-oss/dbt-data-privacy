{% macro convert_secured_columns_to_expressions(restructured_secured_columns) %}
  {% if restructured_secured_columns is not mapping %}
    {{ exceptions.raise_compiler_error("{} isn't a dict".format(restructured_secured_columns)) }}
  {% endif %}

  {% set restructured_secured_expressions = {} %}
  {% for k, v in restructured_secured_columns.items() %}
    {% do restructured_secured_expressions.update({k: dbt_data_privacy.convert_secured_column_to_expression(v)}) %}
  {% endfor %}

  {{ return(restructured_secured_expressions) }}
{% endmacro %}

{% macro convert_secured_column_to_expression(restructured_secured_column) %}
  {{ return(adapter.dispatch('convert_secured_column_to_expression', 'dbt_data_privacy')(restructured_secured_column)) }}
{% endmacro %}

{% macro bigquery__convert_secured_column_to_expression(restructured_secured_column) %}
  {% set structured_secured_expression = none %}

  {% if restructured_secured_column is mapping and "secured_expression" not in restructured_secured_column %}
    {%- set structured_secured_expression -%}
    STRUCT(
      {%- for sub_k, sub_v in restructured_secured_column.items() %}
      {{ dbt_data_privacy.convert_secured_column_to_expression(sub_v) }} AS `{{- sub_k -}}`{%- if not loop.last %},{%- endif %}
      {%- endfor %}
    )
    {%- endset %}
  {% elif restructured_secured_column is mapping and "secured_expression" in restructured_secured_column %}
    {% set structured_secured_expression = restructured_secured_column.get("secured_expression") %}
  {% else %}
    {{ exceptions.raise_compiler_error("unexpected value {}".format(restructured_secured_column)) }}
  {% endif %}

  {{ return(structured_secured_expression) }}
{% endmacro %}
