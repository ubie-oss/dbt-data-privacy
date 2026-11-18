{#
  Bounded exhaustive check of two privacy invariants on the real restructure path.

  Scope: every assignment of {public, confidential, restricted, none} to six leaf
  columns covering a scalar, a struct, an array of structs, and a scalar array.
  Run: dbt run-operation verify_privacy_invariants

  Invariants (oracle written from the policy table, not from the macros):
    P1 no raw leak: a confidential or restricted leaf never appears raw in the SQL.
    P4 level truth: the level of a kept leaf is the converted level its expression provides.
#}

{% macro _privacy_invariant_leaves() %}
  {{ return([
    {'name': 'c_one', 'data_type': none, 'path': ['c_one'], 'alias': 'c_one', 'token': 'c_one'},
    {'name': 's.s_x', 'data_type': none, 'path': ['s', 'fields', 's_x'], 'alias': 's_x', 'token': 's.s_x'},
    {'name': 's.s_y', 'data_type': none, 'path': ['s', 'fields', 's_y'], 'alias': 's_y', 'token': 's.s_y'},
    {'name': 'arr.arr_x', 'data_type': none, 'path': ['arr', 'fields', 'arr_x'], 'alias': 'arr_x', 'token': 'arr_x'},
    {'name': 'arr.arr_y', 'data_type': none, 'path': ['arr', 'fields', 'arr_y'], 'alias': 'arr_y', 'token': 'arr_y'},
    {'name': 'tags', 'data_type': 'ARRAY', 'path': ['tags'], 'alias': 'tags', 'token': 'tags'},
  ]) }}
{% endmacro %}

{# The hash the oracle expects for a confidential leaf. Written here, not taken from sha256(), so the check does not compare the product with itself. #}
{% macro _privacy_hash_expression(leaf) %}
  {% if leaf.data_type == 'ARRAY' %}
    {{ return('ARRAY(SELECT SHA256(CAST(e AS STRING)) FROM UNNEST(' ~ leaf.token ~ ') AS e)') }}
  {% endif %}
  {{ return('SHA256(CAST(' ~ leaf.token ~ ' AS STRING))') }}
{% endmacro %}

{% macro _privacy_invariant_columns(levels, leaves) %}
  {% set columns = {
    's': {'name': 's', 'description': '', 'config': {'meta': {}}, 'data_type': none, 'quote': none, 'tags': []},
    'arr': {'name': 'arr', 'description': '', 'config': {'meta': {}}, 'data_type': 'ARRAY', 'quote': none, 'tags': []},
  } %}
  {% for leaf in leaves %}
    {% set meta = {} %}
    {% if levels[loop.index0] is not none %}
      {% do meta.update({'data_privacy': {'level': levels[loop.index0]}}) %}
    {% endif %}
    {% do columns.update({leaf.name: {
      'name': leaf.name,
      'description': '',
      'config': {'meta': meta},
      'data_type': leaf.data_type,
      'quote': none,
      'tags': [],
    }}) %}
  {% endfor %}
  {{ return(columns) }}
{% endmacro %}

{#
  Direct cases for the methods that the fixture standards do not use.
  Each case is {method, with_params, column_conditions, expected}. Raw output
  (expected == column name) is allowed only when a condition is explicitly true.
#}
{% macro _verify_privacy_method_cases() %}
  {% set cases = [
    {'method': 'SHA512', 'with_params': none, 'column_conditions': none, 'expected': 'SHA512(CAST(c AS STRING))'},
    {'method': 'UDF_HASH', 'with_params': {'function': 'MY_UDF'}, 'column_conditions': none, 'expected': 'MY_UDF(CAST(c AS STRING))'},
    {'method': 'CONDITIONAL_HASH', 'with_params': {'default_method': 'SHA256', 'conditions': []}, 'column_conditions': {'k': true}, 'expected': 'SHA256(CAST(c AS STRING))'},
    {'method': 'CONDITIONAL_HASH', 'with_params': {'default_method': 'SHA256', 'conditions': ['k']}, 'column_conditions': {'k': true}, 'expected': 'c'},
    {'method': 'CONDITIONAL_HASH', 'with_params': {'default_method': 'SHA256', 'conditions': ['k']}, 'column_conditions': {'k': false}, 'expected': 'SHA256(CAST(c AS STRING))'},
    {'method': 'CONDITIONAL_HASH', 'with_params': {'default_method': 'SHA256', 'conditions': ['k']}, 'column_conditions': {'k': none}, 'expected': 'SHA256(CAST(c AS STRING))'},
  ] %}
  {% for case in cases %}
    {% set actual = dbt_data_privacy.get_secured_expression_by_method('c', case.method, column_conditions=case.column_conditions, with_params=case.with_params) %}
    {% if actual != case.expected %}
      {% do exceptions.raise_compiler_error("FAILED P1/method: " ~ case.method ~ " with " ~ case.with_params ~ " and " ~ case.column_conditions ~ " expected " ~ case.expected ~ " got " ~ actual) %}
    {% endif %}
  {% endfor %}
{% endmacro %}

{% macro verify_privacy_invariants() %}
  {% do _verify_privacy_method_cases() %}
  {% set standards = get_test_data_handling_standards() %}
  {% set leaves = _privacy_invariant_leaves() %}
  {% set choices = ['public', 'confidential', 'restricted', none] %}
  {% set total = (choices | length) ** (leaves | length) %}

  {% for i in range(total) %}
    {% set ns = namespace(rest=i) %}
    {% set levels = [] %}
    {% for leaf in leaves %}
      {% do levels.append(choices[ns.rest % (choices | length)]) %}
      {% set ns.rest = ns.rest // (choices | length) %}
    {% endfor %}

    {% set columns = _privacy_invariant_columns(levels, leaves) %}
    {% set restructured = dbt_data_privacy.get_secured_columns_v2(standards, columns) %}

    {# P4 and expression-level P1, per leaf #}
    {% for leaf in leaves %}
      {% set level = levels[loop.index0] %}
      {% set nav = namespace(node=restructured) %}
      {% for key in leaf.path %}
        {% set nav.node = nav.node[key] %}
      {% endfor %}
      {% set info = nav.node.get('additional_info', {}) %}
      {% set secured = info.get('secured_expression') %}
      {% set hash_fn = _privacy_hash_expression(leaf) %}

      {% if level == 'public' %}
        {% if secured != leaf.token %}
          {% do exceptions.raise_compiler_error("FAILED P1/expr: public leaf " ~ leaf.name ~ " expected raw " ~ leaf.token ~ " got " ~ secured ~ " for levels " ~ levels) %}
        {% endif %}
        {% if info.get('level') != 'public' %}
          {% do exceptions.raise_compiler_error("FAILED P4: public leaf " ~ leaf.name ~ " should carry converted level public, got " ~ info.get('level') ~ " for levels " ~ levels) %}
        {% endif %}
      {% elif level == 'confidential' %}
        {% if secured != hash_fn %}
          {% do exceptions.raise_compiler_error("FAILED P1/expr: confidential leaf " ~ leaf.name ~ " expected " ~ hash_fn ~ " got " ~ secured ~ " for levels " ~ levels) %}
        {% endif %}
        {% if info.get('level') != 'internal' %}
          {% do exceptions.raise_compiler_error("FAILED P4: confidential leaf " ~ leaf.name ~ " should carry converted level internal, got " ~ info.get('level') ~ " for levels " ~ levels) %}
        {% endif %}
      {% else %}
        {% if secured is not none %}
          {% do exceptions.raise_compiler_error("FAILED P1/expr: " ~ (level or 'unlabeled') ~ " leaf " ~ leaf.name ~ " must not produce an expression, got " ~ secured ~ " for levels " ~ levels) %}
        {% endif %}
      {% endif %}
    {% endfor %}

    {# P1 on final SQL, per top-level column #}
    {% set sql_parts = [] %}
    {% for top_key, top_column in restructured.items() %}
      {% set column_sql = dbt_data_privacy.convert_restructured_column_to_expression(top_key, top_column) %}
      {% if column_sql is not none %}
        {% do sql_parts.append(column_sql) %}
      {% endif %}
    {% endfor %}
    {% set sql_text = sql_parts | join('\n') %}

    {% for leaf in leaves %}
      {% set level = levels[loop.index0] %}
      {% if level == 'confidential' %}
        {% set hash_fn = _privacy_hash_expression(leaf) %}
        {% set remainder = sql_text.replace(hash_fn, '').replace('AS `' ~ leaf.alias ~ '`', '') %}
        {% if leaf.token in remainder %}
          {% do exceptions.raise_compiler_error("FAILED P1/sql: raw " ~ leaf.token ~ " leaks outside its hash in SQL for levels " ~ levels ~ "\n" ~ sql_text) %}
        {% endif %}
      {% elif level == 'restricted' or level is none %}
        {% if leaf.token in sql_text %}
          {% do exceptions.raise_compiler_error("FAILED P1/sql: " ~ (level or 'unlabeled') ~ " leaf " ~ leaf.token ~ " appears in SQL for levels " ~ levels ~ "\n" ~ sql_text) %}
        {% endif %}
      {% endif %}
    {% endfor %}
  {% endfor %}

  {% do log("SUCCESS: P1 and P4 hold for all " ~ total ~ " level assignments", info=true) %}
{% endmacro %}
