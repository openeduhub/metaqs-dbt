{% macro cm_join_m() %}
from {{ ref('collection_material') }} cm
    join {{ ref('materials') }} m on cm.material_id = m.id
{% endmacro %}


{% macro proportion(count, total) %}
round({{ count }}::numeric / {{ total }}::numeric, 3) * 100
{% endmacro %}
