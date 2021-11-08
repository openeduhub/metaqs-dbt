with step1 as (
    select sp.resource_id
         , sp.resource_field::resource_field
         , sp.resource_type::resource_type
         , sp.text_content
         , sp.derived_at
         , sp.error -> 'language' ->> 'code' lang
         , sp.error -> 'language' -> 'detectedLanguage' ->> 'code' detected_lang
         , (sp.error -> 'language' -> 'detectedLanguage' -> 'confidence')::real detected_lang_confidence
         , jsonb_array_elements(sp.error -> 'matches') "match"
         , sp.error
    from {{ source('languagetool', 'spellcheck') }} sp
)

select s1.*
     , s1.match -> 'rule' ->> 'id' rule_id
     , s1.match -> 'rule' -> 'category' ->> 'id' category_id
     , s1.match -> 'rule' ->> 'issueType' issue_type
     , s1.match -> 'type' ->> 'typeName' type_name
     , (s1.match -> 'length')::smallint "length"
     , (s1.match -> 'offset')::smallint "offset"
     , s1.match -> 'context' context
from step1 s1