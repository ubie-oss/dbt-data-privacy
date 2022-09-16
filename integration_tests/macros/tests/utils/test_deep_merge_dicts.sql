{% macro test_deep_merge_dicts() %}
  {% set base_dict = {
    "x": 1,
    "z": 3,
  } %}
  {% set updating_dict = {
    "x": 2,
    "y": 2,
  } %}
  {% set result = dbt_data_privacy.deep_merge_dicts(base_dict, updating_dict) %}
  {% set expected = {
    "x": 2,
    "y": 2,
    "z": 3,
  } %}
  {{ assert_dict_equals(result, expected) }}

  {% set base_dict = {
    "x": 1,
    "y": {
      "ya": 2,
      },
  }%}
  {% set updating_dict = {
    "x": [11, 12],
    "y": {
      "yb": {
        "ybb": 14,
      },
    },
  } %}
  {% set result = dbt_data_privacy.deep_merge_dicts(base_dict, updating_dict) %}
  {% set expected = {'x': [11, 12], 'y': {'ya': 2, 'yb': {'ybb': 14}}} %}
  {{ assert_dict_equals(result, expected) }}

  {% set base_dict = {
    "x": 1,
    "z": {
      "za": {
        "zaa": 3
        },
      "zb": {
        "zbb": {
          "zbbb" : 4
        }
        }
      }
  } %}
  {% set updating_dict = {
    "x": [11, 12],
    "z": {
      "zb": {
        "zbb": {
          "zbbb" : {
            "zbbbb": 16
          }
        }
        }
      }
  } %}
  {% set result = dbt_data_privacy.deep_merge_dicts(base_dict, updating_dict) %}
  {% set expected = {'x': [11, 12], 'z': {'za': {'zaa': 3}, 'zb': {'zbb': {'zbbb': {'zbbbb': 16}}}}} %}
  {{ assert_dict_equals(result, expected) }}
{% endmacro %}
