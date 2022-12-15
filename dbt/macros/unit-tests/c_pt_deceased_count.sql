{% macro test_patient_deceased_count_simple() %}

WITH flat_patient AS (
	{% call table_to_sql() %}
	| id     | active   | is_deceased   | birth_date          | death_date   |  sex    | omb_race_code   | omb_ethnicity_code   |
	|-------|----------|---------------|---------------------|--------------|---------|-----------------|----------------------|
	| 'pt1' | True     | False         | '1948-07-07'        | NULL         |  'male' | '2106-3'        | NULL                 |
	| 'pt2' | True     | True          | '1948-07-08'        | '2021-01-01' |  'male' | '2106-3'        | NULL                 |
	{% endcall %}
), pt_count AS (
	{{ c_pt_deceased_count("flat_patient") }}
), expect AS (
	{% call table_to_sql() %}
	|   birth_year | is_deceased   |   death_year | sex    |   cnt |
	|--------------|---------------|--------------|--------|-------|
	|         1948 | True          |         2021 | 'male' |     1 |
	{% endcall %}
)

{{ compare_tables("expect", "pt_count")}}

{% endmacro %}

{% macro test_patient_deceased_count_no_death_date() %}

WITH flat_patient AS (
	{% call table_to_sql() %}
	| id     | active   | is_deceased   | birth_date          | death_date   |  sex    | omb_race_code   | omb_ethnicity_code   |
	|-------|----------|---------------|---------------------|--------------|---------|-----------------|----------------------|
	| 'pt1' | True     | False         | '1948-07-07'        | NULL         |  'male' | '2106-3'        | NULL                 |
	| 'pt2' | True     | True          | '1948-07-08'        | '2021-01-01' |  'male' | '2106-3'        | NULL                 |
	{% endcall %}
), pt_count AS (
	{{ c_pt_deceased_count("flat_patient") }}
), expect AS (
	{% call table_to_sql() %}
	|   birth_year | is_deceased   |   death_year | sex    |   cnt |
	|--------------|---------------|--------------|--------|-------|
	|         1948 | True          |         2021 | 'male' |     1 |
	{% endcall %}
)

{{ compare_tables("expect", "pt_count")}}

{% endmacro %}

