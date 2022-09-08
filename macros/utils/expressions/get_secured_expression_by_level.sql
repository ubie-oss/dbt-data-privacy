{% macro get_secured_expression_by_level(column_name, level, column_conditions=none) %}
  {% set expression = "" %}
  {% set data_handling_standard = dbt_data_privacy.get_data_handling_standard() %}

  {% if level in data_handling_standard %}
    {% set method, with, converted_level = dbt_data_privacy.get_data_handling_standard_definition(data_handling_standard, level) %}
    {% set expression = dbt_data_privacy.get_secured_expression_by_method(column_name, method) %}
  {% else %}
    {{ exceptions.raise_compiler_error("No such data security level {} for column {} in {}".format(level, column_name, data_handling_standard)) }}
  {% endif %}

  {% do return(expression) %}
{% endmacro %}
