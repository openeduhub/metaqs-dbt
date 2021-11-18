{% macro clear_state_store() %}

{% set sql %}
truncate {{ source('languagetool', 'spellcheck') }};
{% endset %}

{% do run_query(sql) %}
{% do log("Store state cleared by truncating tables", info=True) %}

{% endmacro %}
