SELECT * FROM (
	{{ print("test_flatten_obs") }}
	{{ count_rows( test_flatten_obs() ) }}
	UNION ALL
	{{ print("test_flatten_obs_dar") }}
	{{ count_rows( test_flatten_obs_dar() ) }}
	UNION ALL
	{{ print("test_flatten_skip_non_quantitative") }}
	{{ count_rows( test_flatten_skip_non_quantitative() ) }}
	UNION ALL
	{{ print("test_flatten_obs_ignore_components") }}
	{{ count_rows( test_flatten_obs_ignore_components() ) }}
	UNION ALL
	{{ print("test_flatten_obs_multiple") }}
	{{ count_rows( test_flatten_obs_multiple() ) }}
) a
WHERE rows > 0