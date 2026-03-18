{% macro validate_relationships(relationships) %}
  {% if relationships is none or relationships | length == 0 %}
    {{ return(false) }}
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
