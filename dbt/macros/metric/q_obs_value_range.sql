{% macro q_obs_value_range(flat_observation, seed_data) %}
	SELECT
		p.*, 
		qo.quantity_value, 
		qo.id, 
		CASE 
			WHEN quantity_value < p.low OR quantity_value > p.high
			THEN qo.id
			ELSE NULL
		END AS score
	FROM 
		{{seed_data}} p
	INNER JOIN 
		{{flat_observation}} qo
	ON 
		p.code = qo.code 
		AND (p.system = qo.system OR p.system_oid = qo.system)
		AND (qo.quantity_code = p.ucum_code OR qo.quantity_code = 'urn:oid:2.16.840.1.113883.6.8')
	WHERE qo.quantity_value IS NOT NULL
		AND qo.code IS NOT NULL
		AND qo.system IS NOT NULL
{% endmacro %}