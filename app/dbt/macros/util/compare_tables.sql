{%- macro compare_tables(table_1, table_2) -%}
	(
		SELECT * FROM {{table_1}}
		EXCEPT 
		SELECT * FROM {{table_2}}
	) UNION ALL (
		SELECT * FROM {{table_2}}
		EXCEPT 
		SELECT * FROM {{table_1}}
	)
{%- endmacro -%}

{%- macro compare_tables_by_columns(table_1, table_2) -%}

	{%- set columns = caller() -%}

	(
		SELECT {{columns}}
		FROM {{table_1}}
		EXCEPT 
		SELECT {{columns}}
		FROM {{table_2}}
	) UNION ALL (
		SELECT {{columns}}
		FROM {{table_2}}
		EXCEPT 
		SELECT {{columns}}
		FROM {{table_1}}
	)
{%- endmacro -%}