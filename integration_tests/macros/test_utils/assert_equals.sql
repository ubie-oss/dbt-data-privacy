{% macro assert_equals(value, expected_value) %}
  {% if value != expected_value %}
    {% do exceptions.raise_compiler_error("FAILED: value " ~ value ~ " does not equal to " ~ expected_value) %}
  {% else %}
    {% do log("SUCCESS") %}
  {% endif %}
{% endmacro %}
