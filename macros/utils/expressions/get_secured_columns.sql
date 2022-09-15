{% macro get_secured_columns(data_handling_standards, columns) %}
  {% set secured_columns = {} %}
  {% set column_conditions = dbt_data_privacy.analyze_column_conditions(columns) %}

  {% for column_name, column_info in columns.items() %}
    {% if "data_privacy" in column_info.meta and column_info.meta.data_privacy.level %}
      {% set secured_expression = dbt_data_privacy.get_secured_expression_by_level(
          data_handling_standards,
          column_name,
          column_info.meta.data_privacy.level,
          column_conditions=column_conditions) %}

      {% set level = column_info.meta.data_privacy.level %}
      {% set method, with, converted_level = dbt_data_privacy.get_data_handling_standard_by_level(
          data_handling_standards,
          column_info.meta.data_privacy.level) %}
      {% if converted_level is not none %}
        {% set level = converted_level %}
      {% endif %}

      {% if secured_expression is not none %}
        {% do secured_columns.update({
          column_name: {
            "secured_expression": secured_expression,
            "level": level,
          }
        }) %}
      {% endif %}
    {% else %}
      {{ exceptions.warn("WARN: column {} doesn't have a 'data_privacy' meta.".format(column_name)) }}
    {% endif %}
  {% endfor %}

  {{ return(secured_columns) }}
{% endmacro %}
