{% set sources = [] -%}
{% for node in graph.sources.values() -%}
    {%- do sources.append(node.name|lower) -%}
{%- endfor %}

{% set ns = namespace(prev_item=false) %}

SELECT * FROM (

{%- for resource in sources -%}
	{%- set skip_category = True -%}
	{%- if resource == "immunization" -%}
		{% set cc_element = "vaccineCode" -%}
	{%- elif resource == "encounter" or resource == "documentreference" or resource == "device" -%}
		{% set cc_element = "type" -%}
	{%- elif resource == "medicationrequest" or resource == "medicationadministration" -%}
		{%- set cc_element = "medicationCodeableConcept" -%}
	{%- elif resource == "observation" or resource == "condition" or resource == "allergyintolerance" or resource == "procedure" or resource == "medication" -%}
		{%- set cc_element = "code" -%}
		{%- if resource == "observation" or resource == "condition" -%}{%- set skip_category = False -%}{%- endif -%}
	{%- endif -%}
	{%- if cc_element -%}
	{% if ns.prev_items %}UNION ALL{% endif %}
	{%- set ns.prev_items = True -%}
	({{ c_term_coverage(source("qualifier", resource), var('db_json_column'), var('db_is_jsonb'), resource, cc_element, skip_category) }})
	{%- endif -%}
{%- endfor -%}

) AS coverage_query