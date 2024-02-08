{% macro get_files_by_tag(tag, verbose=true) %}
  {% set re = modules.re %}

  {#
    This macro `get_files_by_tag` is designed to filter and return the file paths of dbt resources (models, sources, exposures, and metrics) that are tagged with a specific tag.
    It iterates through the dbt graph's nodes, sources, exposures, and metrics to find resources that contain the specified tag either in their direct tags list or within their configuration's tags list.
    Once these resources are identified, it extracts their `original_file_path` and `patch_path` (if defined) to a list, ensuring each path is unique.
    This list of file paths is then printed.

    ## Parameters:
    - `tag`: The tag used to filter resources. This function will return the file paths of resources that are tagged with this value.

    ## Returns:
    - A list of unique file paths (as strings) of the resources that are tagged with the specified tag. This list is printed to the console.
  #}

  {% set selected_resources = [] %}

  {% if graph.nodes is defined %}
    {% for node in graph.nodes.values() %}
      {% if (tag in node.get("tags", [])) or (tag in node.get("config", {}).get("tags", [])) %}
        {% do selected_resources.append(node) %}
      {% endif %}
    {% endfor %}
  {% else %}
    {% do exceptions.warn("The graph.nodes is not defined") %}
  {% endif %}

  {% if graph.sources is defined %}
    {% for source in graph.sources.values() %}
      {% if (tag in source.get("tags", [])) or (tag in source.get("config", {}).get("tags", [])) %}
        {% do selected_resources.append(source) %}
      {% endif %}
    {% endfor %}
  {% else %}
    {% do exceptions.warn("The graph.sources is not defined") %}
  {% endif %}

  {% if graph.exposures is defined %}
    {% for exposure in graph.exposures.values() %}
      {% if (tag in exposure.get("tags", [])) or (tag in exposure.get("config", {}).get("tags", [])) %}
        {% do selected_resources.append(exposure) %}
      {% endif %}
    {% endfor %}
  {% else %}
    {% do exceptions.warn("The graph.exposures is not defined") %}
  {% endif %}

  {% if graph.metrics is defined %}
    {% for metric in graph.metrics.values() %}
      {% if (tag in metric.get("tags", [])) or (tag in metric.get("config", {}).get("tags", [])) %}
        {% do selected_resources.append(metric) %}
      {% endif %}
    {% endfor %}
  {% else %}
    {% do exceptions.warn("The graph.metrics is not defined") %}
  {% endif %}

  {# Get the file paths of the selected resources #}
  {% set file_paths = [] %}
  {% for node in selected_resources %}
    {% if node.original_file_path is defined and node.original_file_path not in file_paths %}
      {% do file_paths.append(node.original_file_path) %}
    {% endif %}

    {% if node.patch_path is defined and node.patch_path not in file_paths %}
      {#
        Replace '^.*://' with empty string
        patch_path is like 'dbt_data_privacy_integration_tests://models/restricted_layer/dbt_data_privacy_restricted_layer/consents/schema.yml'.
      #}
      {% set patch_path = re.sub("^.*://", "", node.patch_path) %}
      {% do file_paths.append(patch_path) %}
    {% endif %}
  {% endfor %}

  {# Unique the list of resources by the attribute of 'original_file_path' #}
  {% set unique_file_paths = file_paths | unique | sort | list %}

  {# Print the list of unique file paths #}
  {% if verbose is true %}
    {{ print(unique_file_paths) }}
  {% endif %}

  {{ return(unique_file_paths) }}
{% endmacro %}
