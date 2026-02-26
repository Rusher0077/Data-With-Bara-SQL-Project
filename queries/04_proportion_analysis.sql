-- 04.Part to Whole Analysis (AKA Proportional Analysis)

-- Purpose:
--     - To compare performance or metrics across dimensions or time periods.
--     - To evaluate differences between categories.
--     - Useful for A/B testing or regional comparisons.
---------------------------------------------------------------------------------

-- Analyzing the percentage contribution to sales by product category

WITH sales as (
SELECT
	P.category,
	sum(f.sales_amount) as total_sales
FROM gold.dim_products p 
JOIN gold.fact_sales f on f.product_key = p.product_key
GROUP by p.category
)

SELECT 
	category,
	total_sales,
	sum(total_sales) over () as sum_tot_sales,
	concat(round(((total_sales/sum(total_sales) over ())*100),2), '%') as percentage_sales
FROM sales 
ORDER by total_sales desc

---------------------------------------------------------------------------------
-- "category"	  "percentage_sales"
-- "Bikes"	        "96.46%"
-- "Accessories"	"2.39%"
-- "Clothing"	    "1.16%"

-- Here Bikes category is dominating with 96% which is dangerous for the business 
-- because it is over-relying on it. If it fails then the business will get severely 
-- impacted. So either the business can set aside those 2 product categories or 
-- it can focus on those two to boost their sales.
