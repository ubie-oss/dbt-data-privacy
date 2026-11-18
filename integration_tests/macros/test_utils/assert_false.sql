{% macro assert_false(value) %}
  {% if value is boolean and value is not false %}
    {% do exceptions.raise_compiler_error("FAILED: value " ~ value ~ " is not false.") %}
  {% else %}
    {% do log("SUCCESS") %}
  {% endif %}
{% endmacro %}
