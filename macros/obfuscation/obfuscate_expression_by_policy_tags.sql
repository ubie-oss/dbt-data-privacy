{% macro obfuscate_expression_by_policy_tags(expression, policy_tags=[]) %}
  {% set obfuscated_expression = none %}

  {% if policy_tags is not none %}
    {% for policy_tag in policy_tags %}
      {% if obfuscated_expression is not none %}
        {{ exceptions.raise_compiler_error("Matches multiple policy tags in {}".format(policy_tags)) }}
      {% endif %}

      {% if policy_tag | lower == "birthdate"  %}
        {% set obfuscated_expression = dbt_data_privacy.extract_year_from_date(expression) %}
      {% endif %}
    {% endfor %}
  {% endif %}

  {{ return(obfuscated_expression) }}
{% endmacro %}
