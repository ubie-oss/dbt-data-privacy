{% macro get_column_meta_block(column) %}
  {% if column.config is defined and column.config.meta is defined and column.config.meta | length > 0 %}
    {# dbt 1.10 or later and config.meta has content #}
    {{ return(column.config.meta) }}
  {% elif column.meta is defined and column.meta | length > 0 %}
    {# dbt 1.9 or earlier or dbt 1.10 with empty config.meta but meta has content #}
    {{ return(column.meta) }}
  {% else %}
    {{ return(none) }}
  {% endif %}
{% endmacro %}
