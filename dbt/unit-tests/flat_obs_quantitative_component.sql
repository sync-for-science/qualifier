SELECT * FROM (
	{{ print("test_flatten_component_obs_skip_non_numeric") }}
	{{ count_rows( test_flatten_component_obs_skip_non_numeric() ) }}
	UNION ALL
	{{ print("test_flatten_component_obs_bp") }}
	{{ count_rows( test_flatten_component_obs_bp() ) }}
	UNION ALL
	{{ print("test_flatten_component_obs_dar") }}
	{{ count_rows( test_flatten_component_obs_dar() ) }}
	UNION ALL
	{{ print("test_flatten_component_obs_ignore_non_component") }}
	{{ count_rows( test_flatten_component_obs_ignore_non_component() ) }}
	UNION ALL
	{{ print("test_flatten_component_obs_ignore_empty_component") }}
	{{ count_rows( test_flatten_component_obs_ignore_empty_component() ) }}
	UNION ALL
	{{ print("test_flatten_component_obs_multiple") }}
	{{ count_rows( test_flatten_component_obs_multiple() ) }}
) a
WHERE rows > 0