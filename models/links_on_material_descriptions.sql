{%-
set whitelisted_domains = [
    'commons.wikimedia.org',
    'creativecommons.org',
]
-%}

with descriptions as (

    select cm.*
         , m.ccm__replicationsource
         , jsonb_array_elements_text(m.cclom__general_description) description
    {{ cm_join_m() }}

), hits as (

    select d.*
         , unnest(regexp_matches(d.description, 'https?://[^\s]+', 'g')) m
    from descriptions d

), processed_hits as (

    select h.*
         , replace(unnest(regexp_match(h.m, 'https?://([^/]+)')), 'www.', '') tld
    from hits h
    where h.m is not null

), final as (

    select h.*
    from processed_hits h
    where not (h.tld = any (array [
        {%- for tld in whitelisted_domains %}
        '{{ tld }}'{% if not loop.last %},{% endif -%}
        {% endfor %}
    ]))

)

select *
from final
