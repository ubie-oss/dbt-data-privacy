{% macro split_column_elements(column_name) %}
  {{ return(column_name.split(".")) }}
{% endmacro %}
