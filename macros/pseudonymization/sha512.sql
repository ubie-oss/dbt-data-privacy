{% macro sha512(column) -%}
  {{- return(adapter.dispatch('sha512', 'dbt_data_privacy')(column)) -}}
{%- endmacro %}

{%- macro bigquery__sha512(column) -%}
  {%- set expression = "TO_BASE64(SHA512(CAST(" ~  column ~ " AS STRING)))" -%}
  {%- do return(expression) -%}
{%- endmacro -%}
