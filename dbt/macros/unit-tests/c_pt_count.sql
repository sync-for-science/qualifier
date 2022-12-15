{% macro test_patient_count_simple() %}

WITH flat_patient AS (
	{% call table_to_sql() %}
	| id     | active   | is_deceased   | birth_date          | death_date   |  sex    | omb_race_code   | omb_ethnicity_code   |
	|-------|----------|---------------|---------------------|--------------|---------|-----------------|----------------------|
	| 'pt1' | True     | False         | '1948-07-07'        | NULL         |  'male' | '2106-3'        | NULL                 |
	| 'pt2' | True     | True          | '1948-07-08'        | '2021-01-01' |  'male' | '2106-3'        | NULL                 |
	{% endcall %}
), pt_count AS (
	{{ c_pt_count("flat_patient") }}
), expect AS (
	{% call table_to_sql() %}
	|   birth_year | sex    | omb_race_code   | omb_ethnicity_code   |   cnt |
	|--------------|--------|-----------------|----------------------|-------|
	|         1948 | 'male' | '2106-3'        | NULL                 |     2 |
	{% endcall %}
)

{{ compare_tables("expect", "pt_count")}}

{% endmacro %}


{% macro test_patient_count_no_birth_date() %}

WITH flat_patient AS (
	{% call table_to_sql() %}
	| id     | active   | is_deceased   | birth_date          | death_date   |  sex    | omb_race_code   | omb_ethnicity_code   |
	|-------|----------|---------------|---------------------|--------------|---------|-----------------|----------------------|
	| 'pt1' | True     | False         | NULL                | NULL         |  'male' | '2106-3'        | NULL                 |
	| 'pt2' | True     | True          | '1948-07-08'        | '2021-01-01' |  'male' | '2106-3'        | NULL                 |
	{% endcall %}
), pt_count AS (
	{{ c_pt_count("flat_patient") }}
), expect AS (
	{% call table_to_sql() %}
	|   birth_year | sex    | omb_race_code   | omb_ethnicity_code   |   cnt |
	|--------------|--------|-----------------|----------------------|-------|
	|         1948 | 'male' | '2106-3'        | NULL                 |     1 |
	|         NULL | 'male' | '2106-3'        | NULL                 |     1 |

	{% endcall %}
)

{{ compare_tables("expect", "pt_count")}}

{% endmacro %}

