{% macro test_get_files_by_tag() %}
  {% set result = dbt_data_privacy.get_files_by_tag(tag="no_such_tag", verbose=false) %}
  {{ assert_equals(result | length, 0) }}

  {% set result = dbt_data_privacy.get_files_by_tag(tag="tag_in_consents", verbose=false) %}
  {{ assert_equals(result | length, 2) }}
  {{ assert_equals(result[0], "models/restricted_layer/dbt_data_privacy_restricted_layer/consents/restricted_layer__dbt_data_privacy_restricted_layer__consents.sql") }}
  {{ assert_equals(result[1], "models/restricted_layer/dbt_data_privacy_restricted_layer/consents/schema.yml") }}
{% endmacro %}
