{% macro restructure_columns(columns) %}
  {% set restructured_columns = {} %}

  {% for column_name, column_info in columns.items() %}
    {% set column_name_elements = dbt_data_privacy.split_column_elements(column_name) %}
    {% set part_of_restructured_columns = dbt_data_privacy.convert_to_nested_dict(column_name_elements, column_info) %}
    {% set restructured_columns = dbt_data_privacy.deep_merge_dicts(restructured_columns, part_of_restructured_columns) %}
  {% endfor %}

  {{ return(restructured_columns) }}
{% endmacro %}
