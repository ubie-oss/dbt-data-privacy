{% macro get_secured_secured_expression_by_column(column_dict, data_handling_standards) %}
  {% set secured_expression = none %}
  {% set is_secured = none %}

  {#
  {% if level in data_handling_standards %}
    {% set secured_expression = dbt_data_privacy.get_secured_secured_expression_by_method(
        expression, data_handling_standards[level], data_handling_standards=data_handling_standards) %}
  {% else %}
    {{ exceptions.raise_compiler_error("No such level {} for column {} in {}".format(level, expression, data_handling_standards)) }}
  {% endif %}
  #}

  {% set secured_expression = dbt_data_privacy.get_secured_secured_expression_by_level(
      expression, level, data_handling_standards=data_handling_standards) %}

  {% do return(secured_expression) %}
{% endmacro %}

{% macro get_level_in_column(column_dict) %}
  {% set level = none %}

  {% if 'data_privacy' in column_dict
      and 'level' in column_dict['data_privacy'] %}
    {% set level = column_dict['data_privacy']['level'] %}
  {% endif %}

  {% do return(level) %}
{% endmacro %}
