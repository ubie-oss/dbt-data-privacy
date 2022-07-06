{% macro get_secured_expression_by_level(
    column_name, level, data_handling_standard=none) %}
  {% set expression = "" %}

  {% if data_handling_standard is none %}
    {% set data_handling_standard = dbt_data_privacy.get_data_handling_standard() %}
  {% endif %}

  {% if level in data_handling_standard %}
    {% set expression = dbt_data_privacy.get_secured_expression_by_standard(
        column_name, data_handling_standard[level]) %}
  {% else %}
    {{ exceptions.raise_compiler_error("No such data security level {} for column {} in {}".format(level, column_name, data_handling_standard)) }}
  {% endif %}

  {% do return(expression) %}
{% endmacro %}
