{% macro get_secured_secured_expression(expression, level) %}
  {%- set secured_expression = none -%}
  {%- set data_handling_standard = get_data_handling_standard() -%}

  {#
  {% if level in data_handling_standard %}
    {% set secured_expression = dbt_data_privacy.get_secured_secured_expression_by_strategy(
        expression, data_handling_standard[level], data_handling_standard=data_handling_standard) %}
  {% else %}
    {{ exceptions.raise_compiler_error("No such level {} for column {} in {}".format(level, expression, data_handling_standard)) }}
  {% endif %}
  #}

  {% set secured_expression = dbt_data_privacy.get_secured_secured_expression_by_level(
      expression, level, data_handling_standard=data_handling_standard) %}

  {% do return(secured_expression) %}
{% endmacro %}
