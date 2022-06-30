{% macro sha256(column) -%}
  {{- return(adapter.dispatch('sha256', 'dbt_data_privacy')(column)) -}}
{%- endmacro %}

{%- macro bigquery__sha256(column) -%}
  {%- set expression = "TO_BASE64(SHA256(CAST(" ~  column ~ " AS STRING)))" -%}
  {%- do return(expression) -%}
{%- endmacro -%}
