{% macro has_sub_fields(column_name, columns) %}
  {% set search_column_elements = dbt_data_privacy.split_column_elements(column_name) %}

  {% for _column_name, _column_info in columns.items() %}
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
