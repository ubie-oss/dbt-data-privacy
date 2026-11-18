{% macro get_converted_level_from_restructured_column(restructured_column) %}
  {% if restructured_column.additional_info is defined
        and restructured_column.additional_info.level is defined
        and restructured_column.additional_info.level is not none %}
    {{ return(restructured_column.additional_info.level) }}
  {% endif %}

  {{ return(none) }}
{% endmacro %}
