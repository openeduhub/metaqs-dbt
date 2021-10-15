{%-
set language_code_map = [
    ('86b990ef-0955-45ad-bdae-ec2623cf0e1a', 'fr'),
    ('11bdb8a0-a9f5-4028-becc-cbf8e328dd4b', 'es'),
    ('15dbd166-fd31-4e01-aabd-524cfa4d2783', 'en-US'),
    ('26105802-9039-4add-bf21-07a0f89f6e70', 'tr'),
]
-%}

{%-
set portal_title_map = [
    ('Deutsch als Zweitsprache', 'DaZ'),
    ('Darstellendes Spiel', 'Darst. Spiel'),
    ('Politische Bildung', 'Pol. Bildung'),
    ('Zeitgemäße Bildung', 'Zeitgm. Bildung'),
    ('Open Educational Resources (OER)', 'OER'),
]
-%}

with processed_collections as (

    select c.id
         , c.path
         , c.doc -> 'properties' ->> 'cm:title'              cm__title
         , c.doc -> 'properties' -> 'ccm:taxonid'            ccm__taxonid
         , c.doc -> 'properties' -> 'ccm:educationalcontext' ccm__educationalcontext
         , c.doc -> 'properties' ->> 'cm:description'        cm__description
         , c.doc -> 'properties' -> 'cclom:general_keyword'  cclom__general_keyword
    from {{ source('wlo-fachportale', 'collections') }} c

), portal_root_path as (

    select c.path || uuid2ltree(c.id) path
         , nlevel(c.path) + 1       nlevel
    from {{ source('wlo-fachportale', 'collections') }} c
    where c.id = '{{ var("portal_root_id") }}'::uuid

), portal_tree as (

     select c.*
          , null    parent_id
          , null    portal_id
          , null    portal_path
          , 0       portal_depth
          , 'de-DE' spellcheck_lang
     from processed_collections c
     where c.id = '{{ var("portal_root_id") }}'::uuid

     union all

     select c.*
          , ltree2uuid(subpath(c.path, -1))         parent_id
          , c.id                                    portal_id
          , subpath(c.path, prp.nlevel - 1)         portal_path
          , nlevel(subpath(c.path, prp.nlevel - 1)) portal_depth
          , case c.id
                {%- for id, language_code in language_code_map %}
                when '{{ id }}'::uuid then '{{ language_code }}'
                {%- endfor %}
                else 'de-DE'
            end                                     spellcheck_lang
     from processed_collections c
        join portal_root_path prp using (path)

     union all

     select c.*
          , ltree2uuid(subpath(c.path, -1))            parent_id
          , ltree2uuid(subpath(c.path, prp.nlevel, 1)) portal_id
          , subpath(c.path, prp.nlevel - 1)            portal_path
          , nlevel(subpath(c.path, prp.nlevel - 1))    portal_depth
          , case
                {%- for id, language_code in language_code_map %}
                when c.path ~ txt2ltxt('*.' || '{{ id }}' || '.*')::lquery then '{{ language_code }}'
                {%- endfor %}
                else 'de-DE'
            end                                        spellcheck_lang
     from processed_collections c
        join portal_root_path prp on c.path <@ prp.path
            and prp.nlevel < nlevel(c.path)

), final as (

    select pt.*
         , coalesce(
            case pc.cm__title
                {%- for title, short_title in portal_title_map %}
                when '{{ title }}' then '{{ short_title }}'
                {%- endfor %}
                else pc.cm__title
            end,
            pc.id::text) portal_title
    from portal_tree pt
        join processed_collections pc on pc.id = pt.portal_id

)

select *
from final
order by portal_depth, id