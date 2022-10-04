{% macro convert_to_nested_dict(keys, value) %}
  {% if keys | length > 1 %}
    {#
    {% set nested_dict = {"fields": {}} %}
    {% do nested_dict["fields"].update(dbt_data_privacy.convert_to_nested_dict(keys[1:], value)) %}
    #}
    {% set nested_dict = {keys[0]: {}} %}
    {% do nested_dict[keys[0]].update({"fields": dbt_data_privacy.convert_to_nested_dict(keys[1:], value)}) %}
    {{ return(nested_dict) }}
  {% else %}
    {{ return({keys[0]: value}) }}
  {% endif %}
{% endmacro %}
