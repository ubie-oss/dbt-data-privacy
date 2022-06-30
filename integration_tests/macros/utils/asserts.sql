{% macro assert_equals(value, expected_value) %}
    {% if value != expected_value %}
        {% do exceptions.raise_compiler_error("FAILED: value " ~ value ~ " does not equal to " ~ expected_value) %}
    {% else %}
        {% do log("SUCCESS") %}
    {% endif %}
{% endmacro %}

{% macro assert_str_in_value(str, value) %}
    {% if str not in value %}
        {% do exceptions.raise_compiler_error("FAILED: the string " ~ str ~ " was not found in " ~ value) %}
    {% else %}
        {% do log("SUCCESS") %}
    {% endif %}
{% endmacro %}

{% macro assert_element_in_list(element, list_values) %}
    {% if element not in list_values %}
        {% do exceptions.raise_compiler_error("FAILED: the element " ~ element ~ " was not found in " ~ list_values) %}
    {% else %}
        {% do log("SUCCESS") %}
    {% endif %}
{% endmacro %}
