{% macro get_secured_expression_by_standard(column_name, strategy) %}
  {% set expression = none %}

  {% if strategy == "RAW" %}
    {% set expression = column_name %}
  {% elif strategy == "SHA256" %}
    {% set expression = dbt_data_privacy.sha256(column_name) %}
  {% elif strategy == "SHA512" %}
    {% set expression = dbt_data_privacy.sha512(column_name) %}
  {% elif strategy == "DROPPED" %}
    {# do nothing #}
  {% else %}
    {{ exceptions.raise_compiler_error("No such strategy: {}".format(strategy)) }}
  {% endif %}

  {% do return(expression) %}
{% endmacro %}
