{% macro get_secured_expression_by_method(expression, method, data_type=none, column_conditions=none, with_params=none) %}
  {% set secured_expression = adapter.dispatch('get_secured_expression_by_method', 'dbt_data_privacy')(
    expression=expression,
    method=method,
    data_type=data_type,
    column_conditions=column_conditions,
    with_params=with_params) %}
  {{ return(secured_expression) }}
{% endmacro %}

{% macro bigquery__get_secured_expression_by_method(expression, method, data_type=none, column_conditions=none, with_params=none) %}
  {% set secured_expression = none %}
  {% set is_secured = none %}

  {% set uppercase_method = method | upper %}

  {% if uppercase_method == "RAW" %}
    {% set secured_expression = expression %}
  {% elif uppercase_method == "SHA256" %}
    {% set secured_expression = dbt_data_privacy.sha256(expression, data_type=data_type) %}
  {% elif uppercase_method == "SHA512" %}
    {% set secured_expression = dbt_data_privacy.sha512(expression, data_type=data_type) %}
  {% elif uppercase_method == "CONDITIONAL_HASH" %}
    {% if with_params is mapping
        and with_params.default_method is defined
        and with_params.conditions is defined %}
      {% set secured_expression = dbt_data_privacy.conditional_hash(
        column_conditions=column_conditions,
        expression=expression,
        default_method=with_params.default_method,
        conditions=with_params.conditions,
        data_type=data_type) %}
    {% else %}
      {{ exceptions.raise_compiler_error("Invalid inputs for {} with {} under {} ".format(expression, method, column_conditions)) }}
    {% endif %}
  {% elif uppercase_method == "UDF_HASH" %}
    {% set udf_function = none %}
    {% if with_params is mapping
        and with_params.function is defined %}
      {% set udf_function = with_params.function %}
    {% endif %}
    {% set secured_expression = dbt_data_privacy.udf(expression, udf_function=udf_function, data_type=data_type) %}
  {% elif uppercase_method == "DROPPED" %}
    {# do nothing #}
  {% else %}
    {{ exceptions.raise_compiler_error("No such method: {}".format(uppercase_method)) }}
  {% endif %}

  {% do return(secured_expression) %}
{% endmacro %}
