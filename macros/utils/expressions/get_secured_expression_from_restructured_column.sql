{% macro get_secured_expression_from_restructured_column(restructured_column) %}
  {% if restructured_column.additional_info is defined
        and restructured_column.additional_info.secured_expression is defined
        and restructured_column.additional_info.secured_expression is not none %}
    {{ return(restructured_column.additional_info.secured_expression) }}
  {% endif %}

  {{ return(none) }}
{% endmacro %}
