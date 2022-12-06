{% macro obs_plausibility_query(valid=False, expect_empty=False) %}
{% set tbl = caller() %}
WITH plausibility AS (
	{% call table_to_sql() %}
	| system   | code | ucum_code | low | high |
	| 'loinc'  | '123'  | '456'       | 5   | 10   |
	{% endcall %}
),
obs AS (
	{% call table_to_sql() %}
		{{ tbl }}
	{% endcall %}
),
test AS ({{ q_obs_value_range( "obs", "plausibility" ) }} )
{% if expect_empty %}
	SELECT * FROM test
{% else %}
	SELECT 1 FROM test 
	WHERE score IS {{ 'NOT NULL' if valid else 'NULL'}}
{% endif %}
{% endmacro %}

{% macro test_obs_plaus_valid_value() %}{% call obs_plausibility_query(True) %}
	| id    | quantity_value | system  | code | quantity_code  |
	| 'id1' |             6 | 'loinc'  | '123'   | '456'            |
{% endcall %}{% endmacro %}

{% macro test_obs_plaus_require_value() %}{% call obs_plausibility_query(False, True) %}
	| id    | quantity_value::NUMERIC | system   | code  | quantity_code  |
	| 'id1' |                    NULL | 'loinc'  | '123'   | '456'            |
{% endcall %}{% endmacro %}

{% macro test_obs_plaus_require_system() %}{% call obs_plausibility_query(False, True) %}
	| id    | quantity_value | system  | code | quantity_code  |
	| 'id1' |           6 | NULL  | '123'   | '456'           |
{% endcall %}{% endmacro %}

{% macro test_obs_plaus_require_code() %}{% call obs_plausibility_query(False, True) %}
	| id    | quantity_value | system  | code::TEXT | quantity_code  |
	| 'id1' |           6 | 'loinc'    | NULL | '456'           |
{% endcall %}{% endmacro %}

{% macro test_obs_plaus_invalid_high() %}{% call obs_plausibility_query() %}
	| id    | quantity_value | system  | code | quantity_code  |
	| 'id1' |             18 | 'loinc'  | '123'   | '456'           |
{% endcall %}{% endmacro %}

{% macro test_obs_plaus_invalid_low() %}{% call obs_plausibility_query() %}
	| id    | quantity_value | system  | code | quantity_code  |
	| 'id1' |             18 | 'loinc'  | '123'   | '456'           |
{% endcall %}{% endmacro %}

{% macro test_obs_plaus_invalid_system() %}{% call obs_plausibility_query() %}
	| id    | quantity_value | system  | code | quantity_code  |
	| 'id1' |             6 | 'not_loinc'  | '123'   | '456'        |
{% endcall %}{% endmacro %}

{% macro test_obs_plaus_invalid_code() %}{% call obs_plausibility_query() %}
	| id    | quantity_value | system  | code | quantity_code  |
	| 'id1' |             6 | 'loinc'  | '124'   | '456'            |
{% endcall %}{% endmacro %}

{% macro test_obs_plaus_invalid_ucum() %}{% call obs_plausibility_query() %}
	| id    | quantity_value | system  | code | quantity_code  |
	| 'id1' |             6 | 'loinc'  | '123'   | '457'            |
{% endcall %}{% endmacro %}