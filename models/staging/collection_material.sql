select distinct c.portal_title
              , c.portal_id
              , cm.material_id
from {{ ref('collections') }} c
    join {{ source('wlo-fachportale', 'collection_material') }} cm on c.id = cm.collection_id
    join {{ source('wlo-fachportale', 'materials') }} m on m.id = cm.material_id