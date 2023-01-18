{% macro generate_privacy_protected_models(unique_ids=none, original_file_paths=none, tags=none, verbose=true) %}
  {% set generated_models = [] %}

  {# Generate dbt models and sources #}
  {% set models_and_sources = [] %}
  {% do models_and_sources.extend(dbt_data_privacy.get_nodes("model")) %}
  {% do models_and_sources.extend(dbt_data_privacy.get_nodes("source")) %}

  {% set selected_models_and_sources = models_and_sources %}

  {# Filter by unique_ids #}
  {% if unique_ids is not none and unique_ids | length > 0 %}
    {% set selected_models_and_sources = dbt_data_privacy.select_nodes_by_unique_ids(
            selected_models_and_sources, unique_ids) %}
  {% endif %}

  {# Filter by original_file_paths #}
  {% if original_file_paths is not none and original_file_paths | length > 0 %}
    {% set selected_models_and_sources = dbt_data_privacy.select_nodes_by_original_file_paths(
            selected_models_and_sources, original_file_paths) %}
  {% endif %}

  {# Filter by tags #}
  {% if tags is not none and tags | length > 0 %}
    {% set selected_models_and_sources = dbt_data_privacy.select_nodes_by_tags(
            selected_models_and_sources, tags) %}
  {% endif %}

  {# Generate models #}
  {% for model_or_source in selected_models_and_sources %}
    {% if dbt_data_privacy.has_data_privacy_meta(model_or_source) %}
      {% set generated_model = dbt_data_privacy.generate_privacy_protected_model(model_or_source) %}
      {% if generated_model is not none and generated_model | length > 0 %}
        {{ generated_models.extend(generated_model) }}
      {% endif %}
    {% endif %}
  {% endfor %}

  {% if verbose is true %}
    {% do print(tojson(generated_models)) %}
  {% endif %}

  {{ return(generated_models) }}
{% endmacro %}
