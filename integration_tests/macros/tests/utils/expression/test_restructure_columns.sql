{% macro test_restructure_columns() %}
  {% set columns = {
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
  } %}
  {% set result = dbt_data_privacy.restructure_columns(columns) %}
  {% set expected = {
    'user_id': {
      'name': 'user_id',
      'description': 'User ID',
      'meta': {'data_privacy': {'level': 'confidential'}},
      'data_type': None,
      'quote': None,
      'tags': []
    },
    'consent': {
      'fields': {
        'data_analysis': {
          'name': 'consent.data_analysis',
          'description': 'Consent agree of data analysis',
          'meta': {'data_privacy': {'level': 'internal'}},
          'data_type': None,
          'quote': None,
          'tags': []
        },
        'data_sharing': {
          'name': 'consent.data_sharing',
          'description': 'Consent agree of data sharing',
          'meta': {'data_privacy': {'level': 'confidential'}},
          'data_type': None,
          'quote': None,
          'tags': []
        }
      }
    }
  } %}
  {{ assert_dict_equals(result, expected) }}

  {% set columns = {
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
    'consent': {
      'meta': {},
      'data_type': "ARRAY",
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
  } %}
  {% set result = dbt_data_privacy.restructure_columns(columns) %}
  {% set expected = {
    'user_id': {
      'name': 'user_id',
      'description': 'User ID',
      'meta': {'data_privacy': {'level': 'confidential'}},
      'data_type': None,
      'quote': None,
      'tags': []
    },
    'consent': {
      'meta': {},
      'data_type': 'ARRAY',
      'quote': None,
      'tags': [],
      'fields': {
        'data_analysis': {
          'name': 'consent.data_analysis',
          'description': 'Consent agree of data analysis',
          'meta': {'data_privacy': {'level': 'internal'}},
          'data_type': None,
          'quote': None,
          'tags': []
        },
        'data_sharing': {
          'name': 'consent.data_sharing',
          'description': 'Consent agree of data sharing',
          'meta': {'data_privacy': {'level': 'confidential'}},
          'data_type': None,
          'quote': None,
          'tags': []
        }
      }
    }
  } %}
  {{ assert_dict_equals(result, expected) }}
{% endmacro %}
