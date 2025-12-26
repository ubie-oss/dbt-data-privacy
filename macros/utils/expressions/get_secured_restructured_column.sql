{% macro get_secured_restructured_column(data_handling_standards, column_conditions, restructured_column, relative_path=none, depth=0) %}
  {{ return(adapter.dispatch("get_secured_restructured_column", "dbt_data_privacy")(
      data_handling_standards=data_handling_standards,
      column_conditions=column_conditions,
      restructured_column=restructured_column,
      relative_path=relative_path,
      depth=depth)) }}
{% endmacro %}

{% macro bigquery__get_secured_restructured_column(data_handling_standards, column_conditions, restructured_column, relative_path=none, depth=0) %}
  {% set copied_restructured_column = dbt_data_privacy.deep_copy_dict(restructured_column) %}

  {% if relative_path is none %}
    {% set relative_path = [] %}
  {% endif %}

  {% if copied_restructured_column.additional_info is not defined %}
    {% do copied_restructured_column.update({"additional_info": {}}) %}
  {% endif %}
  {% if copied_restructured_column.additional_info is mapping
      and copied_restructured_column.additional_info.relative_path is not defined %}
    {% do copied_restructured_column["additional_info"].update({"relative_path": relative_path}) %}
  {% endif %}

  {% set alias = dbt_data_privacy.get_column_alias(restructured_column.get('original_info', {})) %}
  {% if alias is not none %}
    {% do copied_restructured_column["additional_info"].update({"alias": alias}) %}
  {% endif %}

  {% set is_array = false %}
  {% if restructured_column.original_info is defined
      and restructured_column.original_info is mapping
      and restructured_column.original_info.data_type is defined
      and restructured_column.original_info.data_type in ["ARRAY", "RECORD"] %}
    {% set is_array = true %}
  {% endif %}

  {% set is_struct = false %}
  {% if restructured_column.fields is defined and restructured_column.fields is mapping %}
    {% set is_struct = true %}
  {% endif %}

  {% if is_array is sameas true and is_struct is sameas true %}
    {# ARRAY of STRUCT #}
    {# Iterate over keys to avoid collision with field named "items" #}
    {% for field_key in restructured_column.fields %}
      {% set field_info = restructured_column.fields[field_key] %}
      {# Reset relative_path from the array #}
      {% set secured_restructured_column = dbt_data_privacy.get_secured_restructured_column(
          data_handling_standards=data_handling_standards,
          column_conditions=column_conditions,
          restructured_column=field_info,
          relative_path=[field_key],
          depth=(depth + 1)
        ) %}
      {% do copied_restructured_column.fields[field_key].update(secured_restructured_column) %}
    {% endfor %}
    {{ return(copied_restructured_column) }}
  {% elif is_struct is sameas true %}
    {# STRUCT #}
    {# Iterate over keys to avoid collision with field named "items" #}
    {% for field_key in restructured_column.fields %}
      {% set field_info = restructured_column.fields[field_key] %}
      {% set secured_restructured_column = dbt_data_privacy.get_secured_restructured_column(
          data_handling_standards=data_handling_standards,
          column_conditions=column_conditions,
          restructured_column=field_info,
          relative_path=(relative_path + [field_key]),
          depth=(depth + 1)
        ) %}
      {% do copied_restructured_column["fields"][field_key].update(secured_restructured_column) %}
    {% endfor %}

    {{ return(copied_restructured_column) }}
  {% else %}
    {# SCALAR #}
    {% set level = dbt_data_privacy.get_column_data_security_level(restructured_column.get('original_info', {})) %}
    {% set column_alias = relative_path | join(".") %}
    {% set secured_expression = column_alias %}
    {% set converted_level = level %}

    {% if level is not none %}
      {% set data_type = dbt_data_privacy.get_column_data_type(restructured_column.get('original_info', {})) %}
      {% set secured_expression = dbt_data_privacy.get_secured_expression_by_level(
          data_handling_standards=data_handling_standards,
          column_name=column_alias,
          level=level,
          data_type=data_type,
          column_conditions=column_conditions) %}

      {# Downgrade the data security level if secured #}
      {% set method, with, converted_level = dbt_data_privacy.get_data_handling_standard_by_level(
          data_handling_standards=data_handling_standards,
          level=level) %}
      {% if converted_level is none %}
        {% set converted_level = level %}
      {% endif %}

      {% do copied_restructured_column["additional_info"].update({
        "relative_path": relative_path,
        "secured_expression": secured_expression,
        "level": converted_level,
      }) %}
    {% endif %}
    {{ return(copied_restructured_column) }}
  {% endif %}
{% endmacro %}

{% macro get_secured_expression_from_restructured_column(restructured_column) %}
  {% if restructured_column.additional_info is defined
        and restructured_column.additional_info.secured_expression is defined
        and restructured_column.additional_info.secured_expression is not none %}
    {{ return(restructured_column.additional_info.secured_expression) }}
  {% endif %}

  {{ return(none) }}
{% endmacro %}

{% macro get_converted_level_from_restructured_column(restructured_column) %}
  {% if restructured_column.additional_info is defined
        and restructured_column.additional_info.level is defined
        and restructured_column.additional_info.level is not none %}
    {{ return(restructured_column.additional_info.level) }}
  {% endif %}

  {{ return(none) }}
{% endmacro %}
