{% macro test_select_nodes_by_tags() %}
  {% set nodes = dbt_data_privacy.get_nodes("model") | list %}

  {% set tags = [] %}
  {% set result = dbt_data_privacy.select_nodes_by_tags(nodes, tags=tags) %}
  {{ assert_equals(result | length, 0) }}

  {% set tags = ["tag_in_consents"] %}
  {% set result = dbt_data_privacy.select_nodes_by_tags(nodes, tags=tags) %}
  {{ assert_equals(result | length, 1) }}

  {% set tags = ["tag_in_users"] %}
  {% set result = dbt_data_privacy.select_nodes_by_tags(nodes, tags=tags) %}
  {{ assert_equals(result | length, 1) }}

  {% set tags = ["tag_in_consents", "tag_in_users"] %}
  {% set result = dbt_data_privacy.select_nodes_by_tags(nodes, tags=tags) %}
  {{ assert_equals(result | length, 2) }}
{% endmacro %}
