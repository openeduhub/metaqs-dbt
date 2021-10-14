select distinct on (m.id) m.id
                    , m.doc -> 'properties' ->> 'cclom:title'                        cclom__title
                    , m.doc -> 'properties' ->> 'ccm:objecttype'                     ccm__objecttype
                    , m.doc -> 'properties' -> 'ccm:taxonid'                         ccm__taxonid
                    , m.doc -> 'properties' -> 'ccm:educationalcontext'              ccm__educationalcontext
                    , m.doc -> 'properties' -> 'ccm:educationallearningresourcetype' ccm__educationallearningresourcetype
                    , m.doc -> 'properties' -> 'ccm:educationalintendedenduserrole'  ccm__educationalintendedenduserrole
                    , m.doc -> 'properties' -> 'cclom:general_description'           cclom__general_description
                    , m.doc -> 'properties' -> 'cclom:general_keyword'               cclom__general_keyword
                    , m.doc -> 'properties' -> 'ccm:commonlicense_key'               ccm__commonlicense_key
                    , m.doc -> 'properties' -> 'ccm:oeh_languageLevel'               ccm__oeh_languageLevel
                    , m.doc -> 'properties' ->> 'ccm:wwwurl'                         ccm__wwwurl
                    , m.doc -> 'properties' -> 'ccm:oeh_widgets'                     ccm__oeh_widgets
                    , m.doc -> 'properties' ->> 'ccm:replicationsource'              ccm__replicationsource
                    , m.doc -> 'properties' ->> 'ccm:replicationsourceid'            ccm__replicationsourceid
                    , m.cm__created
                    , m.cm__modified
                    , m.created_at
from {{ ref('collection_material') }} cm
    join {{ source('wlo-fachportale', 'materials') }} m on cm.material_id = m.id
