# Analyzing Sales Performance and Customer Segmentation in a Global Retail Company
- [Introduction](#introduction)
  - [Questions to be Answered](#questions-to-be-answered)
- [Data Cleaning](#data-cleaning)
- [Data Analysis](#data-analysis)


## Introduction
This data analysis project aims to explore and gain insights from a dataset provided by a global retail company. The dataset contains various columns such as order details, customer information, product information, and financial metrics. By utilizing PostgreSQL, this project will address key business questions related to sales performance and customer segmentation.

### Target Audience
This project is geared towards data analysts, business intelligence professionals, retail managers, and executives who are interested in conducting in-depth analysis to gain insights into sales performance and customer segmentation within a global retail company. It is also relevant for marketing professionals seeking to understand customer behavior and make informed decisions based on data-driven insights.

### Questions to be Answered
__Sales Analysis__
1. What are the total sales and profit figures for each market and region?
2. How have the sales and profit figures evolved over time (yearly and quarterly trends)?
3. What are the top-selling categories and sub-categories?
4. Which customer segments contribute the most to the company's revenue and profit?
5. How does the sales performance vary by different shipping modes and order priorities?
   
__Customer Analysis__ 
1. How many new customers were acquired each year and what is the customer retention rate?
2. Which customers generate the highest sales and profit?
3. What is the average order value and quantity per customer?
4. How does customer behavior differ across different markets?
5. Are there any notable customer segments that have experienced significant growth or decline?

__Operational Efficiency Analysis__
1. What is the average shipping cost and order processing time for each shipping mode?
2. Which categories and sub-categories have the highest project margins?
3. Are there any operational inefficiencies or bottlenecks that need to be addressed?


### Tools 

<!-- - PostgreSQL - View [SQL queries]() used in this project.
- Tableau - View the dashboard associated with this project [here](). -->

### Portfolio
View other [projects](https://github.com/DeborahAkpoguma/Portfolio-Guide/blob/main/README.md) that I have completed.

### Data 
- The data used in this project can be found [here](https://www.kaggle.com/jr2ngb/superstore-data).
- There are 24 columns in this dataset:
  - "row_id": A text column representing a unique identifier for each row in the dataset.There are no null values and all values are unique.
  - "order_id": A text column storing the unique identifier for each order made.There are no null values.
  - "order_date": A date column indicating the date when the order was placed. There are no null values and order dates range from 2011-01-01 to 2014-12-31.
  - "ship_date": A date column representing the date when the order was shipped. There are no null values and ship dates range from 2011-03-01 to 2015-01-07.
  - "ship_mode": A text column specifying the mode of shipment for the order. There are no null values and four distinct categories - "Second Class", "Standard Class", "Same Day", and "First Class". 
  - "customer_id": A text column containing the unique identifier for each customer. There are no null values.
  - "customer_name": A text column storing the name of the customer. There are no null values. 
  - "segment": A text column indicating the customer segment or category. There are no null values and three distinct categories - "Consumer", "Coporate", and "Home Office".
  - "city": A text column representing the city where the order was placed. There are no null values. 
  - "state": A text column specifying the state where the order was placed. There are no null values. 
  - "country": A text column indicating the country where the order was placed. There are no null values. 
  - "postal_code": A text column storing the postal code related to the order's location. There are 41296 null values.
  - "market": A text column indicating the market or market segment. There are no null values and seven distinct markets - "EMEA", "APAC", "EU", "Africa", "US", "LATAM", and "Canada". 
  - "region": A text column specifying the region where the order was placed. There are no null values and 13 distinct regions - "EMEA", "Caribbean", "South", "Central", "North Asia", "Oceania", "Southeast Asia", "Africa", "Central Asia", "Canada", "West", "North", and "East"
  - "product_id": A text column containing the unique identifier for each product. There are no null values. 
  - "category": A text column representing the category of the product. There are no null values and three distinct categories - "Furniture", "Office Supplies", and "Technology". 
  - "sub_category": A text column indicating the sub-category of the product.There are no null values and 17 distinct sub-categories -  "Tables", "Art", "Bookcases", "Storage", "Fasteners", "Envelopes", "Appliances", "Accessories", "Paper", "Phones", "Binders", "Copiers", "Labels", "Supplies", "Chairs", "Machines", and "Furnishings".
  - "product_name": A text column storing the name of the product. There are no null values. 
  - "sales": A numeric column representing the sales amount associated with the order. There are no null values. 
  - "quantity": An integer column indicating the quantity of products ordered. There are no null values. 
  - "discount": A numeric column representing the discount applied to the order. There are no null values.
  - "profit": A numeric column indicating the profit generated from the order. There are no null values. 
  - "shipping_cost": A numeric column specifying the cost of shipping for the order. There are no null values. 
  - "order_priority": A text column indicating the priority level of the order. There are no null values and four distinct order priority statuses - "Critical", "High", "Medium", and "Low". 

## Data Analysis

### Sales Analysis 
__1. What are the total sales and profit figures for each market and region?__
```sql
SELECT 
	market,
	TO_CHAR(SUM(sales),'$9,999,999.99') AS total_sales,
	RANK() over ( ORDER BY SUM(sales) DESC) as sales_rank,
	TO_CHAR(SUM(profit),'$9,999,999.99') AS total_profit,
	RANK() over (ORDER BY SUM(profit) DESC ) as profit_rank
FROM 
	superstore
GROUP BY market;
```

```sql
SELECT 
	market,
	region,
	TO_CHAR(SUM(sales),'$9,999,999.99') AS total_sales,
	RANK() over (PARTITION BY market ORDER BY SUM(sales) DESC) as sales_rank,
	TO_CHAR(SUM(profit),'$9,999,999.99') AS total_profit,
	RANK() over (PARTITION BY market ORDER BY SUM(profit) DESC ) as profit_rank
FROM 
	superstore
GROUP BY market, region;
```
__2. How have the sales and profit figures evolved over time (yearly and quarterly trends)?__
```sql
SELECT 
	Extract(YEAR FROM order_date) as order_year,
	TO_CHAR(SUM(sales),'$9,999,999.99') AS total_sales,
	RANK() OVER(ORDER BY SUM(sales) DESC) as sales_rank,
	TO_CHAR(SUM(profit),'$9,999,999.99') AS total_profit,
	RANK() OVER(ORDER BY SUM(profit) DESC) as profit_rank
from superstore
GROUP BY order_year
ORDER BY order_year;
```

```sql
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
from superstore
GROUP BY order_year, quarter
ORDER BY order_year;
```

```sql
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
```
__3. What are the top-selling categories and sub-categories?__
```sql
SELECT 
	category,
	sub_category,
	TO_CHAR(SUM(sales),'$9,999,999.99') AS total_sales,
	TO_CHAR(SUM(profit),'$9,999,999.99') AS total_profit,
	RANK() over (PARTITION BY category ORDER BY SUM(sales) DESC) AS sales_rank,
	RANK() over (PARTITION BY category ORDER BY SUM(profit) DESC ) AS profit_rank
FROM superstore
GROUP BY category,sub_category;
```
__4. Which customer segments contribute the most to the company's revenue and profit?__
```sql
SELECT 
	segment,
	TO_CHAR(SUM(sales),'$9,999,999.99') AS total_sales,
	RANK() over (ORDER BY SUM(sales) DESC) as sales_rank,
	TO_CHAR(SUM(profit),'$9,999,999.99') AS total_profit,
	RANK() over (ORDER BY SUM(profit) DESC ) as profit_rank
FROM superstore
GROUP BY segment
ORDER BY total_sales DESC;
```
__5. How does the sales performance vary by different shipping modes and order priorities?__
```sql
SELECT 
	ship_mode,
	COUNT(ship_mode) AS no_of_orders,
	TO_CHAR(SUM(sales),'$9,999,999.99') AS total_sales,
	RANK() over (ORDER BY SUM(sales) DESC) as sales_rank,
	TO_CHAR(SUM(profit),'$9,999,999.99') AS total_profit,
	RANK() over (ORDER BY SUM(profit) DESC ) as profit_rank
from superstore
GROUP BY ship_mode;
```

```sql
SELECT 
	order_priority,
	COUNT(order_priority) AS no_of_orders,
	TO_CHAR(SUM(sales),'$9,999,999.99') AS total_sales,
	RANK() over (ORDER BY SUM(sales) DESC) as sales_rank,
	TO_CHAR(SUM(profit),'$9,999,999.99') AS total_profit,
	RANK() over (ORDER BY SUM(profit) DESC ) as profit_rank
from superstore
GROUP BY order_priority;
```

### Customer Analysis 
__1. How many new customers were acquired each year and what is the customer retention rate?__
```sql
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
```
__2. Which customers generate the highest sales and profit?__
```sql
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
```
__3. What is the average order value and quantity per customer?__
```sql
SELECT 
	TO_CHAR(AVG(sales),'$9,999,999.99') AS average_order_value,
	CEILING(AVG(quantity)) AS average_quantity
FROM 
	superstore;
```
__4. How does customer behavior differ across different markets?__
```sql
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
```
__5. Are there any notable customer segments that have experienced significant growth or decline?__
```sql
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
```

### Operational Efficiency Analysis
__1. What is the average shipping cost and order processing time for each shipping mode?__
```sql
SELECT 
	ship_mode,
	CEILING(AVG(ship_date - order_date)) AS avg_processing_time,
	TO_CHAR(AVG(shipping_cost),'$9,999,999.99') AS avg_shipping_cost
FROM
	superstore
GROUP BY ship_mode
ORDER BY AVG(shipping_cost) DESC;
```
__2. Which categories and sub-categories have the highest project margins?__
```sql
SELECT 
	category, 
	sub_category, 
	TO_CHAR(SUM(profit)/SUM(sales),'$9,999,999.99') AS profit_margin,
	RANK () OVER (PARTITION BY category ORDER BY SUM(profit)/SUM(sales) DESC ) AS profit_margin_rank
FROM
superstore 
GROUP BY category, sub_category;
```
__3. Are there any operational inefficiencies or bottlenecks that need to be addressed?__
```sql
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
```
