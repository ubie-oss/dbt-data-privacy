{% macro select_nodes_by_original_file_paths(nodes, original_file_paths) %}
  {% set selected_nodes = [] %}

  {% for node in nodes %}
    {% if node.original_file_path is not defined or node.original_file_path is none %}
      {%- do exceptions.warn("original_file_path doesn't exist in {}".format(node)) -%}
    {% endif %}

    {% if node.original_file_path in original_file_paths %}
      {% do selected_nodes.append(dbt_data_privacy.deep_copy_dict(node)) %}
    {% endif %}
  {% endfor %}

  {{ return(selected_nodes) }}
{% endmacro %}
