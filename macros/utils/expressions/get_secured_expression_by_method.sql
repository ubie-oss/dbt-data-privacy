{% macro get_secured_expression_by_method(expression, method, data_type=none, column_conditions=none) %}
  {% set secured_expression = adapter.dispatch('get_secured_expression_by_method', 'dbt_data_privacy')(
    expression=expression,
    method=method,
    data_type=data_type) %}
  {{ return(secured_expression) }}
{% endmacro %}

{% macro bigquery__get_secured_expression_by_method(expression, method, data_type=none) %}
  {% set secured_expression = none %}
  {% set is_secured = none %}

  {% if method == "RAW" %}
    {% set secured_expression = expression %}
  {% elif method == "SHA256" %}
    {% set secured_expression = dbt_data_privacy.sha256(expression, data_type=data_type) %}
  {% elif method == "SHA512" %}
    {% set secured_expression = dbt_data_privacy.sha512(expression, data_type=data_type) %}
  {% elif method == "CONDITIONAL_HASH" %}
    {% set with_params = none %}
    {% if kwargs.with_params is defined
        and kwargs.with_params.default_method is defined
        and kwargs.with_params.condition is defined %}
      {% set secured_expression = dbt_data_privacy.conditional_hash(
        expression,
        with_params,
        column_conditions=column_conditions,
        data_type=data_type) %}
    {% else %}
      {{ exceptions.raise_compiler_error("Invalid inputs for {} with {} under {} ".format(expression, method, column_conditions)) }}
    {% endif %}
  {% elif method == "DROPPED" %}
    {# do nothing #}
  {% else %}
    {{ exceptions.raise_compiler_error("No such method: {}".format(method)) }}
  {% endif %}

  {% do return(secured_expression) %}
{% endmacro %}
