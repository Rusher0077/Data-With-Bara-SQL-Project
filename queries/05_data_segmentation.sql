--05.Data Segmentation Analysis
-- Purpose:
--    - To group data into meaningful categories for targeted insights.
--    - For customer segmentation, product categorization, or regional analysis.

-------------------------------------------------------------------------------
-- Making price segments based on sales amount in order to identify which 
-- segment has the highest sales

WITH sales_range AS ( 
    SELECT
        p.product_key,
        p.product_name,
        f.sales_amount
    FROM gold.fact_sales f
    JOIN gold.dim_products p 
        ON p.product_key = f.product_key
),

ss AS (  
    SELECT 
        product_key,
        product_name,
        sales_amount,
        CASE 
            WHEN sales_amount BETWEEN 0 AND 50 THEN '0-50'
            WHEN sales_amount BETWEEN 50 AND 100 THEN '50-100'
            WHEN sales_amount BETWEEN 100 AND 1000 THEN '100-1000'
            WHEN sales_amount BETWEEN 1000 AND 2500 THEN '1000-2500'
            ELSE 'More than 2500'
        END AS price_segments
    FROM sales_range
)

SELECT 
    price_segments,
    COUNT(price_segments) AS sales_count
FROM ss
GROUP BY price_segments
ORDER BY sales_count DESC;