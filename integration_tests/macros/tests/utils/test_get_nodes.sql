{% macro test_get_nodes() %}
  {{- return(adapter.dispatch("test_get_nodes", "dbt_data_privacy_integration_tests")()) -}}
{% endmacro %}

{% macro bigquery__test_get_nodes() %}
  {%- set nodes = dbt_data_privacy.get_nodes("model") -%}
  {% for node in nodes %}
    {{ assert_equals(node.resource_type, "model") }}
  {% endfor %}

  {%- set nodes = dbt_data_privacy.get_nodes("source") -%}
  {% for node in nodes %}
    {{ assert_equals(node.resource_type, "source") }}
  {% endfor %}
{% endmacro %}
