{% macro portal_root_id() %}
'5e40e372-735c-4b17-bbf7-e827a5702b57'::uuid
{% endmacro %}


{% macro portal_root_path() %}
select id
     , path || uuid2ltree(id) path
     , nlevel(path) + 1       nlevel
from {{ target.schema }}_raw.collections
where id =  {{ portal_root_id() }}
{% endmacro %}
