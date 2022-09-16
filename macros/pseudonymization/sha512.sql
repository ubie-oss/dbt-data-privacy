{% macro sha512(expression, data_type=none) -%}
  {{- return(adapter.dispatch('sha512', 'dbt_data_privacy')(expression, data_type=data_type)) -}}
{%- endmacro %}

{%- macro bigquery__sha512(expression, data_type=none) -%}
  {% set secured_expression = "SHA512(CAST({} AS STRING))".format(expression)%}

  {% if data_type | upper == "ARRAY" %}
    {% set secured_expression = "ARRAY(SELECT SHA512(CAST(e AS STRING)) FROM UNNEST({}) AS e)".format(expression)%}
  {% endif %}

  {%- do return(secured_expression) -%}
{%- endmacro -%}
