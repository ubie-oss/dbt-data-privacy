{% macro conditional_hash(column_conditions, expression, default_method, conditions, data_type=none) -%}
  {% if column_conditions is none or column_conditions is not mapping %}
    {% do exceptions.raise_compiler_error("Invalid column_conditions {}".format(column_conditions)) %}
  {% endif %}

  {% for condition in conditions %}
    {% if condition not in column_conditions %}
      {% do exceptions.raise_compiler_error("Invalid condition {} to {}".format(condition, column_conditions)) %}
    {% endif %}
  {% endfor %}

  {{- return(adapter.dispatch('conditional_hash', 'dbt_data_privacy')(
      column_conditions=column_conditions,
      expression=expression,
      default_method=default_method,
      conditions=conditions,
      data_type=data_type)) -}}
{%- endmacro %}

{% macro bigquery__conditional_hash(column_conditions, expression, default_method, conditions, data_type=none) -%}
  {#
    Raw output only when the list is non-empty and every listed condition is explicitly true.
    An empty list, or a value that is not a boolean, hashes with the default method.
  #}
  {% set ns = namespace(raw_allowed=(conditions | length > 0)) %}
  {% for condition in conditions %}
    {% if column_conditions.get(condition) is not sameas true %}
      {% set ns.raw_allowed = false %}
    {% endif %}
  {% endfor %}

  {% if ns.raw_allowed %}
    {%- do return(expression) -%}
  {% else %}
    {%- set secured_expression = dbt_data_privacy.get_secured_expression_by_method(expression, default_method, data_type=data_type) -%}
    {%- do return(secured_expression) -%}
  {% endif %}
{%- endmacro -%}
