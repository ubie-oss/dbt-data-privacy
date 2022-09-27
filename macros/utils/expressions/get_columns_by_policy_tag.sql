{% macro get_columns_by_policy_tag(columns, policy_tag) %}
  {% set columns_with_target_policy_tag = {} %}

  {% for column_name, column_info in columns.items() %}
    {% if column_info.meta is defined
        and column_info.meta.data_privacy is defined
        and column_info.meta.data_privacy.policy_tags is defined %}
      {% do columns_with_target_policy_tag.update({column_name: column_info}) %}
    {% endif %}
  {% endfor %}

  {% do return(columns_with_target_policy_tag) %}
{% endmacro %}
