{% macro get_column_data_type(column_info) %}
  {% if column_info.data_type is defined %}
    {{ return(column_info.data_type) }}
  {% endif %}

  {{ return(none) }}
{% endmacro %}
