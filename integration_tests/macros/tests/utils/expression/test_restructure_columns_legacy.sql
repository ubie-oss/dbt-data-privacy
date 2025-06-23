{% macro test_restructure_columns_legacy() %}
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
      'original_info': {
        'name': 'user_id',
        'description': 'User ID',
        'meta': {'data_privacy': {'level': 'confidential'}},
        'data_type': None,
        'quote': None,
        'tags': []
      },
      'additional_info': {}
    },
    'consent': {
      'fields': {
        'data_analysis': {
          'original_info': {
            'name': 'consent.data_analysis',
            'description': 'Consent agree of data analysis',
            'meta': {'data_privacy': {'level': 'internal'}},
            'data_type': None,
            'quote': None,
            'tags': []
          },
          'additional_info': {}
        },
        'data_sharing': {
          'original_info': {
            'name': 'consent.data_sharing',
            'description': 'Consent agree of data sharing',
            'meta': {'data_privacy': {'level': 'confidential'}},
            'data_type': None,
            'quote': None,
            'tags': []
          },
          'additional_info': {}
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
      'original_info': {
        'name': 'user_id',
        'description': 'User ID',
        'meta': {'data_privacy': {'level': 'confidential'}},
        'data_type': None,
        'quote': None,
        'tags': []
      },
      'additional_info': {}
    },
    'consent': {
      'original_info': {
        'meta': {},
        'data_type': 'ARRAY',
        'quote': None,
        'tags': []
      },
      'additional_info': {},
      'fields': {
        'data_analysis': {
          'original_info': {
            'name': 'consent.data_analysis',
            'description': 'Consent agree of data analysis',
            'meta': {'data_privacy': {'level': 'internal'}},
            'data_type': None,
            'quote': None,
            'tags': []
          },
          'additional_info': {}
        },
        'data_sharing': {
          'original_info': {
            'name': 'consent.data_sharing',
            'description': 'Consent agree of data sharing',
            'meta': {'data_privacy': {'level': 'confidential'}},
            'data_type': None,
            'quote': None,
            'tags': []
          },
          'additional_info': {}
        }
      }
    }
  } %}
  {{ assert_dict_equals(result, expected) }}
{% endmacro %}
