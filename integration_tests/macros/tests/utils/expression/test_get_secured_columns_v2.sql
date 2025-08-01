{% macro test_get_secured_columns_v2() %}
  {{ return(adapter.dispatch("test_get_secured_columns_v2", "dbt_data_privacy_integration_tests")()) }}
{% endmacro %}

{% macro bigquery__test_get_secured_columns_v2() %}
  {% set data_handling_standards = get_test_data_handling_standards() %}
  {% set columns = {
    'struct1': {
      'name': 'struct1',
      'description': '',
      'config': {
        'meta': {
          'data_privacy': {'alias': 'aliased_struct1'}
        },
      },
      'data_type': None,
      'quote': None,
      'tags': []
    },
    'struct1.x': {
      'name': 'struct1.x',
      'description': '',
      'config': {
        'meta': {
          'data_privacy': {'level': 'confidential', 'alias': 'aliased_x'}
        },
      },
      'data_type': None,
      'quote': None,
      'tags': []
    },
    'struct1.y': {
      'name': 'struct1.y',
      'description': '',
      'config': {
        'meta': {
          'data_privacy': {'level': 'internal', 'alias': 'aliased_y'}
        },
      },
      'data_type': None,
      'quote': None,
      'tags': []
    },
    'array1': {
      'name': 'array1',
      'description': '',
      'config': {
        'meta': {},
      },
      'data_type': "ARRAY",
      'quote': None,
      'tags': []
    },
    'array1.x': {
      'name': 'array1.x',
      'description': '',
      'config': {
        'meta': {
          'data_privacy': {'level': 'confidential', 'alias': 'aliased_array1_x'}
        },
      },
      'data_type': "ARRAY",
      'quote': None,
      'tags': []
    },
    'array1.y': {
      'name': 'array1.y',
      'description': '',
      'config': {
        'meta': {
          'data_privacy': {'level': 'confidential'}
        },
      },
      'data_type': None,
      'quote': None,
      'tags': []
    },
    'array1.z': {
      'name': 'array1.z',
      'description': '',
      'config': {
        'meta': {
          'data_privacy': {'level': 'internal'}
        },
      },
      'data_type': None,
      'quote': None,
      'tags': []
    },
  } %}

  {% set result = dbt_data_privacy.get_secured_columns_v2(
      data_handling_standards=data_handling_standards,
      columns=columns
    ) %}
  {% set expected = {
    "struct1": {
      "original_info": {
        'name': 'struct1',
        'description': '',
        'config': {
          'meta': {
            'data_privacy': {'alias': 'aliased_struct1'}
          },
        },
        'data_type': None,
        'quote': None,
        'tags': []
      },
      "fields": {
        "x": {
          "original_info": {
            "name": "struct1.x",
            "description": "",
            "config": {
              "meta": {
                "data_privacy": {
                  "level": "confidential",
                  "alias": "aliased_x"
                }
              }
            },
            "data_type": none,
            "quote": none,
            "tags": []
          },
          "additional_info": {
            "relative_path": [
              "struct1",
              "x"
            ],
            "secured_expression": "SHA256(CAST(struct1.x AS STRING))",
            "level": "internal",
            "alias": "aliased_x"
          }
        },
        "y": {
          "original_info": {
            "name": "struct1.y",
            "description": "",
            "config": {
              "meta": {
                "data_privacy": {
                  "level": "internal",
                  "alias": "aliased_y"
                }
              }
            },
            "data_type": none,
            "quote": none,
            "tags": []
          },
          "additional_info": {
            "relative_path": [
              "struct1",
              "y"
            ],
            "secured_expression": "struct1.y",
            "level": "internal",
            "alias": "aliased_y"
          }
        }
      },
      "additional_info": {
        "relative_path": [
          "struct1"
        ],
        "alias": "aliased_struct1"
      }
    },
    "array1": {
      "original_info": {
        "name": "array1",
        "description": "",
        "config": {
          "meta": {},
        },
        "data_type": "ARRAY",
        "quote": none,
        "tags": []
      },
      "additional_info": {
        "relative_path": [
          "array1"
        ]
      },
      "fields": {
        "x": {
          "original_info": {
            "name": "array1.x",
            "description": "",
            "config": {
              "meta": {
                "data_privacy": {
                  "level": "confidential",
                  "alias": "aliased_array1_x"
                }
              }
            },
            "data_type": "ARRAY",
            "quote": none,
            "tags": []
          },
          "additional_info": {
            "relative_path": [
              "x"
            ],
            "secured_expression": "ARRAY(SELECT SHA256(CAST(e AS STRING)) FROM UNNEST(x) AS e)",
            "level": "internal",
            "alias": "aliased_array1_x"
          }
        },
        "y": {
          "original_info": {
            "name": "array1.y",
            "description": "",
            "config": {
              "meta": {
                "data_privacy": {
                  "level": "confidential"
                }
              }
            },
            "data_type": none,
            "quote": none,
            "tags": []
          },
          "additional_info": {
            "relative_path": [
              "y"
            ],
            "secured_expression": "SHA256(CAST(y AS STRING))",
            "level": "internal"
          }
        },
        "z": {
          "original_info": {
            "name": "array1.z",
            "description": "",
            "config": {
              "meta": {
                "data_privacy": {
                  "level": "internal"
                }
              }
            },
            "data_type": none,
            "quote": none,
            "tags": []
          },
          "additional_info": {
            "relative_path": [
              "z"
            ],
            "secured_expression": "z",
            "level": "internal"
          }
        }
      }
    }
  } %}
  {{ assert_dict_equals(result, expected) }}


  {% set columns = {
    'struct1.x': {
      'name': 'struct1.x',
      'description': '',
      'config': {
        'meta': {
          'data_privacy': {'level': 'confidential'}
        },
      },
      'data_type': None,
      'quote': None,
      'tags': []
    },
    'struct1.struct2.x': {
      'name': 'struct1.struct11.scalar111',
      'description': '',
      'config': {
        'meta': {
          'data_privacy': {'level': 'confidential'}
        },
      },
      'data_type': None,
      'quote': None,
      'tags': []
    },
    'struct1.struct11.array111': {
      'name': 'struct1.struct11.array111',
      'description': '',
      'config': {
        'meta': {
          'data_privacy': {'level': 'confidential'}
        },
      },
      'data_type': "ARRAY",
      'quote': None,
      'tags': []
    },
    'struct1.array1': {
      'name': 'struct1.array1',
      'description': '',
      'config': {
        'meta': {},
      },
      'data_type': "ARRAY",
      'quote': None,
      'tags': []
    },
    'struct1.array1.scalar1': {
      'name': 'struct1.array1.scalar1',
      'description': '',
      'config': {
        'meta': {
          'data_privacy': {'level': 'internal'}
        },
      },
      'data_type': None,
      'quote': None,
      'tags': []
    },
    'struct1.array1.struct2.x': {
      'name': 'struct1.y',
      'description': '',
      'config': {
        'meta': {
          'data_privacy': {'level': 'confidential'}
        },
      },
      'data_type': "ARRAY",
      'quote': None,
      'tags': []
    },
  } %}
  {% set result = dbt_data_privacy.get_secured_columns_v2(
      data_handling_standards=data_handling_standards,
      columns=columns
    ) %}
  {% set expected = {
    "struct1": {
      "fields": {
        "x": {
          "original_info": {
            "name": "struct1.x",
            "description": "",
            "config": {
              "meta": {
                "data_privacy": {
                  "level": "confidential"
                }
              }
            },
            "data_type": none,
            "quote": none,
            "tags": []
          },
          "additional_info": {
            "relative_path": [ "struct1", "x" ],
            "secured_expression": "SHA256(CAST(struct1.x AS STRING))",
            "level": "internal"
          }
        },
        "struct2": {
          "fields": {
            "x": {
              "original_info": {
                "name": "struct1.struct11.scalar111",
                "description": "",
                "config": {
                  "meta": {
                    "data_privacy": {
                      "level": "confidential"
                    }
                  }
                },
                "data_type": none,
                "quote": none,
                "tags": []
              },
              "additional_info": {
                "relative_path": ["struct1", "struct2", "x"],
                "secured_expression": "SHA256(CAST(struct1.struct2.x AS STRING))",
                "level": "internal"
              }
            }
          },
          "additional_info": {
            "relative_path": [ "struct1", "struct2" ]
          }
        },
        "struct11": {
          "fields": {
            "array111": {
              "original_info": {
                "name": "struct1.struct11.array111",
                "description": "",
                "config": {
                  "meta": {
                    "data_privacy": {
                      "level": "confidential"
                    }
                  }
                },
                "data_type": "ARRAY",
                "quote": none,
                "tags": []
              },
              "additional_info": {
                "relative_path": [ "struct1", "struct11", "array111" ],
                "secured_expression": "ARRAY(SELECT SHA256(CAST(e AS STRING)) FROM UNNEST(struct1.struct11.array111) AS e)",
                "level": "internal"
              }
            }
          },
          "additional_info": {
            "relative_path": [ "struct1", "struct11" ]
          }
        },
        "array1": {
          "original_info": {
            "name": "struct1.array1",
            "description": "",
            "config": {
              "meta": {},
            },
            "data_type": "ARRAY",
            "quote": none,
            "tags": []
          },
          "additional_info": {
            "relative_path": [ "struct1", "array1" ]
          },
          "fields": {
            "scalar1": {
              "original_info": {
                "name": "struct1.array1.scalar1",
                "description": "",
                "config": {
                  "meta": {
                    "data_privacy": {
                      "level": "internal"
                    }
                  }
                },
                "data_type": none,
                "quote": none,
                "tags": []
              },
              "additional_info": {
                "relative_path": [ "scalar1" ],
                "secured_expression": "scalar1",
                "level": "internal"
              }
            },
            "struct2": {
              "fields": {
                "x": {
                  "original_info": {
                    "name": "struct1.y",
                    "description": "",
                    "config": {
                      "meta": {
                        "data_privacy": {
                          "level": "confidential"
                        }
                      }
                    },
                    "data_type": "ARRAY",
                    "quote": none,
                    "tags": []
                  },
                  "additional_info": {
                    "relative_path": [ "struct2", "x" ],
                    "secured_expression": "ARRAY(SELECT SHA256(CAST(e AS STRING)) FROM UNNEST(struct2.x) AS e)",
                    "level": "internal"
                  }
                }
              },
              "additional_info": { "relative_path": [ "struct2" ] }
            }
          }
        }
      },
      "additional_info": { "relative_path": [ "struct1" ] }
    }
  }
   %}
  {{ assert_dict_equals(result, expected) }}
{% endmacro %}
