select cm.*
     , empty_str2sentinel(
        jsonb_array_elements_text(null2jsonb_array(m.ccm__commonlicense_key)),
        '<EMPTY>'::text
     ) val
{{ cm_join_m() }}
