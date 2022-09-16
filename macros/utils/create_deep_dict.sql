{% macro create_deep_dict(keys, value) %}
  {% if keys | length > 1 %}
    {{ return({keys[0]: dbt_data_privacy.create_deep_dict(keys[1:], value) }) }}
  {% else %}
    {{ return({keys[0]: value}) }}
  {% endif %}
{% endmacro %}
