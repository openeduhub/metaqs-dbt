select c.portal_title
     , c.portal_id
     , c.id collection_id
     , empty_str2sentinel(
        lower(jsonb_array_elements_text(c.cclom__general_keyword)),
        '<EMPTY>'::text
       )    val
from {{ ref('collections') }} c
