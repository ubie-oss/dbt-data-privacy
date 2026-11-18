{% macro get_nodes(resource_type) %}
  {% if resource_type == "source" %}
    {% set nodes = graph.sources.values() %}
    {% do return(nodes) %}
  {% else %}
    {% set nodes = graph.nodes.values()
        | selectattr("resource_type", "equalto", resource_type) %}
    {% do return(nodes) %}
  {% endif %}
{% endmacro %}
