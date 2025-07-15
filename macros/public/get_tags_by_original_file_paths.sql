{% macro get_tags_by_original_file_paths(original_file_paths, has_data_privacy_meta=false, verbose=true) %}
  {#
    This macro retrieves unique tags from dbt models, sources, and snapshots
    based on their original file paths and an optional data privacy meta filter.

    Args:
      original_file_paths (list): A list of original file paths to filter nodes by.
      has_data_privacy_meta (bool): If true, filters nodes that have data privacy metadata.
      verbose (bool): If true, prints the unique tags to the console.

    Returns:
      list: A list of unique tags found in the selected nodes.
  #}
  {% if original_file_paths is not defined or original_file_paths | length == 0 %}
    {# Raise an error if original_file_paths is not defined or empty #}
    {% do exceptions.raise_compiler_error("Invalid original_file_paths {}".format(original_file_paths)) %}
  {% endif %}

  {% set unique_tags = {} %}

  {# Collect all dbt models, sources, and snapshots #}
  {% set models_and_sources = [] %}
  {% do models_and_sources.extend(dbt_data_privacy.get_nodes("source")) %}
  {% do models_and_sources.extend(dbt_data_privacy.get_nodes("model")) %}
  {% do models_and_sources.extend(dbt_data_privacy.get_nodes("snapshot")) %}

  {# Filter nodes by original_file_paths if provided #}
  {% set selected_nodes = [] %}
  {% if original_file_paths is not none and original_file_paths | length > 0 %}
    {% set selected_nodes = dbt_data_privacy.select_nodes_by_original_file_paths(
            models_and_sources, original_file_paths) %}
  {% endif %}

  {# Further filter nodes if they have data privacy meta #}
  {% if has_data_privacy_meta %}
    {% set selected_nodes = dbt_data_privacy.select_nodes_with_data_privacy_meta(selected_nodes) %}
  {% endif %}


  {# Extract unique tags from the selected nodes #}
  {% for node in selected_nodes %}
    {# Add tags from node.tags #}
    {% if node.tags is defined and node.tags | length > 0 %}
      {% for tag in node.tags %}
        {% do unique_tags.update({tag: true}) %}
      {% endfor %}
    {% endif %}

    {# Add tags from node.config.tags #}
    {% if node.config is defined and node.config.tags is defined and node.config.tags | length > 0 %}
      {% for tag in node.config.tags %}
        {% do unique_tags.update({tag: true}) %}
      {% endfor %}
    {% endif %}
  {% endfor %}

  {# Print unique tags if verbose is true #}
  {% if verbose is true %}
    {% do print(tojson(unique_tags.keys() | sort | list)) %}
  {% endif %}

  {# Return the unique tags as a list #}
  {{ return(unique_tags.keys() | sort | list) }}
{% endmacro %}
