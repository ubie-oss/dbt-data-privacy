{% macro test_column_named_items() %}
  {% set columns = {
    'items': {
      'name': 'items',
      'config': {
        'meta': {
          'data_privacy': {'level': 'confidential', 'policy_tags': ['unique_identifier']}
        }
      }
    },
    'order.items': {
      'name': 'order.items',
      'config': {
        'meta': {
          'data_privacy': {'level': 'public'}
        }
      }
    }
  } %}
  {% set tagged = dbt_data_privacy.get_columns_by_policy_tag(columns, 'unique_identifier') %}
  {{ assert_equals(tagged['items']['name'], 'items') }}

  {% set restructured = dbt_data_privacy.restructure_columns(columns) %}
  {{ assert_equals(restructured['items']['original_info']['name'], 'items') }}
  {{ assert_equals(restructured['order']['fields']['items']['original_info']['name'], 'order.items') }}

  {% set data_handling_standard = {
    'public': {'method': 'RAW'},
    'internal': {'method': 'RAW'},
    'confidential': {'method': 'SHA256'},
    'restricted': {'method': 'DROPPED'}
  } %}
  {% set has_secure_identifier = dbt_data_privacy.contains_pseudonymized_unique_identifiers(
    data_handling_standard, columns) %}
  {{ assert_equals(has_secure_identifier, true) }}
{% endmacro %}
