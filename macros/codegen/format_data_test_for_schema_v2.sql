{% macro _normalize_data_test_for_schema_v2(data_test) %}
  {%- if data_test is string or data_test is not mapping -%}
    {{- return(none) -}}
  {%- endif -%}

  {%- set test_names = data_test.keys() | list -%}
  {%- if test_names | length != 1 -%}
    {{- return(none) -}}
  {%- endif -%}

  {%- set test_name = test_names[0] -%}
  {%- set test_config = data_test[test_name] -%}
  {%- if test_config is not mapping -%}
    {{- return(none) -}}
  {%- endif -%}

  {#- Top-level keys treated as test config, not macro arguments -#}
  {%- set config_keys = ['tags', 'severity', 'where'] -%}
  {%- set ns = namespace(config={}, arguments={}, name=none) -%}

  {%- if test_config.get('arguments') is mapping -%}
    {%- set ns.arguments = dbt_data_privacy.deep_copy_dict(test_config.arguments) -%}
    {%- if test_config.get('config') is mapping -%}
      {%- set ns.config = dbt_data_privacy.deep_copy_dict(test_config.config) -%}
    {%- endif -%}
    {%- if test_config.get('name') is not none -%}
      {%- set ns.name = test_config.name -%}
    {%- endif -%}
    {%- for key in config_keys -%}
      {%- if key in test_config and key not in ns.config -%}
        {%- do ns.config.update({key: test_config[key]}) -%}
      {%- endif -%}
    {%- endfor -%}
    {%- for key, value in test_config.items() -%}
      {%- if key in ['config', 'name', 'arguments'] or key in config_keys -%}
        {# already handled #}
      {%- elif key not in ns.arguments -%}
        {%- do ns.arguments.update({key: value}) -%}
      {%- endif -%}
    {%- endfor -%}
  {%- else -%}
    {%- if test_config.get('config') is mapping -%}
      {%- set ns.config = dbt_data_privacy.deep_copy_dict(test_config.config) -%}
    {%- endif -%}
    {%- if test_config.get('name') is not none -%}
      {%- set ns.name = test_config.name -%}
    {%- endif -%}
    {%- for key, value in test_config.items() -%}
      {%- if key == 'config' -%}
        {# already handled #}
      {%- elif key == 'name' -%}
        {# already handled #}
      {%- elif key in config_keys -%}
        {%- do ns.config.update({key: value}) -%}
      {%- elif key != 'arguments' -%}
        {%- do ns.arguments.update({key: value}) -%}
      {%- endif -%}
    {%- endfor -%}
  {%- endif -%}

  {{- return({
      'test_name': test_name,
      'config': ns.config,
      'arguments': ns.arguments,
      'name': ns.name,
    }) -}}
{% endmacro %}

{% macro _build_modern_data_test(test_name, config, arguments, name=none) %}
  {%- set formatted_test = {} -%}
  {%- if name is not none -%}
    {%- do formatted_test.update({'name': name}) -%}
  {%- endif -%}
  {%- if config | length > 0 -%}
    {%- do formatted_test.update({'config': config}) -%}
  {%- endif -%}
  {%- if arguments | length > 0 -%}
    {%- do formatted_test.update({'arguments': arguments}) -%}
  {%- endif -%}
  {{- return({test_name: formatted_test}) -}}
{% endmacro %}

{% macro _build_legacy_data_test(test_name, config, arguments, name=none) %}
  {%- set formatted_test = {} -%}
  {%- if name is not none -%}
    {%- do formatted_test.update({'name': name}) -%}
  {%- endif -%}
  {%- do formatted_test.update(arguments) -%}
  {%- if config | length > 0 -%}
    {%- do formatted_test.update({'config': config}) -%}
  {%- endif -%}
  {{- return({test_name: formatted_test}) -}}
{% endmacro %}

{% macro format_data_test_for_schema_v2(data_test) %}
  {%- set normalized = dbt_data_privacy._normalize_data_test_for_schema_v2(data_test) -%}
  {%- if normalized is none -%}
    {{- return(data_test) -}}
  {%- endif -%}

  {%- if dbt_data_privacy.is_dbt_at_least('1.10.5') -%}
    {{- return(dbt_data_privacy._build_modern_data_test(
        normalized.test_name,
        normalized.config,
        normalized.arguments,
        normalized.name
      )) -}}
  {%- else -%}
    {{- return(dbt_data_privacy._build_legacy_data_test(
        normalized.test_name,
        normalized.config,
        normalized.arguments,
        normalized.name
      )) -}}
  {%- endif -%}
{% endmacro %}
