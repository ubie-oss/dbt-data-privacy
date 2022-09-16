{% macro generate_privacy_protected_models(verbose=true) %}
  {% set generated_models = [] %}

  {# Generate dbt models and sources #}
  {% set models_and_sources = [] %}
  {% do models_and_sources.extend(dbt_data_privacy.get_nodes("model")) %}
  {% do models_and_sources.extend(dbt_data_privacy.get_nodes("source")) %}

  {% if models_and_sources | length == 0 %}
    {% do exceptions.warn("Found no models and sources") %}
  {% endif %}

  {% if execute and models_and_sources | length > 0 %}
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
