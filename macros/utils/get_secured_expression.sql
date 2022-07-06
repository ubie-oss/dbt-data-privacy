{% macro get_secured_expression(column_name, data_security_level, data_handling_standard=none) %}
  {%- set expression = none -%}

  {% if data_handling_standard is none %}
    {% set data_handling_standard = dbt_data_privacy.get_default_data_handling_standard() %}
  {% endif %}

  {#
  {% if data_security_level in data_handling_standard %}
    {% set expression = dbt_data_privacy.get_secured_expression_by_strategy(
        column_name, data_handling_standard[data_security_level], data_handling_standard=data_handling_standard) %}
  {% else %}
    {{ exceptions.raise_compiler_error("No such level {} for column {} in {}".format(data_security_level, column_name, data_handling_standard)) }}
  {% endif %}
  #}

  {% set expression = dbt_data_privacy.get_secured_expression_by_data_security_level(
      column_name, data_security_level, data_handling_standard=data_handling_standard) %}

  {% do return(expression) %}
{% endmacro %}

{% macro get_secured_expression_by_data_security_level(
    column_name, data_security_level, data_handling_standard=none) %}
  {% set expression = "" %}

  {% if data_handling_standard is none %}
    {% set data_handling_standard = dbt_data_privacy.get_data_handling_standard() %}
  {% endif %}

  {% if data_security_level in data_handling_standard %}
    {% set expression = dbt_data_privacy.get_secured_expression_by_standard(
        column_name, data_handling_standard[data_security_level]) %}
  {% else %}
    {{ exceptions.raise_compiler_error("No such data security level {} for column {} in {}".format(data_security_level, column_name, data_handling_standard)) }}
  {% endif %}

  {% do return(expression) %}
{% endmacro %}

{% macro get_secured_expression_by_standard(column_name, strategy) %}
  {% set expression = none %}

  {% if strategy == "RAW" %}
    {%- set expression -%}
      {{ column_name }}
    {%- endset -%}
  {% elif strategy == "SHA256" %}
    {%- set expression -%}
      TO_BASE64(SHA256(CAST({{ column_name }} AS STRING)))
    {%- endset -%}
  {% elif strategy == "SHA512" %}
    {%- set expression -%}
      TO_BASE64(SHA512(CAST({{ column_name }} AS STRING)))
    {%- endset -%}
  {% elif strategy == "DROPPED" %}
    {# do nothing #}
  {% else %}
    {{ exceptions.raise_compiler_error("No such strategy: {}".format(strategy)) }}
  {% endif %}

  {% do return(expression) %}
{% endmacro %}