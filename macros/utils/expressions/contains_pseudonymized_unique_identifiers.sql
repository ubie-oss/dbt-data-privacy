{% macro contains_pseudonymized_unique_identifiers(data_handling_standard, columns) %}
  {% set columns_with_policy_tags = dbt_data_privacy.get_columns_by_policy_tag(columns, "unique_identifier") %}

  {# Iterate over keys to avoid collision with column named "items" #}
  {% for column_name in columns_with_policy_tags %}
    {% set column_info = columns_with_policy_tags[column_name] %}
    {% set data_security_level = dbt_data_privacy.get_data_security_level(column=column_info) %}
    {% set method, with, converted_level = dbt_data_privacy.get_data_handling_standard_by_level(data_handling_standard, level=data_security_level) %}
    {% set is_secure_method = dbt_data_privacy.is_secure_method(method=method) %}

    {% if is_secure_method is sameas true %}
      {% do return(True) %}
    {% endif %}
  {% endfor %}

  {% do return(False) %}
{% endmacro %}
