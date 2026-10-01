{% macro mapping_items(mapping) %}
  {% set pairs = [] %}
  {% for key in mapping %}
    {% do pairs.append([key, mapping[key]]) %}
  {% endfor %}
  {{ return(pairs) }}
{% endmacro %}
