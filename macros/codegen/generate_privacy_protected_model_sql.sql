{% macro generate_privacy_protected_model_sql() %}
  {{- return(adapter.dispatch('generate_privacy_protected_model_sql', 'dbt_data_privacy')(**kwargs)) -}}
{% endmacro %}

{% macro bigquery__generate_privacy_protected_model_sql() %}
  {% set grant_access_to = kwargs.get('grant_access_to') %}

  {%- set model_sql %}
{{'{{'}}
  config(
    {% if grant_access_to -%}
    grant_access_to=[
      {% for x in grant_access_to -%}
      {"project": {{ x.get("project") }}, "dataset": {{ x.get("dataset") }}},
      {% endfor -%}
    ]
    {%- endif %}
  )
{{'}}'}}

SELECT 1
  {% endset %}

  {{- return(model_sql) -}}
{% endmacro %}
