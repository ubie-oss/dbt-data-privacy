{% macro restructure_secured_columns(secured_columns) %}
  {% set restructured_secured_columns = {} %}

  {% for column_name, secured_info in secured_columns.items() %}
    {% set column_name_elements = column_name.split(".") %}
    {% set part_of_restructured_secured_columns = dbt_data_privacy.create_deep_dict(column_name_elements, secured_info) %}
    {% set restructured_secured_columns = dbt_data_privacy.deep_merge_dicts(
      restructured_secured_columns, part_of_restructured_secured_columns) %}
  {% endfor %}

  {{ return(restructured_secured_columns) }}
{% endmacro %}
