with agg as (

    select c.portal_title
         , c.portal_id
         , count(distinct c.id)
           filter ( where c.ccm__educationalcontext is null ) null_count_educontext
         , count(distinct c.id)
           filter ( where c.cclom__general_keyword is null )  null_count_keyword
         , count(distinct c.id)
           filter ( where c.cm__description is null )         null_count_description
         , count(distinct c.id)
           filter ( where c.ccm__taxonid is null )            null_count_taxonid
         , count(distinct c.id)                               total
    from {{ ref('collections') }} c
    group by c.portal_title, c.portal_id

), stack as (

     select agg.portal_title
          , agg.portal_id
          , unnest(array [
         'EduContext'
         , 'Keyword'
         , 'Description'
         , 'TaxonId'
         ]) field
          , unnest(array [
         agg.null_count_educontext
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
