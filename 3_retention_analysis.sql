WITH customer_last_purchase AS (
		SELECT DISTINCT 
			customerkey,
			full_name,
			orderdate,
			row_number() OVER (PARTITION BY customerkey ORDER BY orderdate DESC) AS order_num,
			first_purcharse,
			cohort_year
		FROM cohort_analysis 
		ORDER BY customerkey ASC
), customer_status AS (
	SELECT
		customerkey,
		full_name,
		orderdate AS last_purchase_date,
		CASE
			WHEN orderdate < (SELECT max(orderdate) FROM sales) - INTERVAL '6 months' THEN 'Churned'
			ELSE 'Active'
		END AS customer_status,
		cohort_year
	FROM  customer_last_purchase
	WHERE order_num = 1
		AND first_purcharse < (SELECT max(orderdate) FROM sales) - INTERVAL '6 months'
	--The query is filtering for customers whose first purchase happened before October 20, 2023
)
SELECT 
	cohort_year,
	customer_status,
	count(customerkey) AS num_customers,
	sum(count(customerkey)) OVER (PARTITION BY cohort_year) AS total_customers,
	round(count(customerkey) / sum(count(customerkey)) OVER (PARTITION BY cohort_year), 2) AS status_percentage 
FROM customer_status
GROUP BY cohort_year, customer_status




	

