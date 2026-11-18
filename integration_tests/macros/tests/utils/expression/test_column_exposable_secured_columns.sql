{% macro test_column_exposable_secured_columns() %}
  {{ return(adapter.dispatch("test_column_exposable_secured_columns", "dbt_data_privacy_integration_tests")()) }}
{% endmacro %}

{% macro bigquery__test_column_exposable_secured_columns() %}
  {% set data_analysis_standards = {
      'internal': {'method': 'RAW'},
      'confidential': {'method': 'SHA256', 'converted_level': 'internal'},
      'restricted': {
        'method': 'CONDITIONAL_HASH',
        'converted_level': 'internal',
        'with': {
          'default_method': 'SHA256',
          'conditions': ['contains_pseudonymized_unique_identifiers']
        }
      }
    } %}
  {% set column_exposure_standards = dbt_data_privacy.deep_copy_dict(data_analysis_standards) %}
  {% do column_exposure_standards['restricted']['with'].update({
      'conditions': ['contains_pseudonymized_unique_identifiers', 'is_column_exposable']
    }) %}
  {% set columns = {
      'user_id': {
        'name': 'user_id',
        'description': 'User ID',
        'config': {
          'meta': {
            'data_privacy': {'level': 'confidential', 'policy_tags': ['unique_identifier']}
          }
        },
        'data_type': None,
        'quote': None,
        'tags': []
      },
      'ip': {
        'name': 'ip',
        'description': 'IP address',
        'config': {
          'meta': {
            'data_privacy': {'level': 'restricted', 'policy_tags': ['column_exposable']}
          }
        },
        'data_type': None,
        'quote': None,
        'tags': []
      },
      'diagnosis': {
        'name': 'diagnosis',
        'description': 'Diagnosis',
        'config': {
          'meta': {'data_privacy': {'level': 'restricted'}}
        },
        'data_type': None,
        'quote': None,
        'tags': []
      }
    } %}

  {% set analysis_result = dbt_data_privacy.get_secured_columns_v2(
      data_handling_standards=data_analysis_standards,
      columns=columns) %}
  {{ assert_equals(
      dbt_data_privacy.get_secured_expression_from_restructured_column(analysis_result['ip']),
      'ip') }}
  {{ assert_equals(
      dbt_data_privacy.get_secured_expression_from_restructured_column(analysis_result['diagnosis']),
      'diagnosis') }}

  {% set exposure_result = dbt_data_privacy.get_secured_columns_v2(
      data_handling_standards=column_exposure_standards,
      columns=columns) %}
  {{ assert_equals(
      dbt_data_privacy.get_secured_expression_from_restructured_column(exposure_result['ip']),
      'ip') }}
  {{ assert_equals(
      dbt_data_privacy.get_secured_expression_from_restructured_column(exposure_result['diagnosis']),
      'SHA256(CAST(diagnosis AS STRING))') }}

  {% set raw_identifier_columns = {
      'user_id': {
        'name': 'user_id',
        'description': 'User ID',
        'config': {
          'meta': {
            'data_privacy': {'level': 'internal', 'policy_tags': ['unique_identifier']}
          }
        },
        'data_type': None,
        'quote': None,
        'tags': []
      },
      'ip': columns['ip'],
      'diagnosis': columns['diagnosis']
    } %}
  {% set raw_identifier_result = dbt_data_privacy.get_secured_columns_v2(
      data_handling_standards=column_exposure_standards,
      columns=raw_identifier_columns) %}
  {{ assert_equals(
      dbt_data_privacy.get_secured_expression_from_restructured_column(raw_identifier_result['ip']),
      'SHA256(CAST(ip AS STRING))') }}
  {{ assert_equals(
      dbt_data_privacy.get_secured_expression_from_restructured_column(raw_identifier_result['diagnosis']),
      'SHA256(CAST(diagnosis AS STRING))') }}

  {% set restricted_identifier_columns = {
      'user_id': {
        'name': 'user_id',
        'description': 'User ID',
        'config': {
          'meta': {
            'data_privacy': {
              'level': 'restricted',
              'policy_tags': ['unique_identifier', 'column_exposable']
            }
          }
        },
        'data_type': None,
        'quote': None,
        'tags': []
      }
    } %}
  {% set restricted_identifier_result = dbt_data_privacy.get_secured_columns_v2(
      data_handling_standards=column_exposure_standards,
      columns=restricted_identifier_columns) %}
  {{ assert_equals(
      dbt_data_privacy.get_secured_expression_from_restructured_column(restricted_identifier_result['user_id']),
      'SHA256(CAST(user_id AS STRING))') }}

  {% set array_struct_columns = {
      'user_id': columns['user_id'],
      'ip': columns['ip'],
      'events': {
        'name': 'events',
        'description': 'Events',
        'config': {'meta': {}},
        'data_type': 'ARRAY',
        'quote': None,
        'tags': []
      },
      'events.ip': {
        'name': 'events.ip',
        'description': 'Event IP',
        'config': {'meta': {'data_privacy': {'level': 'restricted'}}},
        'data_type': None,
        'quote': None,
        'tags': []
      },
      'events.note': {
        'name': 'events.note',
        'description': 'Event note',
        'config': {
          'meta': {
            'data_privacy': {'level': 'restricted', 'policy_tags': ['column_exposable']}
          }
        },
        'data_type': None,
        'quote': None,
        'tags': []
      }
    } %}
  {% set array_struct_result = dbt_data_privacy.get_secured_columns_v2(
      data_handling_standards=column_exposure_standards,
      columns=array_struct_columns) %}
  {{ assert_equals(
      dbt_data_privacy.get_secured_expression_from_restructured_column(array_struct_result['ip']),
      'ip') }}
  {{ assert_equals(
      dbt_data_privacy.get_secured_expression_from_restructured_column(array_struct_result['events']['fields']['ip']),
      'SHA256(CAST(ip AS STRING))') }}
  {{ assert_equals(
      dbt_data_privacy.get_secured_expression_from_restructured_column(array_struct_result['events']['fields']['note']),
      'note') }}
{% endmacro %}
