{% macro select_nodes_with_data_privacy_meta(nodes) %}
  {% set selected_nodes = [] %}

  {% for node in nodes %}
    {% if dbt_data_privacy.has_data_privacy_meta(node) %}
      {% do selected_nodes.append(node) %}
    {% endif %}
  {% endfor %}

  {{ return(selected_nodes) }}
{% endmacro %}
