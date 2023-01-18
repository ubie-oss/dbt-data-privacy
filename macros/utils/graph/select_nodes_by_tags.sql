{% macro select_nodes_by_tags(nodes, tags) %}
  {% set selected_nodes = [] %}

  {% set selected_nodes_dict = {} %}
  {% for node in nodes %}
    {% if (node.tags is not defined or node.tags is none)
            or (node.config is defined and (node.config.tags is not defined or node.config.tags is none)) %}
      {%- do exceptions.warn("tags doesn't exist in {}".format(node)) -%}
    {% endif %}

    {% if node.tags is defined and node.tags | length > 0 %}
      {% for tag in node.tags %}
        {% if tag in tags %}
          {% do selected_nodes_dict.update({node.unique_id: node}) %}
        {% endif %}
      {% endfor %}
    {% endif %}

    {% if node.config is defined and node.config.tags is defined and node.config.tags | length > 0 %}
      {% for tag in node.config.tags %}
        {% if tag in tags %}
          {% do selected_nodes_dict.update({node.unique_id: node}) %}
        {% endif %}
      {% endfor %}
    {% endif %}
  {% endfor %}

  {% set selected_nodes = selected_nodes_dict.values() | list %}
  {{ return(selected_nodes) }}
{% endmacro %}
