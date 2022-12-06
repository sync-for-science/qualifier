{% macro expectations_to_metric(metric_name, include_examples="sample", example_count=3) %}

WITH metric AS (
	{{ caller() }}
)
{% if include_examples == "sample" %}
, examples AS (
	SELECT
		expectation_name, 
		string_agg(id, ', ') AS ids
		FROM (
			SELECT 
				id,
          		expectation_name,
				row_number() over (partition by expectation_name order by expectation_name desc) as expectation_rank
			FROM metric
			WHERE score IS NOT NULL
          ORDER BY id
		) a
	WHERE expectation_rank <= {{example_count}}
	GROUP BY 1
)
{% endif %}
SELECT
	  '{{run_started_at}}' AS run_started_at
	, '{{ metric_name }}' AS metric_name
	, metric.expectation_name AS criteria
	, count(distinct score) AS error_count
	, count(distinct id) AS denominator
	, {% if include_examples == "sample" -%} 
		ids 
	{%- elif include_examples -%}
		score
	{%- else -%}
		NULL
	{%- endif %} AS error_examples
FROM metric
{% if include_examples == "sample" %}
	LEFT JOIN examples ON examples.expectation_name = metric.expectation_name
{% endif %}
GROUP BY 1,2,3,6

{% endmacro %}