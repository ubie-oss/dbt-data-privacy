{% macro get_nodes(resource_type) %}
  {# NOTE if specifications of macros are changed in the future, we will support multiple versions. #}

  {% do return(dbt_data_privacy.get_nodes_v1(resource_type)) %}
{% endmacro %}

{% macro get_nodes_v1(resource_type) %}
  {% if resource_type == "source" %}
    {% set nodes = graph.sources.values() %}
    {% do return(nodes) %}
  {% else %}
    {% set nodes = graph.nodes.values()
        | selectattr("resource_type", "equalto", resource_type) %}
    {% do return(nodes) %}
  {% endif %}
{% endmacro %}
