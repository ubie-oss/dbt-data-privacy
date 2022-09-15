{% macro get_secured_secured_expression(data_handling_standards, expression, level) %}
  {%- set secured_expression = none -%}

  {#
  {% if level in data_handling_standards %}
    {% set secured_expression = dbt_data_privacy.get_secured_secured_expression_by_strategy(
        expression, data_handling_standards[level], data_handling_standards=data_handling_standards) %}
  {% else %}
    {{ exceptions.raise_compiler_error("No such level {} for column {} in {}".format(level, expression, data_handling_standards)) }}
  {% endif %}
  #}

  {% set secured_expression = dbt_data_privacy.get_secured_secured_expression_by_level(
      expression, level, data_handling_standards=data_handling_standards) %}

  {% do return(secured_expression) %}
{% endmacro %}
