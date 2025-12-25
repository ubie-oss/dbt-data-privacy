{% macro restructure_secured_columns(secured_columns) %}
  {% set restructured_secured_columns = {} %}

  {# Iterate over keys to avoid collision with column named "items" #}
  {% for column_name in secured_columns %}
    {% set secured_info = secured_columns[column_name] %}
    {% set column_name_elements = column_name.split(".") %}
    {% set part_of_restructured_secured_columns = dbt_data_privacy.create_deep_dict(column_name_elements, secured_info) %}
    {% set restructured_secured_columns = dbt_data_privacy.deep_merge_dicts(
      restructured_secured_columns, part_of_restructured_secured_columns) %}
  {% endfor %}

  {{ return(restructured_secured_columns) }}
{% endmacro %}
