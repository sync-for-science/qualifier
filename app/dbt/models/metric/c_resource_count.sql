{% set sources = [] -%}
{% for node in graph.sources.values() -%}
    {%- do sources.append(node.name) -%}
{%- endfor %}

{% set ns = namespace(prev_item=false) %}

SELECT * FROM (

{% for resource in ["Observation", "DocumentReference", "MedicationRequest", "Encounter", "Condition"] %}
	{% if resource|lower in sources %}
		{% if ns.prev_items %}UNION ALL{% endif %}
		{% set ns.prev_items = True %}
		{% set skip_category = var('skip_resource_count_category_encounter') if resource == "Encounter" else var('skip_resource_count_category') %}
		({{ c_resource_count_nested_category(source("qualifier", resource|lower), var('db_json_column'), var('db_is_jsonb'), resource, var('skip_resource_count_date'), skip_category) }})
	{% endif %}
{% endfor %}

{% if 'allergyintolerance' in sources %}
	{% if ns.prev_items %}UNION ALL{% endif %}
	{% set ns.prev_items = True %}
	({{ c_resource_count_allergy_intolerance(source("qualifier", "allergyintolerance"), var('db_json_column'), var('db_is_jsonb'), var('skip_resource_count_date'), var('skip_resource_count_category')) }})
{% endif %}

{% for resource in ["Patient","Immunization", "Procedure", "Medication", "MedicationAdministration", "Device"] %}
	{% if resource|lower in sources %}
		{% set ns.prev_items = True %}
		{% if ns.prev_items %}UNION ALL{% endif %}
		({{ c_resource_count_no_category(source("qualifier", resource|lower), var('db_json_column'), var('db_is_jsonb'), resource, var('skip_resource_count_date')) }})
	{% endif %}
{% endfor %}

) count_query