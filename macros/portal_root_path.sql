{% macro portal_root_path() %}
select id
     , path || {{ target.schema }}.uuid2ltree(id) path
     , nlevel(path) + 1                           nlevel
from {{ target.schema }}_raw.collections
where id =  {{ portal_root_id() }}
{% endmacro %}
