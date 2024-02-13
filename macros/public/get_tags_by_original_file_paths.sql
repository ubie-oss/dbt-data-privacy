{% macro get_tags_by_original_file_paths(original_file_paths, has_data_privacy_meta=false, verbose=true) %}
  {% if original_file_paths is not defined or original_file_paths | length == 0 %}
    {% do exceptions.raise_compiler_error("Invalid original_file_paths {}".format(original_file_paths)) %}
  {% endif %}

  {# Select dbt models and sources whose original_file_path is in the list #}
  {% set selected_sources = graph.sources.values()
      | selectattr("original_file_path", "in", original_file_paths) %}
  {% set selected_models = graph.nodes.values()
      | selectattr("original_file_path", "in", original_file_paths) %}
  {% set selected_nodes = selected_sources|list + selected_models|list %}

  {# Filter if a node has data privacy meta #}
  {% if has_data_privacy_meta %}
    {% set selected_nodes = dbt_data_privacy.select_nodes_with_data_privacy_meta(selected_nodes) %}
  {% endif %}

  {# Extract tags #}
  {% set unique_tags = [] %}
  {% for node in selected_nodes %}
    {% if node.tags is defined and node.tags | length > 0 %}
      {% do unique_tags.extend(node.tags) %}
      {% set unique_tags = unique_tags | unique | list %}
    {% endif %}

    {% if node.config is defined and node.config.tags is defined and node.config.tags | length > 0 %}
      {% do unique_tags.extend(node.tags) %}
      {% set unique_tags = unique_tags | unique | list %}
    {% endif %}
  {% endfor %}

  {% if verbose is true %}
    {% do print(tojson(unique_tags | unique | sort | list)) %}
  {% endif %}

  {{ return(unique_tags) }}
{% endmacro %}
