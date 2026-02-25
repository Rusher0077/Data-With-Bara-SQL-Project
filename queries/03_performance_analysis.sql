-- 03.Performance Analysis
-- Purpose:
--     - To measure the performance of products, customers, or regions over time.
--     - For benchmarking and identifying high-performing entities.
--     - To track yearly trends and growth. 
---------------------------------------------------------------------------------

-- Year over Year (YOY Analysis)
-- Analyzing the yearly performance of products by comparing their sales 
-- to both the average sales performance of the product and the previous year's sales.


with yearly_sales as (
select 
extract(year from f.order_date) as order_year,
-- We can also analyze by months to see more granular trend
p.product_name,
sum(f.sales_amount) as total_sales
from gold.fact_sales f 
left join gold.dim_products p on p.product_key = f.product_key
where f.order_date is not null
group by extract(year from f.order_date), p.product_name

)
select 
	order_year, product_name,total_sales,
	avg(total_sales) over (partition by product_name)::int as avg_sales,
	total_sales - avg(total_sales) over (partition by product_name)::int as diff_avg,
	
	case 
		when total_sales - avg(total_sales) over (partition by product_name)::int > 0 then 'Above AVG'
		when total_sales - avg(total_sales) over (partition by product_name)::int < 0 then 'Below AVG'
		else 'Average'
	end as avg_change,
	
	lag(total_sales) over (partition by product_name order by order_year) as py_sales,

	case 
		when total_sales - lag(total_sales) over (partition by product_name order by order_year) > 0 then 'Increase'
		when total_sales - lag(total_sales) over (partition by product_name order by order_year) < 0 then 'Decrease'
		else 'No Change'
	end as py_diff
	
from yearly_sales
order by product_name, order_year
