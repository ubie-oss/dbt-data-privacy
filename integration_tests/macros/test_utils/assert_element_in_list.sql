{% macro assert_element_in_list(element, list_values) %}
  {% if element not in list_values %}
    {% do exceptions.raise_compiler_error("FAILED: the element " ~ element ~ " was not found in " ~ list_values) %}
  {% else %}
    {% do log("SUCCESS") %}
  {% endif %}
{% endmacro %}
