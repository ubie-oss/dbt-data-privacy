{% macro sha256(expression) -%}
  {{- return(adapter.dispatch('sha256', 'dbt_data_privacy')(expression)) -}}
{%- endmacro %}

{%- macro bigquery__sha256(expression) -%}
  {%- set expression = "TO_BASE64(SHA256(CAST(" ~  expression ~ " AS STRING)))" -%}
  {%- do return(expression) -%}
{%- endmacro -%}
