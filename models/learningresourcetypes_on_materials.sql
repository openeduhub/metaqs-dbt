with stack as (

    select cm.*
         , empty_str2sentinel(
            shorten_vocab(
                jsonb_array_elements_text(null2jsonb_array(m.ccm__educationallearningresourcetype)),
                'learningResourceType'::text
            ),
            '<EMPTY>'::text
        ) val
    {{ cm_join_m() }}

), stats as (

    select st.*
         , ((count(st.val) over (partition by st.portal_id, st.val))::float /
            (count(st.val) over (partition by st.portal_id))) val_proportion_portal
    from stack st

), final as (

    select stats.*
         , case
               when stats.val is null then stats.val
               when stats.val_proportion_portal < .05 then '<5%'
               else stats.val
           end val_condensed_portal
    from stats

)

select *
from final
