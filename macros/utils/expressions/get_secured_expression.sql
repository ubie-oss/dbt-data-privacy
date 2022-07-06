{% macro get_secured_expression(column_name, level, data_handling_standard=none) %}
  {%- set expression = none -%}

  {% if data_handling_standard is none %}
    {% set data_handling_standard = dbt_data_privacy.get_default_data_handling_standard() %}
  {% endif %}

  {#
  {% if level in data_handling_standard %}
    {% set expression = dbt_data_privacy.get_secured_expression_by_strategy(
        column_name, data_handling_standard[level], data_handling_standard=data_handling_standard) %}
  {% else %}
    {{ exceptions.raise_compiler_error("No such level {} for column {} in {}".format(level, column_name, data_handling_standard)) }}
  {% endif %}
  #}

  {% set expression = dbt_data_privacy.get_secured_expression_by_level(
      column_name, level, data_handling_standard=data_handling_standard) %}

  {% do return(expression) %}
{% endmacro %}
