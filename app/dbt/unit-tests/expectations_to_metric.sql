SELECT * FROM (
	{{ print("test_expectations_to_metric_sample") }}
	{{ count_rows( test_expectations_to_metric_sample() ) }}
	UNION ALL
	{{ print("test_expectations_to_metric_no_examples") }}
	{{ count_rows( test_expectations_to_metric_no_examples() ) }}
	UNION ALL
	{{ print("test_expectations_to_metric_all") }}
	{{ count_rows( test_expectations_to_metric_all() ) }}
) a
WHERE rows > 0