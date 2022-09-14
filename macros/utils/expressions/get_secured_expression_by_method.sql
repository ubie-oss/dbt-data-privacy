{% macro get_secured_expression_by_method(expression, method) %}
  {% set secured_expression = adapter.dispatch('get_secured_expression_by_method', 'dbt_data_privacy')(expression, method) %}
  {{ return(secured_expression) }}
{% endmacro %}

{% macro bigquery__get_secured_expression_by_method(expression, method) %}
  {% set secured_expression = none %}
  {% set is_secured = none %}

  {% if method == "RAW" %}
    {% set secured_expression = expression %}
  {% elif method == "SHA256" %}
    {% set secured_expression = dbt_data_privacy.sha256(expression) %}
  {% elif method == "SHA512" %}
    {% set secured_expression = dbt_data_privacy.sha512(expression) %}
  {% elif method == "CONDITIONAL_HASH" %}
    {% set with_params = none %}
    {% set column_conditions = none %}
    {% if 'with' in kwargs %}
      {% set with_params = kwargs['with'] %}
    {% endif %}
    {% if 'column_condition' in kwargs %}
      {% set with_params = kwargs['column_condition'] %}
    {% endif %}

    {% set secured_expression = dbt_data_privacy.conditional_hash(expression, with_params, column_conditions=column_conditions) %}
  {% elif method == "DROPPED" %}
    {# do nothing #}
  {% else %}
    {{ exceptions.raise_compiler_error("No such method: {}".format(method)) }}
  {% endif %}

  {% do return(secured_expression) %}
{% endmacro %}
