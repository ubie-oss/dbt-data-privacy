{% macro assert_true(value) %}
  {% if value is boolean and value is not true %}
    {% do exceptions.raise_compiler_error("FAILED: value " ~ value ~ " is not true.") %}
  {% else %}
    {% do log("SUCCESS") %}
  {% endif %}
{% endmacro %}
