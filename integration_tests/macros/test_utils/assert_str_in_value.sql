{% macro assert_str_in_value(str, value) %}
  {% if str not in value %}
    {% do exceptions.raise_compiler_error("FAILED: the string " ~ str ~ " was not found in " ~ value) %}
  {% else %}
    {% do log("SUCCESS") %}
  {% endif %}
{% endmacro %}
