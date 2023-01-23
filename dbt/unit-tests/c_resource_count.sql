SELECT * FROM (
	{{ print("test_c_resource_count_obs_same_dates") }}
	{{ count_rows( test_c_resource_count_obs_same_dates() ) }}
	UNION ALL
	{{ print("test_c_resource_count_obs_different_dates") }}
	{{ count_rows( test_c_resource_count_obs_different_dates() ) }}
	UNION ALL
	{{ print("test_c_resource_count_nested_category_collapse_categories") }}
	{{ count_rows( test_c_resource_count_nested_category_collapse_categories() ) }}
	UNION ALL
	{{ print("test_c_resource_count_nested_category_ignore_other_systems") }}
	{{ count_rows( test_c_resource_count_nested_category_ignore_other_systems() ) }}
	UNION ALL
	{{ print("test_c_resource_count_obs_skip_dates") }}
	{{ count_rows( test_c_resource_count_obs_skip_dates() ) }}
	UNION ALL
	{{ print("test_c_resource_count_obs_skip_category") }}
	{{ count_rows( test_c_resource_count_obs_skip_category() ) }}
	UNION ALL
	{{ print("test_c_resource_count_condition") }}
	{{ count_rows( test_c_resource_count_condition() ) }}
	UNION ALL
	{{ print("test_c_resource_count_medication_request") }}
	{{ count_rows( test_c_resource_count_medication_request() ) }}
	UNION ALL
	{{ print("test_c_resource_count_encounter") }}
	{{ count_rows( test_c_resource_count_encounter() ) }}
	UNION ALL
	{{ print("test_c_resource_count_condition_date_fallback") }}
	{{ count_rows( test_c_resource_count_condition_date_fallback() ) }}

	UNION ALL
	{{ print("test_c_resource_count_no_category_date") }}
	{{ count_rows( test_c_resource_count_no_category_date() ) }}
	UNION ALL
	{{ print("test_c_resource_count_no_category_no_date") }}
	{{ count_rows( test_c_resource_count_no_category_no_date() ) }}
	UNION ALL
	{{ print("test_c_resource_count_no_category_skip_date") }}
	{{ count_rows( test_c_resource_count_no_category_skip_date() ) }}

	UNION ALL
	{{ print("test_c_resource_count_allergy_intolerance") }}
	{{ count_rows( test_c_resource_count_allergy_intolerance() ) }}
	UNION ALL
	{{ print("test_c_resource_count_allergy_intolerance_skip_date") }}
	{{ count_rows( test_c_resource_count_allergy_intolerance_skip_date() ) }}
	UNION ALL
	{{ print("test_c_resource_count_allergy_intolerance_skip_category") }}
	{{ count_rows( test_c_resource_count_allergy_intolerance_skip_category() ) }}
	UNION ALL
	{{ print("test_c_resource_count_allergy_intolerance_date_fallback") }}
	{{ count_rows( test_c_resource_count_allergy_intolerance_date_fallback() ) }}

) a
WHERE rows > 0