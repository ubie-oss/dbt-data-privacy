{% macro assert_dict_equals(value, expected_value) %}
  {% for k, v in value.items() %}
    {% if k not in expected_value.keys() %}
      {% do exceptions.raise_compiler_error("FAILED: key " ~ k ~ " from " ~ value ~ " does not exist in " ~ expected_value) %}
    {% elif v is mapping and expected_value[k] is mapping %}
      {% do assert_dict_equals(v, expected_value[k]) %}
    {% elif v != expected_value[k] %}
      {% do exceptions.raise_compiler_error("FAILED: value " ~ v ~ " from " ~ value ~ " does not equal to " ~ expected_value[k]) %}
    {% endif %}
  {% endfor %}

  {% do log("SUCCESS") %}
{% endmacro %}
