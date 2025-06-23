{% macro get_column_meta_block(column) %}
  {% if column.config is defined and column.config.meta is defined %}
    {# dbt 1.10 or later #}
    {{ return(column.config.meta) }}
  {% elif column.meta is defined %}
    {# dbt 1.9 or earlier #}
    {{ return(column.meta) }}
  {% else %}
    {{ return(none) }}
  {% endif %}
{% endmacro %}
