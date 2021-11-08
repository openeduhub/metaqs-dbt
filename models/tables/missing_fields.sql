select c.id                      resource_id
     , 'collection'::resource_type resource_type
     , unnest(
        string_to_array(
                concat_ws(
                        ','
                    , case when c.title isnull then 'title' end
                    , case when c.description isnull then 'description' end
                    , case when c.keywords isnull then 'keywords' end
                    , case when c.edu_context isnull then 'edu_context' end
                    )
            , ','
            )
    )::resource_field            missing_field
from {{ ref('collections') }} c

union all
select m.id                      resource_id
     , 'material'::resource_type resource_type
     , unnest(
        string_to_array(
                concat_ws(
                        ','
                    , case when m.title isnull then 'title' end
                    , case when m.description isnull then 'description' end
                    , case when m.license isnull then 'license' end
                    , case when m.taxon_id isnull then 'taxon_id' end
                    , case when m.edu_context isnull then 'edu_context' end
                    , case when m.learning_resource_type isnull then 'learning_resource_type' end
                    , case when m.keywords isnull then 'keywords' end
                    , case when m.ads_qualifier isnull then 'ads_qualifier' end
                    , case when m.object_type isnull then 'object_type' end
                    )
            , ','
            )
    )::resource_field            missing_field
from {{ ref('materials') }} m