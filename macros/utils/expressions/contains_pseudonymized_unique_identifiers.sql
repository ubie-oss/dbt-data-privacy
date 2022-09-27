{% macro contains_pseudonymized_unique_identifiers(data_handling_standard, columns) %}
  {% set columns_with_policy_tags = dbt_data_privacy.get_columns_by_policy_tag(columns, "unique_identifier") %}

  {% for column_name, column_info in columns_with_policy_tags.items() %}
    {% set data_security_level = dbt_data_privacy.get_data_security_level(column=column_info) %}
    {% set method, with, converted_level = dbt_data_privacy.get_data_handling_standard_by_level(data_handling_standard, level=data_security_level) %}
    {% set is_secure_method = dbt_data_privacy.is_secure_method(method=method) %}

    {% if is_secure_method is sameas true %}
      {% do return(True) %}
    {% endif %}
  {% endfor %}

  {% do return(False) %}
{% endmacro %}
