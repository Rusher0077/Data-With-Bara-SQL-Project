-- 01 - Changes over time analysis
-- Analyse performance over time

------------------------------------------------------------------------

-- EXTRACT function

-- Displaying just the year of order date. More cleaner

SELECT
    EXTRACT(YEAR FROM order_date) AS order_year,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customer
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY EXTRACT(YEAR FROM order_date)
ORDER BY EXTRACT(YEAR FROM order_date);

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
ORDER BY DATE_TRUNC('year', order_date)::date;

------------------------------------------------------------------------

-- Shows the monthly order from its first day. More granular

SELECT
    DATE_TRUNC('month', order_date)::date AS order_year,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_TRUNC('month', order_date)::date
ORDER BY DATE_TRUNC('month', order_date)::date;

------------------------------------------------------------------------

-- TO_CHAR function 

-- Shows date in Year-Month format but the month will not get sorted properly 
-- because it is string

SELECT
    TO_CHAR(order_date, 'yyyy-Mon') AS order_year,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY TO_CHAR(order_date, 'yyyy-Mon')
ORDER BY TO_CHAR(order_date, 'yyyy-Mon');