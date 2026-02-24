-- 02. Cumulative_Analysis
-- Aggregate the data progressively over time.
-- Helps to understand whether business is growing or declining

-------------------------------------------------------------------------------
-- calculate the running total of sales over time (per month)

SELECT 
	order_date, 
	total_sales,
	sum(total_sales) over (partition by order_date order by order_date) as running_total_sales,
	round(avg_sales) as avg_sales,
	round(sum(avg_sales) over (partition by order_date order by order_date)) as moving_avg_sales

from (
	select 
	date_trunc('month', order_date)::date as order_date,
	sum(sales_amount) as total_sales,
	avg(sales_amount) as avg_sales
	from gold.fact_sales
	where order_date is not null
	group by date_trunc('month', order_date)::date
)t

-------------------------------------------------------------------------------
-- calculate the running total of sales over time (per year)

SELECT 
	order_date, 
	total_sales,
	sum(total_sales) over (order by order_date) as running_total_sales,
	round(avg_sales) as avg_sales,
	round(sum(avg_sales) over (order by order_date)) as moving_avg_sales

from (
	select 
	date_trunc('year', order_date)::date as order_date,
	sum(sales_amount) as total_sales,
	avg(sales_amount) as avg_sales
	from gold.fact_sales
	where order_date is not null
	group by date_trunc('year', order_date)::date
)t
