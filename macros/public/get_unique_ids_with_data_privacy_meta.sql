{% macro get_unique_ids_with_data_privacy_meta(unique_ids=none, verbose=true) %}
  {% set selected_unique_ids = [] %}

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
      {% do selected_unique_ids.append(model_or_source.unique_id) %}
    {% endif %}
  {% endfor %}

  {% if verbose is true %}
    {% do print(tojson(selected_unique_ids)) %}
  {% endif %}

  {{ return(selected_unique_ids) }}
{% endmacro %}
