{% macro create_functions() %}
{% set sql %}

create schema if not exists {{ target.schema }};


-- helper functions


create or replace function public.txt2ltxt(_txt text)
    returns text
    language sql as
$$
select replace(_txt, '-', '_')
$$;


create or replace function public.txt2ltxt(_txt text)
    returns text
    language sql as
$$
select replace(_txt, '-', '_')
$$;


create or replace function public.ltxt2txt(_ltxt text)
    returns text
    language sql as
$$
select replace(_ltxt, '_', '-')
$$;


create or replace function public.uuid2ltree(_uuid uuid)
    returns ltree
    language sql as
$$
select replace(_uuid::text, '-', '_')::ltree
$$;


create or replace function public.ltree2uuid(_ltree ltree)
    returns uuid
    language sql as
$$
select replace(ltree2text(_ltree), '_', '-')::uuid
$$;


create or replace function public.ltree2uuids(_path ltree)
    returns uuid[]
    language sql as
$$
select string_to_array(replace(ltree2text(_path), '_', '-'), '.')::uuid[]
$$;


create or replace function public.empty_str2sentinel(_value text, _sentinel text)
    returns text
    language sql as
$$
select regexp_replace(
               _value,
               '^[\s\\n]*$',
               _sentinel
           );
$$;


create or replace function public.shorten_vocab(_value text, _vocab_type text)
    returns text
    language sql as
$$
select regexp_replace(
               _value,
               '^https?://w3id.org/openeduhub/vocabs/' || _vocab_type || '/',
               ''
           );
$$;


create or replace function public.null2jsonb_array(_value jsonb)
    returns jsonb
    language sql as
$$
select coalesce(_value, ('[' || '"fehlend"' || ']')::jsonb);
$$;

{% endset %}
{% do run_query(sql) %}
{% do log("Postgres helper functions created.", info=True) %}
{% endmacro %}
