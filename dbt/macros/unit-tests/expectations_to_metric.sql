{% macro data_expectations_example() %}
	{% call table_to_sql() %}
	| id | expectation_name | score |
	| -- | ---- |  --- |
	| '1'  | 'e1' | '1' |
	| '2'  | 'e1' | '2' |
	| '3'  | 'e1' | NULL |
	| '1'  | 'e2' | '1' |
	| '2'  | 'e2' | NULL |
	| '3'  | 'e2' | NULL |
	{% endcall %}
{% endmacro %}


{% macro test_expectations_to_metric_sample() %}

WITH expectation AS (
	{{ data_expectations_example() }}
),
metric_result AS (
	{% call expectations_to_metric('metric1') %}
		SELECT * FROM expectation
	{% endcall %}
),
expect AS (
	{% call table_to_sql() %}
		| metric_name   | criteria   |   error_count |   denominator | error_examples   |
		|---------------|------------|---------------|---------------|------------------|
		| 'metric1'     | 'e1'       |             2 |             3 | '1, 2'           |
		| 'metric1'     | 'e2'       |             1 |             3 | '1'              |
	{% endcall %}
)

{% call compare_tables_by_columns('expect', 'metric_result') %}
	metric_name,
	criteria,
	error_count,
	denominator,
	error_examples
{% endcall %}

{% endmacro %}

{% macro test_expectations_to_metric_no_examples() %}

WITH expectation AS (
	{{ data_expectations_example() }}
),
metric_result AS (
	{% call expectations_to_metric('metric1', False) %}
		SELECT * FROM expectation
	{% endcall %}
),
expect AS (
	{% call table_to_sql() %}
		| metric_name   | criteria   |   error_count |   denominator | error_examples   |
		|---------------|------------|---------------|---------------|------------------|
		| 'metric1'     | 'e1'       |             2 |             3 | NULL             |
		| 'metric1'     | 'e2'       |             1 |             3 | NULL             |
	{% endcall %}
)

{% call compare_tables_by_columns('expect', 'metric_result') %}
	metric_name,
	criteria,
	error_count,
	denominator,
	error_examples
{% endcall %}

{% endmacro %}

{% macro test_expectations_to_metric_all() %}

WITH expectation AS (
	{{ data_expectations_example() }}
),
metric_result AS (
	{% call expectations_to_metric('metric1', 'all') %}
		SELECT * FROM expectation
	{% endcall %}
),
expect AS (
	{% call table_to_sql() %}
	| metric_name   | criteria   |   error_count |   denominator | error_examples   |
	|---------------|------------|---------------|---------------|------------------|
	| 'metric1'     | 'e1'       |             1 |             1 | '1'              |
	| 'metric1'     | 'e1'       |             1 |             1 | '2'              |
	| 'metric1'     | 'e1'       |             0 |             1 | NULL             |
	| 'metric1'     | 'e2'       |             1 |             1 | '1'              |
	| 'metric1'     | 'e2'       |             0 |             2 | NULL             |
	{% endcall %}
)

{% call compare_tables_by_columns('expect', 'metric_result') %}
	metric_name,
	criteria,
	error_count,
	denominator,
	error_examples
{% endcall %}

{% endmacro %}