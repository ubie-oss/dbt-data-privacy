{% macro get_policy_tags(column_info) %}
  {{ return(column_info.get("policy_tags", [])) }}
{% endmacro %}

{% macro is_enabled_policy_tag(policy_tag, enabled_policy_tags) %}
  {% if policy_tag in enabled_policy_tags %}
    {{ return(True) }}
  {% endif %}
  {{ return(False) }}
{% endmacro %}

{% macro extract_enabled_policy_tags(policy_tags, enabled_policy_tags) %}
  {# Extract policy tags which are in enabled policy tags #}

  {% set matched_enabled_tags = [] %}
  {% if (policy_tags is not none and policy_tag is iterable)
      or (enabled_policy_tags is not none and enabled_policy_tags is iterable) %}
    {% for policy_tag in policy_tags %}
      {% if policy_tag in enabled_policy_tags %}
        {% do matched_enabled_tags.append(policy_tag) %}
      {% endif %}
    {% endfor %}
  {% endif %}
  {{ return(matched_enabled_tags) }}
{% endmacro %}
