{% macro conditional_hash(column_conditions, expression, default_method, condition, data_type=none) -%}
  {% if condition not in column_conditions %}
    {% do exceptions.raise_compiler_error("Invalid condition {} to {}".format(condition, column_conditions)) %}
  {% endif %}

  {{- return(adapter.dispatch('conditional_hash', 'dbt_data_privacy')(
      column_conditions=column_conditions,
      expression=expression,
      default_method=default_method,
      condition=condition,
      data_type=data_type)) -}}
{%- endmacro %}

{% macro bigquery__conditional_hash(column_conditions, expression, default_method, condition, data_type=none) -%}
  {% if column_conditions.get(condition, false) is sameas true  %}
    {%- set secured_expression = dbt_data_privacy.get_secured_expression_by_method(expression, default_method, data_type=data_type) -%}
    {%- do return(secured_expression) -%}
  {% else %}
    {%- do return(expression) -%}
  {% endif %}
{%- endmacro -%}
