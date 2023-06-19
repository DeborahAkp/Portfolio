-- *************************
-- IMPORTING DATASET INTO SQL
-- *************************
DROP TABLE IF EXISTS superstore;
CREATE TABLE superstore (
  row_id text PRIMARY KEY,
  order_id text,
  order_date date,
  ship_date date,
  ship_mode text,
  customer_id text,
  customer_name text,
  segment text,
  city text,
  state text,
  country text,
  postal_code text,
  market text,
  region text,
  product_id text,
  category text,
  sub_category text,
  product_name text,
  sales numeric,
  quantity integer,
  discount numeric,
  profit numeric,
  shipping_cost numeric,
  order_priority text
);

COPY superstore FROM '/Users/DebbieeeA/Portfolio/SQL/Project 3/superstore_dataset2011-2015.csv' WITH (FORMAT csv, HEADER true);


-- **************
-- SALES ANALYSIS
-- **************

-- Sales Revenue and Profit for Each Market
SELECT 
	market,
	TO_CHAR(SUM(sales),'$9,999,999.99') AS total_sales,
	RANK() over ( ORDER BY SUM(sales) DESC) AS sales_rank,
	TO_CHAR(SUM(profit),'$9,999,999.99') AS total_profit,
	RANK() over (ORDER BY SUM(profit) DESC ) AS profit_rank
FROM 
	superstore
GROUP BY market;

-- Sales Revenue and Profit for Regions in Each Market 
SELECT 
	market,
	region,
	TO_CHAR(SUM(sales),'$9,999,999.99') AS total_sales,
	RANK() over (PARTITION BY market ORDER BY SUM(sales) DESC) AS sales_rank,
	TO_CHAR(SUM(profit),'$9,999,999.99') AS total_profit,
	RANK() over (PARTITION BY market ORDER BY SUM(profit) DESC ) AS profit_rank
FROM 
	superstore
GROUP BY market, region;

-- Sales and Profit Figures over the Years 
SELECT 
	Extract(YEAR FROM order_date) AS order_year,
	TO_CHAR(SUM(sales),'$9,999,999.99') AS total_sales,
	RANK() OVER(ORDER BY SUM(sales) DESC) AS sales_rank,
	TO_CHAR(SUM(profit),'$9,999,999.99') AS total_profit,
	RANK() OVER(ORDER BY SUM(profit) DESC) AS profit_rank
from superstore
GROUP BY order_year
ORDER BY order_year;

-- Sales and Profit Figures over the Yearly Quarters
SELECT 
	Extract(YEAR FROM order_date) as order_year,
	(CASE 
		WHEN EXTRACT(MONTH FROM order_date) BETWEEN 1 AND 3 THEN 'Q1'
		WHEN EXTRACT(MONTH FROM order_date) BETWEEN 4 AND 6 THEN 'Q2'
		WHEN EXTRACT(MONTH FROM order_date) BETWEEN 7 AND 9 THEN 'Q3'
		ELSE 'Q4'
  	END) AS quarter,
	TO_CHAR(SUM(sales),'$9,999,999.99') AS total_sales,
	RANK() OVER(PARTITION BY Extract(YEAR FROM order_date) ORDER BY SUM(sales) DESC) AS sales_rank,
	TO_CHAR(SUM(profit),'$9,999,999.99') AS total_profit,
	RANK() OVER(PARTITION BY Extract(YEAR FROM order_date) ORDER BY SUM(profit) DESC) AS profit_rank
from superstore
GROUP BY order_year, quarter
ORDER BY order_year;


--Best and Worst Performing Quarter for Each Year (Sales and Profit)
WITH c_quarterly_sales AS(
SELECT 
	Extract(YEAR FROM order_date) as order_year,
	(CASE 
		WHEN EXTRACT(MONTH FROM order_date) BETWEEN 1 AND 3 THEN 'Q1'
		WHEN EXTRACT(MONTH FROM order_date) BETWEEN 4 AND 6 THEN 'Q2'
		WHEN EXTRACT(MONTH FROM order_date) BETWEEN 7 AND 9 THEN 'Q3'
		ELSE 'Q4'
  	END) AS quarter,
	TO_CHAR(SUM(sales),'$9,999,999.99') AS total_sales,
	RANK() OVER(PARTITION BY Extract(YEAR FROM order_date) ORDER BY SUM(sales) DESC) as sales_rank,
	TO_CHAR(SUM(profit),'$9,999,999.99') AS total_profit,
	RANK() OVER(PARTITION BY Extract(YEAR FROM order_date) ORDER BY SUM(profit) DESC) as profit_rank
FROM
		superstore
GROUP BY order_year, quarter)
SELECT * 
FROM c_quarterly_sales 
WHERE sales_rank IN (1,4) AND profit_rank IN (1,4)
ORDER BY sales_rank, profit_rank;

-- Top Selling Categories and Sub-Categories 
SELECT 
	category,
	sub_category,
	TO_CHAR(SUM(sales),'$9,999,999.99') AS total_sales,
	TO_CHAR(SUM(profit),'$9,999,999.99') AS total_profit,
	RANK() over (PARTITION BY category ORDER BY SUM(sales) DESC) AS sales_rank,
	RANK() over (PARTITION BY category ORDER BY SUM(profit) DESC ) AS profit_rank
FROM superstore
GROUP BY category,sub_category;

-- Sales Revenue and Profit for Segments 
SELECT 
	segment,
	TO_CHAR(SUM(sales),'$9,999,999.99') AS total_sales,
	RANK() over (ORDER BY SUM(sales) DESC) as sales_rank,
	TO_CHAR(SUM(profit),'$9,999,999.99') AS total_profit,
	RANK() over (ORDER BY SUM(profit) DESC ) as profit_rank
FROM superstore
GROUP BY segment
ORDER BY total_sales DESC;

-- Total Profit and Sales by Order Priority  
SELECT 
	order_priority,
	COUNT(order_priority) AS no_of_orders,
	TO_CHAR(SUM(sales),'$9,999,999.99') AS total_sales,
	RANK() over (ORDER BY SUM(sales) DESC) as sales_rank,
	TO_CHAR(SUM(profit),'$9,999,999.99') AS total_profit,
	RANK() over (ORDER BY SUM(profit) DESC ) as profit_rank
from superstore
GROUP BY order_priority;

--Total Profit and Sales by Ship Mode
SELECT 
	ship_mode,
	COUNT(ship_mode) AS no_of_orders,
	TO_CHAR(SUM(sales),'$9,999,999.99') AS total_sales,
	RANK() over (ORDER BY SUM(sales) DESC) as sales_rank,
	TO_CHAR(SUM(profit),'$9,999,999.99') AS total_profit,
	RANK() over (ORDER BY SUM(profit) DESC ) as profit_rank
from superstore
GROUP BY ship_mode;

-- *****************
-- CUSTOMER ANALYSIS
-- *****************

-- No of Customers Per Region
SELECT 
	market, region, 
	COUNT(DISTINCT customer_id) AS total_customers
FROM 
	superstore
GROUP BY market, region;

-- New customers acquired each year and customer retention rate 
WITH customer_count AS (
	SELECT 
		EXTRACT (YEAR from order_date) AS year,
		COUNT(DISTINCT customer_id) AS no_of_customers_current,
		LAG(COUNT(DISTINCT customer_id)) OVER () AS no_of_customers_previous
	FROM
		superstore 
	GROUP BY year),
customer_activity AS
	(SELECT
		customer_id,
		EXTRACT(YEAR FROM order_date) AS year,
		 LAG(EXTRACT(YEAR FROM order_date)) OVER (PARTITION BY customer_id ORDER BY EXTRACT(YEAR FROM order_date) ) as prev_year
	FROM
		superstore
	GROUP BY customer_id, year
	ORDER BY customer_id, year),
customer_status AS
	(SELECT 
		customer_id,
		year,
		prev_year,
		(year - prev_year) AS time_diff,
		(CASE WHEN (year - prev_year) = 1 THEN 'Existing Customer'
			WHEN (year - prev_year) > 1 THEN 'New Customer'
		 	WHEN (year - prev_year) IS NULL AND year =  2011  THEN 'Existing Customer'
			WHEN (year - prev_year) IS NULL THEN 'New Customer' END) AS status 
	FROM
		customer_activity)
SELECT 
	cs.year, 
	no_of_customers_current,
	no_of_customers_previous,
	CONCAT(ROUND(((no_of_customers_current - no_of_customers_previous) / (no_of_customers_current::numeric) ) * 100, 2), '%') AS growth_rate,
	SUM(CASE WHEN status = 'Existing Customer' THEN 1 Else 0 end) AS no_existing_customers,
	SUM(CASE WHEN status = 'New Customer' THEN 1 Else 0 end) AS no_new_customers,
	ROUND(((no_of_customers_current - (SUM(CASE WHEN status = 'New Customer' THEN 1 Else 0 end))) / (no_of_customers_previous::numeric)),2) AS retention_rate
FROM
	customer_status cs
	JOIN customer_count cc ON cs.year = cc.year
GROUP BY cs.year, no_of_customers_current, no_of_customers_previous
ORDER BY cs.year;

-- Customers that generate the highest sales 
SELECT 
	customer_id,
	customer_name,
	market,
	region,
	TO_CHAR(SUM(sales),'$9,999,999.99') AS total_sales, 
	TO_CHAR(SUM(profit),'$9,999,999.99') AS total_profit
FROM
	superstore 
GROUP BY customer_id, customer_name, market, region
ORDER BY total_sales DESC
LIMIT 10;


-- Average order value and quantity
SELECT 
	TO_CHAR(AVG(sales),'$9,999,999.99') AS average_order_value,
	CEILING(AVG(quantity)) AS average_quantity
FROM 
	superstore;

-- Analyzing Customer Behaviour
	-- Analyzing segment trends in each market 
		WITH market_segment AS 
			(SELECT 
				market, 
				segment, 
				COUNT(DISTINCT order_id) AS no_of_orders,
				RANK () OVER (PARTITION BY market ORDER BY COUNT(DISTINCT order_id) DESC) AS segment_rank
			FROM superstore
			GROUP BY market, segment)
		SELECT 
			* 
		FROM
			market_segment
		WHERE segment_rank IN (1,3)
		ORDER BY segment_rank;
		
	-- Analyzing category trends in each market 
		WITH market_category AS
			(SELECT 
				market, 
				category, 
				COUNT(DISTINCT order_id) AS no_of_orders,
				RANK () OVER (PARTITION BY market ORDER BY COUNT(DISTINCT order_id) DESC) AS category_rank
			FROM superstore
			GROUP BY market, category)
		SELECT 
			* 
		FROM
			market_category
		WHERE category_rank IN (1,3)
		ORDER BY category_rank;
	
	-- Most Common and least common ship mode in each market 
		WITH market_ship_mode AS 
			(SELECT 
				market, 
				ship_mode, 
				COUNT(DISTINCT order_id) AS no_of_orders,
				RANK () OVER (PARTITION BY market ORDER BY COUNT(DISTINCT order_id) DESC) AS ship_mode_rank
			FROM superstore
			GROUP BY market, ship_mode)
		SELECT 
			* 
		FROM
			market_ship_mode
		WHERE ship_mode_rank IN (1,4)
		ORDER BY ship_mode_rank;
	
	-- Most Common and least common order_priority in each market
		WITH market_order_priority AS
			(SELECT 
				market, 
				order_priority, 
				COUNT(DISTINCT order_id) AS no_of_orders,
				RANK () OVER (PARTITION BY market ORDER BY COUNT(DISTINCT order_id) DESC) AS order_priority_rank
			FROM superstore
			GROUP BY market, order_priority)
		SELECT 
			* 
		FROM
			market_order_priority
		WHERE order_priority_rank IN (1,3)
		ORDER BY order_priority_rank;

-- Sales Performance within customer segments 
WITH segment_growth AS 
	(SELECT 
		segment,
		EXTRACT (YEAR from order_date) AS year,
		SUM(sales) AS total_sales,
		LAG(SUM(sales)) OVER (PARTITION BY segment ORDER BY TO_CHAR(SUM(sales),'$9,999,999.99')) AS total_sales_prev_year
	FROM 
		superstore
	GROUP BY segment, year
	ORDER BY segment, year)
SELECT 
	segment,
	year, 
	TO_CHAR(total_sales,'$9,999,999.99'),
	TO_CHAR(total_sales_prev_year,'$9,999,999.99'),
	CONCAT(ROUND((((total_sales) - (total_sales_prev_year))/ (total_sales)) *100, 2), '%') AS sales_growth
FROM segment_growth;

-- *******************
-- OPERATIONAL ANALYSIS
-- *******************

-- Average Shipping Cost and Processing Time for Each shipping mode
SELECT 
	ship_mode,
	CEILING(AVG(ship_date - order_date)) AS avg_processing_time,
	TO_CHAR(AVG(shipping_cost),'$9,999,999.99') AS avg_shipping_cost
FROM
	superstore
GROUP BY ship_mode
ORDER BY AVG(shipping_cost) DESC;

-- Categories and Subcategories with the highest profit margin 
SELECT 
	category, 
	sub_category, 
	TO_CHAR(SUM(profit)/SUM(sales),'$9,999,999.99') AS profit_margin,
	RANK () OVER (PARTITION BY category ORDER BY SUM(profit)/SUM(sales) DESC ) AS profit_margin_rank
FROM
superstore 
GROUP BY category, sub_category;

-- Analyzing Order Processing Time
SELECT 
	ship_mode,
	CASE
		WHEN ship_date - order_date = 0 THEN '0 days'
		WHEN ship_date - order_date BETWEEN 1 AND 3 THEN '1-3 days'
		WHEN ship_date - order_date BETWEEN 4 AND 7 THEN '4-7 days'
		ELSE 'More than 7 days'
	END AS processing_time,
	COUNT(DISTINCT order_id)
	FROM
		superstore
GROUP BY ship_mode,processing_time
ORDER BY ship_mode, processing_time;
