{% macro validate_relationships(relationships) %}
  {% if 'to' not in relationships %}
    {% do exceptions.raise_compiler_error("Invalid relationships: 'to' doesn't exist in " ~ relationships) %}
  {% elif 'fields' not in relationships %}
    {% do exceptions.raise_compiler_error("Invalid relationships: 'fieldw' doesn't exist in " ~ relationships) %}
  {% elif relationships["fields"] is not mapping %}
    {% do exceptions.raise_compiler_error("Invalid relationships: 'fields' is not a dict" ~ relationships) %}
  {% endif %}
  {{ return(true) }}
{% endmacro %}
