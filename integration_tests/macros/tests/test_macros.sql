{% macro test_macros() %}
  {{- return(adapter.dispatch("test_macros", "dbt_data_privacy_integration_tests")()) -}}
{% endmacro %}

{% macro bigquery__test_macros() %}

  {# pseudonymization #}
  {% do test_sha256() %}
  {% do test_sha512() %}

{% endmacro %}
