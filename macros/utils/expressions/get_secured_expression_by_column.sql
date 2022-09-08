{% macro get_secured_secured_expression_by_column(column_dict, data_handling_standard) %}
  {% set secured_expression = none %}
  {% set is_secured = none %}

  {#
  {% if level in data_handling_standard %}
    {% set secured_expression = dbt_data_privacy.get_secured_secured_expression_by_method(
        expression, data_handling_standard[level], data_handling_standard=data_handling_standard) %}
  {% else %}
    {{ exceptions.raise_compiler_error("No such level {} for column {} in {}".format(level, expression, data_handling_standard)) }}
  {% endif %}
  #}

  {% set secured_expression = dbt_data_privacy.get_secured_secured_expression_by_level(
      expression, level, data_handling_standard=data_handling_standard) %}

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
