with agg as (

    select cm.portal_title
         , cm.portal_id
         , count(distinct m.id)
           filter ( where m.ccm__commonlicense_key is null )               null_count_license
         , count(distinct m.id)
           filter ( where m.ccm__educationalcontext is null )              null_count_educontext
         , count(distinct m.id)
           filter ( where m.ccm__educationallearningresourcetype is null ) null_count_learningresourcetype
         , count(distinct m.id)
           filter ( where m.cclom__general_keyword is null )               null_count_keyword
         , count(distinct m.id)
           filter ( where m.cclom__general_description is null )           null_count_description
         , count(distinct m.id)
           filter ( where m.ccm__taxonid is null )                         null_count_taxonid
         , count(distinct m.id)                                            total
    {{ cm_join_m() }}
    group by cm.portal_title, cm.portal_id

), stack as (

     select agg.portal_title
          , agg.portal_id
          , unnest(array [
         'License'
         , 'EduContext'
         , 'LearningResourceType'
         , 'Keyword'
         , 'Description'
         , 'TaxonId'
         ]) field
          , unnest(array [
         agg.null_count_license
         , agg.null_count_educontext
         , agg.null_count_learningresourcetype
         , agg.null_count_keyword
         , agg.null_count_description
         , agg.null_count_taxonid
         ]) null_count
          , agg.total
     from agg
)

select stack.*
     , {{ proportion('stack.null_count', 'stack.total') }} null_proportion
from stack
