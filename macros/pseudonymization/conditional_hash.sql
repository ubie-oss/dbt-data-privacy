{% macro conditional_hash(expression, with_params, column_conditions, data_type=none) -%}
  {# Validate inputs #}
  {% if with_params is none %}
    {{ exceptions.raise_compiler_error("'with_params' is none") }}
  {% elif column_conditions is none %}
    {{ exceptions.raise_compiler_error("'column_conditions' is none") }}
  {% elif 'default_method' not in with_params %}
    {{ exceptions.raise_compiler_error("'default_method' doesn't exist in {}".format(with_params)) }}
  {% elif 'condition' not in with_params %}
    {{ exceptions.raise_compiler_error("'condition' doesn't exist in {}".format(with_params)) }}
  {% elif with_params['condition'] not in column_conditions %}
    {{ exceptions.raise_compiler_error("No matched condition {} in column_conditions {}".format(with_params['condition'], column_conditions)) }}
  {% endif %}

  {{- return(adapter.dispatch('conditional_hash', 'dbt_data_privacy')(
      expression, with_params, column_conditions, data_type=data_type)) -}}
{%- endmacro %}

{%- macro bigquery__conditional_hash(expression, with_params, conditions, data_type=none) -%}
  {% if column_conditions[with_params['condition']] is true  %}
    {%- set secured_expression = dbt_data_privacy.get_secured_expression_by_method(expression, default_method, data_type=data_type) -%}
    {%- do return(secured_expression) -%}
  {% else %}
    {%- do return(expression) -%}
  {% endif %}
{%- endmacro -%}
