{% macro get_secured_expression_by_level(data_handling_standards, column_name, level, column_conditions=none) %}
  {% set expression = "" %}

  {% if level not in data_handling_standards %}
    {{ exceptions.raise_compiler_error("No such data security level {} for column {} in {}".format(level, column_name, data_handling_standards)) }}
  {% endif %}

  {% set method, with, converted_level = dbt_data_privacy.get_data_handling_standard_by_level(data_handling_standards, level) %}
  {% set expression = dbt_data_privacy.get_secured_expression_by_method(column_name, method) %}

  {{ return(expression) }}
{% endmacro %}
