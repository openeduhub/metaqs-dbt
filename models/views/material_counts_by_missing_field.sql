select cm.collection_id
     , count(distinct cm.material_id)
       filter ( where f.missing_field = 'title' )                 title
     , count(distinct cm.material_id)
       filter ( where f.missing_field = 'description' )           description
     , count(distinct cm.material_id)
       filter ( where f.missing_field = 'keywords' )              keywords
     , count(distinct cm.material_id)
       filter ( where f.missing_field = 'license' )               license
     , count(distinct cm.material_id)
       filter ( where f.missing_field = 'taxon_id' )              taxon_id
     , count(distinct cm.material_id)
       filter ( where f.missing_field = 'edu_context' )           edu_context
     , count(distinct cm.material_id)
       filter ( where f.missing_field = 'learning_resource_type' ) learning_resource_type
     , count(distinct cm.material_id)
       filter ( where f.missing_field = 'ads_qualifier' )         ads_qualifier
     , count(distinct cm.material_id)
       filter ( where f.missing_field = 'object_type' )           object_type
from {{ ref('missing_fields') }} f
         join {{ ref('collection_material_ext') }} cm on cm.material_id = f.resource_id
where f.resource_type = 'material'
group by cm.collection_id