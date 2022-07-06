{% macro get_reference_from_node(node) %}
  {#-
    Get a dbt reference expression from node
  -#}
  {% set reference_expression = none %}

  {% if node.resource_type in ["model", "seed"] %}
    {% set reference_expression = "ref('{}')".format(node.name) %}
  {% elif node.resource_type == 'source' %}
    {% set reference_expression = "source('{}', '{}')".format(node.schema, node.name) %}
  {% endif %}

  {% do return(reference_expression)%}
{% endmacro %}
