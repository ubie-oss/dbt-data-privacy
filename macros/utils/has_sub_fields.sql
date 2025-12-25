{% macro has_sub_fields(column_name, columns) %}
  {% set search_column_elements = dbt_data_privacy.split_column_elements(column_name) %}

  {# Iterate over keys to avoid collision with column named "items" #}
  {% for _column_name in columns %}
    {% set _column_info = columns[_column_name] %}
    {% set _column_elements = dbt_data_privacy.split_column_elements(_column_name) %}
    {% if _column_elements | length > search_column_elements | length %}
      {% set comparisons = [] %}
      {% for i in range(search_column_elements | length) %}
        {% if search_column_elements[i] == _column_elements[i] %}
          {% do comparisons.append(true) %}
        {% else %}
          {% do comparisons.append(false)  %}
        {% endif %}
      {% endfor %}

      {% if comparisons | select("equalto", true) | list | length > 0 %}
        {{ return(true) }}
      {% endif %}
    {% endif %}
  {% endfor %}

  {{ return(false) }}
{% endmacro %}
