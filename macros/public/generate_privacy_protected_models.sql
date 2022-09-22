{% macro generate_privacy_protected_models(unique_ids=none, verbose=true) %}
  {% set generated_models = [] %}

  {# Generate dbt models and sources #}
  {% set models_and_sources = [] %}
  {% do models_and_sources.extend(dbt_data_privacy.get_nodes("model")) %}
  {% do models_and_sources.extend(dbt_data_privacy.get_nodes("source")) %}

  {# Set the default value with all models which have an 'unique_id' attribute. #}
  {% if unique_ids is none %}
    {% set unique_ids = models_and_sources | selectattr("unique_id", "defined") | map(attribute="unique_id") | list %}
  {% endif %}

  {% if unique_ids | length == 0 %}
    {{ exceptions.raise_compiler_error("There is no 'unique_id's to select.") }}
  {% endif %}

  {% for model_or_source in models_and_sources %}
    {% if model_or_source.unique_id in unique_ids and dbt_data_privacy.has_data_privacy_meta(model_or_source) %}
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
