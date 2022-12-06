{% call expectations_to_metric('q_obs_value_range', var('metric_include_examples')) %}
	{{ q_obs_value_range( ref("flat_obs_quantitative"), ref("obs_plausibility") ) }}
{% endcall %}