{% macro get_columns_by_policy_tag(columns, policy_tag) %}
  {% set columns_with_target_policy_tag = [] %}

  {% for column in columns %}
    {% if "policy_tags" in column
        and policy_tag in column["policy_tags"] %}
      {% do columns_with_target_policy_tag.append(column) %}
    {% endif %}
  {% endfor %}

  {% do return(columns_with_target_policy_tag) %}
{% endmacro %}
