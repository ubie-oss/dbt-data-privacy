{% macro validate_relationships(relationships) %}
  {% if relationships is not none and relationships is not sequence %}
    {# If relationships is not a sequence (e.g., a dict or string), treat it as none #}
    {{ return(true) }}
  {% endif %}

  {% if relationships is not sequence %}
    {% do exceptions.raise_compiler_error("Invalid relationships: it must be a sequence" ~ relationships) %}
  {% endif %}

  {% for i in range(relationships | length) %}
    {% if 'to' not in relationships[i] %}
      {% do exceptions.raise_compiler_error("Invalid relationships: 'to' doesn't exist in " ~ relationships) %}
    {% elif 'fields' not in relationships[i] %}
      {% do exceptions.raise_compiler_error("Invalid relationships: 'fields' doesn't exist in " ~ relationships) %}
    {% elif relationships[i]["fields"] is not mapping %}
      {% do exceptions.raise_compiler_error("Invalid relationships: 'fields' is not a dict" ~ relationships) %}
    {% endif %}
  {% endfor %}

  {{ return(true) }}
{% endmacro %}
