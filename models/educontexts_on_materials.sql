select cm.*
     , empty_str2sentinel(
        shorten_vocab(
            jsonb_array_elements_text(null2jsonb_array(m.ccm__educationalcontext)),
            'educationalContext'::text
        ),
        '<EMPTY>'::text
     ) val
{{ cm_join_m() }}
