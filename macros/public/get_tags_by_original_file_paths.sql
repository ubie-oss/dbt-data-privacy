{% macro get_tags_by_original_file_paths(original_file_paths, resources=none, verbose=true) %}
  {% if original_file_paths is not defined or original_file_paths | length == 0 %}
    {% do exceptions.raise_compiler_error("Invalid original_file_paths {}".format(original_file_paths)) %}
  {% endif %}

  {% set unique_tags = [] %}

  {# Generate dbt models and sources #}
  {% set models_and_sources = [] %}
  {% do models_and_sources.extend(dbt_data_privacy.get_nodes("model")) %}
  {% do models_and_sources.extend(dbt_data_privacy.get_nodes("source")) %}

  {# Collect nodes #}
  {% set selected_nodes = [] %}
  {% for node in models_and_sources %}
    {% if node.original_file_path is not defined %}
      {%- do exceptions.warn("{} doesn't have original_file_path".format(node)) -%}
    {% endif %}

    {% if node.original_file_path in original_file_paths
            and node.tags is defined
            and node.tags | length > 0 %}
      {% do selected_nodes.append(node) %}
    {% elif node.original_file_path in original_file_paths
            and node.config is defined
            and node.config.tags is defined
            and (node.config.tags is defined and node.config.tags | length > 0 ) %}
      {% do selected_nodes.append(node) %}
    {% endif %}
  {% endfor %}

  {# Collect tags #}
  {% for node in selected_nodes %}
    {% if node.tags is defined and node.tags | length > 0 %}
      {% do unique_tags.extend(node.tags) %}
      {% set unique_tags = unique_tags | unique | list %}
    {% endif %}
  {% endfor %}

  {% if verbose is true %}
    {% do print(tojson(unique_tags)) %}
  {% endif %}

  {{ return(unique_tags) }}
{% endmacro %}
