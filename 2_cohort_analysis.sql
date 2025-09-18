SELECT
	cohort_year,
	sum(net_revenue) AS total_revenue,
	count(DISTINCT customerkey) AS total_customers,
	sum(net_revenue) / count(DISTINCT customerkey) AS avg_revenue_customer
FROM cohort_analysis
WHERE orderdate = first_purcharse
GROUP BY cohort_year
ORDER BY cohort_year