{% macro select_nodes_with_data_privacy_meta(nodes) %}
  {% set ns = namespace(selected_nodes=[]) %}

  {% for node in nodes %}
    {% if dbt_data_privacy.has_data_privacy_meta(node) %}
      {% do ns.selected_nodes.append(node) %}
    {% endif %}
  {% endfor %}

  {{ return(ns.selected_nodes) }}
{% endmacro %}
