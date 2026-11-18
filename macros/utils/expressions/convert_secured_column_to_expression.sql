{% macro convert_secured_column_to_expression(restructured_secured_column) %}
  {{ return(adapter.dispatch('convert_secured_column_to_expression', 'dbt_data_privacy')(restructured_secured_column)) }}
{% endmacro %}
{% macro bigquery__convert_secured_column_to_expression(restructured_secured_column) %}
  {% set structured_secured_expression = none %}

  {% if restructured_secured_column is mapping and "secured_expression" not in restructured_secured_column %}
    {%- set structured_secured_expression -%}
    STRUCT(
      {%- for sub_k, sub_v in dbt_data_privacy.mapping_items(restructured_secured_column) %}
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
