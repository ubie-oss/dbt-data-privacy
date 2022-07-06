{% macro get_nodes_by_unique_ids(unique_ids) %}
  {% set nodes = []%}

  {% if execute %}
    {% if unique_ids and unique_ids is iterable %}
      {% for unique_id in unique_ids %}
        {% set node = dbt_data_privacy.get_node_by_unique_id(unique_id) %}
        {% if node %}
          {% do nodes.append(node) %}
        {% endif %}
      {% endfor %}
    {% endif %}
  {% endif %}

  {{ return(nodes) }}
{% endmacro %}
