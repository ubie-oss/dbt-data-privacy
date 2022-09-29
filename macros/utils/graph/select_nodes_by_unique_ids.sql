{% macro select_nodes_by_unique_ids(nodes, unique_ids) %}
  {% set selected_nodes = [] %}

  {# Adjust the format #}
  {# NOTE: A `dbt ls` command returns sources with 'source:xxx'. But, an `unique_id` is like `source.xxx`. #}
  {% set unique_ids = unique_ids | map("replace", "source:", "source.") | list %}

  {% for node in nodes %}
    {% if node.unique_id is not defined or node.unique_id is none %}
      {%- do exceptions.warn("unique_id doesn't exist in {}".format(node)) -%}
    {% endif %}

    {% if node.unique_id in unique_ids %}
      {% do selected_nodes.append(node.copy()) %}
    {% endif %}
  {% endfor %}

  {{ return(selected_nodes) }}
{% endmacro %}
