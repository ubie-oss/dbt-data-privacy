{% macro udf_hash(expression, udf_function, data_type=none) -%}
  {% if udf_function is not defined or udf_function is none %}
    {% do exceptions.raise_compiler_error("udf_function is not defined") %}
  {% endif %}

  {{- return(adapter.dispatch('udf_hash', 'dbt_data_privacy')(expression, udf_function=udf_function, data_type=data_type)) -}}
{%- endmacro %}

{%- macro bigquery__udf_hash(expression, udf_function, data_type=none) -%}
  {% set secured_expression = "{}(CAST({} AS STRING))".format(udf_function, expression)%}

  {% if data_type | upper == "ARRAY" %}
    {% set secured_expression = "ARRAY(SELECT {}(CAST(e AS STRING)) FROM UNNEST({}) AS e)".format(udf_function, expression)%}
  {% endif %}

  {%- do return(secured_expression) -%}
{%- endmacro -%}
