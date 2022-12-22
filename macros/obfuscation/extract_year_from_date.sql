{% macro extract_year_from_date(expression) -%}
  {{- return(adapter.dispatch('extract_year_from_date', 'dbt_data_privacy')(expression)) -}}
{%- endmacro %}

{% macro bigquery__extract_year_from_date(expression) -%}
  {% set converted_expression = "EXTRACT(YEAR FROM SAFE_CAST({} AS DATE))".format(expression) %}
  {%- do return(converted_expression) -%}
{%- endmacro -%}
