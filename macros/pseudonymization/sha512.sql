{% macro sha512(expression) -%}
  {{- return(adapter.dispatch('sha512', 'dbt_data_privacy')(expression)) -}}
{%- endmacro %}

{%- macro bigquery__sha512(expression) -%}
  {%- set secured_expression = "SHA512(CAST(" ~  expression ~ " AS STRING))" -%}
  {%- do return(secured_expression) -%}
{%- endmacro -%}
