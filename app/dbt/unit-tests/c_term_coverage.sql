SELECT * FROM (
	{{ print("test_c_term_coverage_common_system_combinations") }}
	{{ count_rows( test_c_term_coverage_common_system_combinations() ) }}
	UNION ALL
	{{ print("test_c_term_coverage_distinct_system_combinations") }}
	{{ count_rows( test_c_term_coverage_distinct_system_combinations() ) }}
	UNION ALL
	{{ print("test_c_term_coverage_consolidate_repeated_systems") }}
	{{ count_rows( test_c_term_coverage_consolidate_repeated_systems() ) }}
	UNION ALL
	{{ print("test_c_term_coverage_no_text") }}
	{{ count_rows( test_c_term_coverage_no_text() ) }}
	UNION ALL
	{{ print("test_c_term_coverage_only_text") }}
	{{ count_rows( test_c_term_coverage_only_text() ) }}
	UNION ALL
	{{ print("test_c_term_coverage_skip_category") }}
	{{ count_rows( test_c_term_coverage_skip_category() ) }}
	UNION ALL
	{{ print("test_c_term_coverage_missing_code") }}
	{{ count_rows( test_c_term_coverage_missing_code() ) }}
	UNION ALL
	{{ print("test_c_term_coverage_ignore_duplicate_categories") }}
	{{ count_rows( test_c_term_coverage_ignore_duplicate_categories() ) }}
	UNION ALL
	{{ print("test_c_term_coverage_missing_category") }}
	{{ count_rows( test_c_term_coverage_missing_category() ) }}
	UNION ALL
	{{ print("test_c_term_coverage_non_code_element_name") }}
	{{ count_rows( test_c_term_coverage_non_code_element_name() ) }}
	UNION ALL
	{{ print("test_c_term_coverage_encounter") }}
	{{ count_rows( test_c_term_coverage_encounter() ) }}
) a
WHERE rows > 0