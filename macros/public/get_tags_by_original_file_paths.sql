{% macro get_tags_by_original_file_paths(original_file_paths, has_data_privacy_meta=false, verbose=true) %}
  {% if original_file_paths is not defined or original_file_paths | length == 0 %}
    {% do exceptions.raise_compiler_error("Invalid original_file_paths {}".format(original_file_paths)) %}
  {% endif %}

  {% set unique_tags = [] %}

  {# Generate dbt models and sources #}
  {% set models_and_sources = [] %}
  {% do models_and_sources.extend(dbt_data_privacy.get_nodes("model")) %}
  {% do models_and_sources.extend(dbt_data_privacy.get_nodes("source")) %}

  {# Filter by original_file_paths #}
  {% set selected_nodes = [] %}
  {% if original_file_paths is not none and original_file_paths | length > 0 %}
    {% set selected_nodes = dbt_data_privacy.select_nodes_by_original_file_paths(
            models_and_sources, original_file_paths) %}
  {% endif %}

  {# Filter if a node has data privacy meta #}
  {% if has_data_privacy_meta %}
    {% set selected_nodes = dbt_data_privacy.select_nodes_with_data_privacy_meta(selected_nodes) %}
  {% endif %}

  {# Extract tags #}
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
    {% do print(tojson(unique_tags | unique | list)) %}
  {% endif %}

  {{ return(unique_tags) }}
{% endmacro %}
