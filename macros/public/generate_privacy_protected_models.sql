{% macro generate_privacy_protected_models(unique_ids=none, original_file_paths=none, verbose=true) %}
  {% set generated_models = [] %}

  {# Generate dbt models and sources #}
  {% set models_and_sources = [] %}
  {% do models_and_sources.extend(dbt_data_privacy.get_nodes("model")) %}
  {% do models_and_sources.extend(dbt_data_privacy.get_nodes("source")) %}

  {% if unique_ids is not none and unique_ids | length > 0 %}
    {# Adjust the format
      A `dbt ls` command returns sources with 'source:xxx'. But, an `unique_id` is like `source.xxx`.
      TODO consider use `original_file_path`.
    #}
    {% set unique_ids = unique_ids | map("replace", "source:", "source.") | list %}
    {% for model_or_source in models_and_sources %}
      {% if model_or_source.unique_id in unique_ids
            and dbt_data_privacy.has_data_privacy_meta(model_or_source) %}
        {% set generated_model = dbt_data_privacy.generate_privacy_protected_model(model_or_source) %}
        {% if generated_model is not none and generated_model | length > 0 %}
          {{ generated_models.extend(generated_model) }}
        {% endif %}
      {% endif %}
    {% endfor %}
  {% elif original_file_paths is not none and original_file_paths | length > 0 %}
    {% for model_or_source in models_and_sources %}
      {% if model_or_source.original_file_path in original_file_paths
            and dbt_data_privacy.has_data_privacy_meta(model_or_source) %}
        {% set generated_model = dbt_data_privacy.generate_privacy_protected_model(model_or_source) %}
        {% if generated_model is not none and generated_model | length > 0 %}
          {{ generated_models.extend(generated_model) }}
        {% endif %}
      {% endif %}
    {% endfor %}
  {% else %}
    {% for model_or_source in models_and_sources %}
      {% if dbt_data_privacy.has_data_privacy_meta(model_or_source) %}
        {% set generated_model = dbt_data_privacy.generate_privacy_protected_model(model_or_source) %}
        {% if generated_model is not none and generated_model | length > 0 %}
          {{ generated_models.extend(generated_model) }}
        {% endif %}
      {% endif %}
    {% endfor %}
  {% endif %}

  {% if verbose is true %}
    {% do print(tojson(generated_models)) %}
  {% endif %}

  {{ return(generated_models) }}
{% endmacro %}
