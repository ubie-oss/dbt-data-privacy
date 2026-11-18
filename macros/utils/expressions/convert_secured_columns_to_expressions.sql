{% macro convert_secured_columns_to_expressions(restructured_secured_columns) %}
  {% if restructured_secured_columns is not mapping %}
    {{ exceptions.raise_compiler_error("{} isn't a dict".format(restructured_secured_columns)) }}
  {% endif %}

  {% set restructured_secured_expressions = {} %}
  {% for k, v in dbt_data_privacy.mapping_items(restructured_secured_columns) %}
    {% do restructured_secured_expressions.update({k: dbt_data_privacy.convert_secured_column_to_expression(v)}) %}
  {% endfor %}

  {{ return(restructured_secured_expressions) }}
{% endmacro %}
