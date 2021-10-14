select cm.*
     , empty_str2sentinel(
        lower(jsonb_array_elements_text(m.cclom__general_keyword)),
        '<EMPTY>'::text
     ) val
{{ cm_join_m() }}
