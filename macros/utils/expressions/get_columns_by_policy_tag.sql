{% macro get_columns_by_policy_tag(columns, policy_tag) %}
  {% set columns_with_target_policy_tag = {} %}

  {% for column_name, column_info in columns.items() %}
    {% set has_policy_tag = false %}

    {# Try new dbt 1.10+ format first (config.meta) #}
    {% if column_info.config is defined
        and column_info.config.meta is defined
        and column_info.config.meta.data_privacy is defined
        and column_info.config.meta.data_privacy.policy_tags is defined
        and policy_tag in column_info.config.meta.data_privacy.policy_tags %}
      {% set has_policy_tag = true %}
    {% endif %}

    {# Fall back to old format (meta) for backward compatibility #}
    {% if not has_policy_tag and column_info.meta is defined
        and column_info.meta.data_privacy is defined
        and column_info.meta.data_privacy.policy_tags is defined
        and policy_tag in column_info.meta.data_privacy.policy_tags %}
      {% set has_policy_tag = true %}
    {% endif %}

    {% if has_policy_tag %}
      {% do columns_with_target_policy_tag.update({column_name: column_info}) %}
    {% endif %}
  {% endfor %}

  {% do return(columns_with_target_policy_tag) %}
{% endmacro %}
