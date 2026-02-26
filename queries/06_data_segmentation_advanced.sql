-- 07.Data Segmentation Advanced
-- Group customers into three segments based on their spending behavior:
--     - VIP: Customers with at least 12 months of history and spending more than €5,000.
--     - Regular: Customers with at least 12 months of history but spending €5,000 or less.
--     - New: Customers with a lifespan less than 12 months.
-- And find the total number of customers by each group

WITH customer_lifespan AS (
    SELECT
        c.customer_key,
        SUM(f.sales_amount) AS purchase,
        DATE_PART('years', AGE(MAX(f.order_date), MIN(f.order_date))) * 12 + 
        DATE_PART('months', AGE(MAX(f.order_date), MIN(f.order_date))) AS lifespan
    
    -- In MySQL or SQL Server, this part would have been:
    --     DATE_DIFF('months', MIN(f.order_date), MAX(f.order_date)) AS lifespan
    
    FROM gold.dim_customers c
    JOIN gold.fact_sales f 
        ON f.customer_key = c.customer_key
    GROUP BY c.customer_key
)

SELECT
    customer_segment,
    COUNT(customer_key) AS customer_count
FROM (
    SELECT 
        customer_key,
        purchase,
        lifespan,
        CASE
            WHEN lifespan >= 12 AND purchase > 5000 THEN 'VIP'
            WHEN lifespan >= 12 AND purchase <= 5000 THEN 'Regular'
            ELSE 'New'
        END AS customer_segment
    FROM customer_lifespan
) t
GROUP BY customer_segment
ORDER BY customer_count DESC;

-- "customer_segment"    "customer_count"
-- "New"                  14828
-- "Regular"              2037
-- "VIP"                  1619