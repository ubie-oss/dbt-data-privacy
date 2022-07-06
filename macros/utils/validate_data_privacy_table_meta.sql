{% macro validate_data_privacy_in_table_meta(data_privacy_block) %}
  {% if data_privacy_block is not dict %}
    {% do exceptions.raise_compiler_error("The data_privacy_block param is not a dict.") %}
  {% endif %}

  {% if 'name' not in data_privacy_block %}
    {% do exceptions.raise_compiler_error("name doesn't exit in " ~ data_privacy_block) %}
  {% endif %}

  {% if 'config' not in data_privacy_block %}
    {% do exceptions.raise_compiler_error("config doesn't exit in " ~ data_privacy_block) %}
  {% endif %}
{% endmacro %}
