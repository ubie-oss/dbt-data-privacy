{% macro test_is_column_exposable() %}
  {% set untagged = {
      'name': 'ip',
      'config': {'meta': {'data_privacy': {'level': 'restricted'}}}
    } %}
  {{ assert_equals(dbt_data_privacy.is_column_exposable(untagged), false) }}

  {% set tagged = {
      'name': 'ip',
      'config': {
        'meta': {
          'data_privacy': {
            'level': 'restricted',
            'policy_tags': ['column_exposable']
          }
        }
      }
    } %}
  {{ assert_equals(dbt_data_privacy.is_column_exposable(tagged), true) }}

  {% set legacy = {
      'name': 'ip',
      'meta': {
        'data_privacy': {
          'level': 'restricted',
          'policy_tags': ['column_exposable']
        }
      }
    } %}
  {{ assert_equals(dbt_data_privacy.is_column_exposable(legacy), true) }}

  {% set identifier = {
      'name': 'user_id',
      'config': {
        'meta': {
          'data_privacy': {
            'level': 'confidential',
            'policy_tags': ['unique_identifier']
          }
        }
      }
    } %}
  {{ assert_equals(dbt_data_privacy.is_column_exposable(identifier), false) }}

  {% set both_tags = {
      'name': 'user_id',
      'config': {
        'meta': {
          'data_privacy': {
            'level': 'restricted',
            'policy_tags': ['unique_identifier', 'column_exposable']
          }
        }
      }
    } %}
  {{ assert_equals(dbt_data_privacy.is_column_exposable(both_tags), true) }}

  {% set parent = {
      'name': 'record',
      'config': {
        'meta': {'data_privacy': {'policy_tags': ['column_exposable']}}
      }
    } %}
  {% set child = {
      'name': 'record.ip',
      'config': {'meta': {'data_privacy': {'level': 'restricted'}}}
    } %}
  {{ assert_equals(dbt_data_privacy.is_column_exposable(parent), true) }}
  {{ assert_equals(dbt_data_privacy.is_column_exposable(child), false) }}
{% endmacro %}
