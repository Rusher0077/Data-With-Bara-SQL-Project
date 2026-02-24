-- 01 - Changes over time analysis
-- Analyse sales performance over time

------------------------------------------------------------------------

-- EXTRACT function

-- Displaying just the year of order date. More cleaner

SELECT
    EXTRACT(YEAR from order_date) as order_year,
    SUM(sales_amount) AS total_sales,
	count(DISTINCT customer_key) as total_customer
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY EXTRACT(YEAR from order_date)
ORDER BY EXTRACT(YEAR from order_date)

------------------------------------------------------------------------

-- DATE_TRUNC function

-- Same as before but this time groups all order date from the same year 
-- together and represents each year by its starting date: January 1st

SELECT
    DATE_TRUNC('year', order_date)::date AS order_year,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_TRUNC('year', order_date)::date
ORDER BY DATE_TRUNC('year', order_date)::date

------------------------------------------------------------------------

-- Shows the monthly order from its first day. More granular

SELECT 
	date_trunc('month', order_date)::date as order_year,
	sum(sales_amount) as total_sales,
	count(distinct customer_key) as total_customers
FROM gold.fact_sales
WHERE order_date is not null
GROUP by date_trunc('month', order_date)::date
order by date_trunc('month', order_date)::date

------------------------------------------------------------------------

-- TO_CHAR function 

-- Shows date in Year-Month format but the month will not get sorted properly 
-- because it is string

select 
	to_char(order_date, 'yyyy-Mon') as order_year,
	sum(sales_amount) as total_sales,
	count(distinct customer_key) as total_customers
FROM gold.fact_sales
WHERE order_date is not null
GROUP by to_char(order_date, 'yyyy-Mon')
order by to_char(order_date, 'yyyy-Mon')