{% macro get_node_by_unique_id(unique_id) %}
  {# First try to find it in regular nodes #}
  {%- set node = graph.nodes.get(unique_id) -%}

  {# IF not exists, try to find it in source nodes #}
  {%- if not node -%}
    {%- set node = graph.sources.get(unique_id) -%}
  {%- endif -%}
  {{ return(node) }}
{% endmacro %}
