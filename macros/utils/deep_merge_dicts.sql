{% macro deep_merge_dicts(base_dict, updating_dict) %}
  {% if base_dict is not mapping %}
    {% do exceptions.raise_compiler_error("base_dict is not dict: {}".format(base_dict)) %}
  {% elif updating_dict is not mapping %}
    {% do exceptions.raise_compiler_error("updating_dict is not dict: {}".format(updating_dict)) %}
  {% endif %}

  {% set merged_dict = base_dict %}
  {% for k, v in updating_dict.items() %}
    {% if k in base_dict and base_dict.get(k) is mapping and v is mapping %}
      {% set merged_dict = dbt_data_privacy.deep_merge_dicts(base_dict.get(k), v) %}
      {% do merged_dict.update(merged_dict) %}
    {% else %}
      {% do merged_dict.update({k: v}) %}
    {% endif %}
  {% endfor %}

  {{ return(merged_dict) }}
{% endmacro %}
