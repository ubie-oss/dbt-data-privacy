{% macro get_test_columns() %}
  {% set test_columns = {
    'user_id': {
      'name': 'user_id',
      'description': 'User ID',
      'meta': {
        'data_privacy': {'level': 'confidential'}
      },
      'data_type': None,
      'quote': None,
      'tags': []
    },
    'pseudonymized_user_id': {
      'name': 'pseudonymized_user_id',
      'description': 'Pseudonymized user ID',
      'meta': {},
      'data_type': None,
      'quote': None,
      'tags': []
    },
    'consent.data_analysis': {
      'name': 'consent.data_analysis',
      'description': 'Consent agree of data analysis',
      'meta': {
        'data_privacy': {'level': 'internal'}
      },
      'data_type': None,
      'quote': None,
      'tags': []
    },
    'consent.data_sharing': {
      'name': 'consent.data_sharing',
      'description': 'Consent agree of data sharing',
      'meta': {
        'data_privacy': {'level': 'confidential'}
      },
      'data_type': None,
      'quote': None, 'tags': []
    },
    'dummy_array': {
      'name': 'dummy_array',
      'description': 'Test array',
      'meta': {
        'data_privacy': {'level': 'confidential'}
      },
      'data_type': 'ARRAY',
      'quote': None,
      'tags': []
    }
  } %}
{% endmacro %}
