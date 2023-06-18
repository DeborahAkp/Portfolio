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

## Data Cleaning
- To ensure that the "row_id" column contained unique values for each row, it was made the primary key of the table. All values are unique and there are no duplicates. 
  ```sql
  ALTER TABLE superstore
  ADD PRIMARY KEY (row_id);
  ```
- The TO_DATE function was used to verify that all dates in the "order_date" and "ship_date" columns were valid,  with an appropriate date format to convert the values and identify any invalid entries.

"ship_mode", "segment", "city", "state", "country", "postal_code", "market", "region", "category", "sub_category", "product_name", "order_priority": Check for any missing or invalid values in these text columns. You can use the IS NULL or IS NOT NULL conditions to identify and handle missing values. Additionally, consider applying data validation checks or referential integrity constraints based on your specific business rules.

"customer_name": Validate that the "customer_name" column does not contain any unusual or unexpected characters. You can use regular expressions or specific character checks to identify and clean any non-standard characters.

"sales", "quantity", "discount", "profit", "shipping_cost": Ensure that these numeric columns do not contain any missing or outlier values. You can use aggregate functions like COUNT, MIN, MAX, and AVG to check for any unusual values and apply appropriate filtering or cleansing techniques.

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

```sql
```
