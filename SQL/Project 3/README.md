# Analyzing Sales Performance and Customer Segmentation in a Global Retail Company
- [Introduction](#introduction)
  - [Questions to be Answered](#questions-to-be-answered)
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
2. What is the average order value and quantity per customer?
3. How does customer behavior differ across different markets?
4. Are there any notable customer segments that have experienced significant growth or decline?

__Operational Efficiency Analysis__
1. What is the average shipping cost and order processing time for each shipping mode?
2. Which categories and sub-categories have the highest project margins?
3. Are there any operational inefficiencies or bottlenecks that need to be addressed?


### Tools 

- PostgreSQL - View [SQL queries](https://github.com/DeborahAkpoguma/Portfolio/blob/main/SQL/Project%203/Analysis%20of%20a%20Global%20Retail%20Company.sql) used in this project.
- Tableau - View the dashboards associated with this project:
	- [Sales Analysis](https://public.tableau.com/app/profile/deborah.akpoguma/viz/SalesAnalysisofaGlobalRetailCompany/SalesDashboard)

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
	RANK() over ( ORDER BY SUM(sales) DESC) AS sales_rank,
	TO_CHAR(SUM(profit),'$9,999,999.99') AS total_profit,
	RANK() over (ORDER BY SUM(profit) DESC ) AS profit_rank
FROM 
	superstore
GROUP BY market;
```
- Total Sales: The market with the highest total sales is APAC ($3,585,746.59), followed by EU ($2,938,091.38) and US ($2,297,201.07). Canada has the lowest total sales ($66,928.17).
- Total Profit: APAC also has the highest total profit ($436,000.05), followed by EU ($372,829.74) and US ($286,397.02). Canada has the lowest total profit ($17,817.39).

|market|total_sales   |sales_rank|total_profit  |profit_rank|
|------|--------------|----------|--------------|-----------|
|APAC  |$ 3,585,746.59|1         |$   436,000.05|1          |
|EU    |$ 2,938,091.38|2         |$   372,829.74|2          |
|US    |$ 2,297,201.07|3         |$   286,397.02|3          |
|LATAM |$ 2,164,605.32|4         |$   221,643.49|4          |
|EMEA  |$   806,161.35|5         |$    43,897.97|6          |
|Africa|$   783,773.37|6         |$    88,871.63|5          |
|Canada|$    66,928.17|7         |$    17,817.39|7          |

```sql
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
```

__Sales__
- Oceania in the APAC market has the highest total sales ($1,100,185.69), followed by Southeast Asia, North Asia, and Central Asia.
- Central in the EU market has the highest total sales ($1,720,554.00), followed by North and South.
- North in the LATAM market has the highest total sales ($622,590.78), followed by South, Central, and Caribbean.
- West in the US market has the highest total sales ($725,457.93), followed by East, Central, and South.
- Canada in the Canada market has the lowest total sales ($66,928.17).

__Profit__
- North Asia in the APAC market has the highest total profit ($165,578.42), followed by Central Asia, Oceania, and Southeast Asia.
- Central in the EU market has the highest total profit ($215,534.07), followed by North, South.
- North in the LATAM market has the highest total profit ($102,818.10), followed by Central, Caribbean, and South.
- West in the US market has the highest total profit ($108,418.45), followed by East, South, and Central.
- Canada in the Canada market has the lowest total profit ($17,817.39).


|market|region        |total_sales|sales_rank    |total_profit|profit_rank|
|------|--------------|-----------|--------------|------------|-----------|
|APAC  |Oceania       |$ 1,100,185.69|1             |$   120,089.11|3          |
|APAC  |Southeast Asia|$   884,423.95|2             |$    17,852.33|4          |
|APAC  |North Asia    |$   848,310.01|3             |$   165,578.42|1          |
|APAC  |Central Asia  |$   752,826.94|4             |$   132,480.19|2          |
|Africa|Africa        |$   783,773.37|1             |$    88,871.63|1          |
|Canada|Canada        |$    66,928.17|1             |$    17,817.39|1          |
|EMEA  |EMEA          |$   806,161.35|1             |$    43,897.97|1          |
|EU    |Central       |$ 1,720,554.00|1             |$   215,534.07|1          |
|EU    |North         |$   625,575.75|2             |$    91,779.86|2          |
|EU    |South         |$   591,961.63|3             |$    65,515.82|3          |
|LATAM |North         |$   622,590.78|1             |$   102,818.10|1          |
|LATAM |South         |$   617,223.64|2             |$    28,090.52|4          |
|LATAM |Central       |$   600,510.01|3             |$    56,163.55|2          |
|LATAM |Caribbean     |$   324,280.89|4             |$    34,571.32|3          |
|US    |West          |$   725,457.93|1             |$   108,418.45|1          |
|US    |East          |$   678,781.36|2             |$    91,522.78|2          |
|US    |Central       |$   501,239.88|3             |$    39,706.36|4          |
|US    |South         |$   391,721.90|4             |$    46,749.43|3          |



__2. How have the sales and profit figures evolved over time (yearly and quarterly trends)?__
```sql
SELECT 
	Extract(YEAR FROM order_date) AS order_year,
	TO_CHAR(SUM(sales),'$9,999,999.99') AS total_sales,
	RANK() OVER(ORDER BY SUM(sales) DESC) AS sales_rank,
	TO_CHAR(SUM(profit),'$9,999,999.99') AS total_profit,
	RANK() OVER(ORDER BY SUM(profit) DESC) AS profit_rank
from superstore
GROUP BY order_year
ORDER BY order_year;
```
- The total sales have been increasing over the years. In 2011, the total sales were $2,259,451.64, and it gradually increased to $4,299,867.67 in 2014. This indicates a positive trend in sales growth over the four-year period.
- The total profits also show a consistent increase over the years. Starting from $248,940.81 in 2011, the profits rose to $504,165.97 in 2014. This indicates a positive trend in profit growth.
  
|order_year|total_sales   |sales_rank|total_profit  |profit_rank|
|----------|--------------|----------|--------------|-----------|
|2011      |$ 2,259,451.64|4         |$   248,940.81|4          |
|2012      |$ 2,677,439.91|3         |$   307,415.28|3          |
|2013      |$ 3,405,748.03|2         |$   406,935.23|2          |
|2014      |$ 4,299,867.67|1         |$   504,165.97|1          |


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
__Sales and Profits by Yearly Quarter__ 
|order_year|quarter       |total_sales|sales_rank    |total_profit|profit_rank|
|----------|--------------|-----------|--------------|------------|-----------|
|2011      |Q4            |$   831,493.84|1             |$    99,320.58|1          |
|2011      |Q3            |$   613,306.48|2             |$    65,075.56|2          |
|2011      |Q2            |$   478,871.05|3             |$    48,501.40|3          |
|2011      |Q1            |$   335,780.27|4             |$    36,043.28|4          |
|2012      |Q4            |$   914,709.52|1             |$    95,434.36|1          |
|2012      |Q3            |$   737,769.23|2             |$    86,935.45|2          |
|2012      |Q2            |$   625,593.31|3             |$    81,650.82|3          |
|2012      |Q1            |$   399,367.85|4             |$    43,394.65|4          |
|2013      |Q4            |$ 1,072,850.83|1             |$   140,699.09|1          |
|2013      |Q3            |$   933,037.37|2             |$    98,793.16|2          |
|2013      |Q2            |$   834,839.83|3             |$    93,436.15|3          |
|2013      |Q1            |$   565,020.00|4             |$    74,006.83|4          |
|2014      |Q4            |$ 1,481,190.01|1             |$   167,982.94|1          |
|2014      |Q3            |$ 1,196,483.39|2             |$   149,558.22|2          |
|2014      |Q2            |$   932,987.33|3             |$   101,514.46|3          |
|2014      |Q1            |$   689,206.94|4             |$    85,110.35|4          |


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
- The fourth quarter consistently has the highest total sales and total profit rankings across multiple years. This suggests that the company performs exceptionally well during this quarter.
- On the other hand, the first quarter consistently has the lowest total sales and total profit rankings across multiple years. This suggests a comparatively weaker performance during the first quarter.
  
|order_year|quarter       |total_sales|sales_rank    |total_profit|profit_rank|
|----------|--------------|-----------|--------------|------------|-----------|
|2011      |Q4            |$   831,493.84|1             |$    99,320.58|1          |
|2012      |Q4            |$   914,709.52|1             |$    95,434.36|1          |
|2013      |Q4            |$ 1,072,850.83|1             |$   140,699.09|1          |
|2014      |Q4            |$ 1,481,190.01|1             |$   167,982.94|1          |
|2014      |Q1            |$   689,206.94|4             |$    85,110.35|4          |
|2011      |Q1            |$   335,780.27|4             |$    36,043.28|4          |
|2013      |Q1            |$   565,020.00|4             |$    74,006.83|4          |
|2012      |Q1            |$   399,367.85|4             |$    43,394.65|4          |

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
__Furniture Category__
- The subcategory "Chairs" has the highest total sales within the Furniture category, while the subcategory "Bookcases" has the highest total profit.
- Both "Chairs" and "Bookcases" rank in the top two for sales and profits within the Furniture category.
- The subcategory "Tables" has the lowest total profit, indicating that it may be less profitable compared to other subcategories within the Furniture category.

__Office Supplies Category__
- The subcategory "Storage" has the highest total sales within the Office Supplies category, while the subcategory "Appliances" has the highest total profit.
- Both "Storage" and "Appliances" rank in the top two for sales and profits within the Office Supplies category.
- The subcategories "Art" and "Paper" have lower rankings in terms of both sales and profits compared to other subcategories within the Office Supplies category.

__Technology Category__
- The subcategory "Phones" has the highest total sales within the Technology category, while the subcategory "Copiers" has the highest total profit.
- Both "Phones" and "Copiers" rank in the top two for sales and profits within the Technology category.
- The subcategory "Machines" has a lower ranking in terms of both sales and profits compared to other subcategories within the Technology category.
  
|category|sub_category  |total_sales|total_profit  |sales_rank|profit_rank|
|--------|--------------|-----------|--------------|----------|-----------|
|Furniture|Chairs        |$ 1,501,682.16|$   140,396.27|1         |2          |
|Furniture|Bookcases     |$ 1,466,572.55|$   161,924.42|2         |1          |
|Furniture|Tables        |$   757,042.17|$   -64,083.39|3         |4          |
|Furniture|Furnishings   |$   385,578.44|$    46,967.43|4         |3          |
|Office Supplies|Storage       |$ 1,127,086.68|$   108,461.49|1         |2          |
|Office Supplies|Appliances    |$ 1,011,064.54|$   141,680.59|2         |1          |
|Office Supplies|Binders       |$   461,912.20|$    72,449.85|3         |3          |
|Office Supplies|Art           |$   372,092.52|$    57,953.91|4         |5          |
|Office Supplies|Paper         |$   244,291.85|$    59,207.68|5         |4          |
|Office Supplies|Supplies      |$   243,074.23|$    22,583.26|6         |7          |
|Office Supplies|Envelopes     |$   170,904.37|$    29,601.12|7         |6          |
|Office Supplies|Fasteners     |$    83,242.47|$    11,525.42|8         |9          |
|Office Supplies|Labels        |$    73,404.31|$    15,010.51|9         |8          |
|Technology|Phones        |$ 1,706,824.65|$   216,717.01|1         |2          |
|Technology|Copiers       |$ 1,509,436.51|$   258,567.55|2         |1          |
|Technology|Machines      |$   779,060.32|$    58,867.87|3         |4          |
|Technology|Accessories   |$   749,237.28|$   129,626.31|4         |3          |


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
__Consumer Segment__
- The Consumer segment has the highest total sales among all the segments, indicating that it contributes the most to the company's revenue. In terms of profitability, the Consumer segment also has the highest total profit, ranking first in both sales and profit. This suggests that the Consumer segment is the most significant and profitable segment for the company.

__Corporate Segment__
- The Corporate segment has the second-highest total sales and total profit. While it ranks below the Consumer segment in both sales and profit, it still contributes significantly to the company's revenue and profitability. The Corporate segment is the second most important segment for the company in terms of both sales and profit.

__Home Office Segment__
- The Home Office segment has the lowest total sales and total profit among the three segments. Although it ranks third in both sales and profit, it still makes a notable contribution to the company's overall revenue and profitability. The Home Office segment represents a smaller portion of the company's business compared to the Consumer and Corporate segments.
  
|segment|total_sales   |sales_rank|total_profit  |profit_rank|
|-------|--------------|----------|--------------|-----------|
|Consumer|$ 6,507,952.31|1         |$   749,239.78|1          |
|Corporate|$ 3,824,698.96|2         |$   441,208.33|2          |
|Home Office|$ 2,309,855.98|3         |$   277,009.18|3          |

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

- The __"Standard Class"__ shipping mode has the highest total sales and total profit. It has the most number of orders among all the shipping modes. "Standard Class" ranks first both in terms of sales and profit.
- The __"Second Class"__ shipping mode has the second-highest total sales and total profit. It has a considerable number of orders but is lower than the "Standard Class" shipping mode. "Second Class" ranks second both in terms of sales and profit.
- The __"First Class"__ shipping mode has the third-highest total sales and total profit. It has a smaller number of orders compared to "Standard Class" and "Second Class" but still significant. "First Class" ranks third both in terms of sales and profit.
- The __"Same Day"__ shipping mode has the lowest total sales and total profit among the shipping modes. It has the fewest number of orders. "Same Day" ranks fourth both in terms of sales and profit.
  
|ship_mode|no_of_orders  |total_sales|sales_rank    |total_profit|profit_rank|
|---------|--------------|-----------|--------------|------------|-----------|
|Standard Class|30775         |$ 7,578,655.51|1             |$   890,596.02|1          |
|Second Class|10309         |$ 2,565,672.42|2             |$   292,583.53|2          |
|First Class|7505          |$ 1,830,977.00|3             |$   208,104.68|3          |
|Same Day |2701          |$   667,202.32|4             |$    76,173.07|4          |

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
- The order priority __"Medium"__ has the highest total sales and total profit among all order priorities. It ranks first in terms of both sales and profits.
- The order priority __"High"__ follows "Medium" in terms of both total sales and total profit.
- The order priority __"Critical"__ ranks third in terms of both sales and profits.
- The order priority __"Low"__ has the lowest total sales and total profit among all order priorities. It ranks fourth in terms of both sales and profits.
  
|order_priority|no_of_orders  |total_sales|sales_rank    |total_profit|profit_rank|
|--------------|--------------|-----------|--------------|------------|-----------|
|Medium        |29433         |$ 7,280,895.24|1             |$   864,203.76|1          |
|High          |15501         |$ 3,807,550.09|2             |$   420,373.51|2          |
|Critical      |3932          |$   986,235.76|3             |$   124,224.16|3          |
|Low           |2424          |$   567,826.16|4             |$    58,655.85|4          |


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
__Customer Acquisition__
- In 2011, there were 1,309 customers acquired. As it is the first year, there is no previous year's customer count available.
- In 2012, there were 1,373 customers, representing a growth rate of 4.66% compared to the previous year.
- In 2013, there were 1,458 customers, representing a growth rate of 5.83% compared to the previous year.
- In 2014, there were 1,511 customers, representing a growth rate of 3.51% compared to the previous year.

__Customer Retention__
- The "no_existing_customers" column represents the number of customers who were classified as "Existing Customers" in each year.
- The "no_new_customers" column represents the number of customers who were classified as "New Customers" in each year. A new customer is defined as an individual who has made a purchase during the given calendar year or whose most recent purchase date exceeds a period of one year.
- The "retention_rate" column represents the retention rate, which is calculated as the ratio of the number of existing customers to the previous year's customer count.
- In 2011, since it is the first year, there are no new customers, and the retention rate is not applicable (NULL).
- In 2012, out of the 1,373 customers, 1,163 were existing customers, and 210 were new customers. The retention rate is 0.89 (89%).
- In 2013, out of the 1,458 customers, 1,273 were existing customers, and 185 were new customers. The retention rate is 0.93 (93%).
- In 2014, out of the 1,511 customers, 1,387 were existing customers, and 124 were new customers. The retention rate is 0.95 (95%).

Overall, the number of customers has been increasing each year, indicating growth in customer acquisition. The retention rate is relatively high, with a consistent upward trend, suggesting that the company has been successful in retaining its customers over time.

|year  |no_of_customers_current|no_of_customers_previous|growth_rate   |no_existing_customers|no_new_customers|retention_rate|
|------|-----------------------|------------------------|--------------|---------------------|----------------|--------------|
|2011  |1309                   |NULL                    |%             |1309                 |0               |NULL          |
|2012  |1373                   |1309                    |4.66%         |1163                 |210             |0.89          |
|2013  |1458                   |1373                    |5.83%         |1273                 |185             |0.93          |
|2014  |1511                   |1458                    |3.51%         |1387                 |124             |0.95          |


__2. What is the average order value and quantity per customer?__
```sql
SELECT 
	TO_CHAR(AVG(sales),'$9,999,999.99') AS average_order_value,
	CEILING(AVG(quantity)) AS average_quantity
FROM 
	superstore;
```
- The __average order value__ is $246.49. This means that, on average, each order placed has a value of approximately $246.49. I
- The __average quantity__ is 4. This indicates that, on average, customers purchase 4 units of products per order.
  
|average_order_value|average_quantity|
|-------------------|----------------|
|$       246.49     |4               |

__3. How does customer behavior differ across different markets?__
```sql

__Segment__
WITH market_segment AS 
	(SELECT 
		market, 
		segment, 
		COUNT(DISTINCT order_id) AS no_of_orders,
		RANK () OVER (PARTITION BY market ORDER BY COUNT(DISTINCT order_id) DESC) AS segment_rank
	FROM 
		superstore
	GROUP BY market, segment)
SELECT 
	* 
FROM
	market_segment
WHERE segment_rank IN (1,3)
ORDER BY segment_rank;
```
- The __"Consumer"__ segment consistently ranks first in terms of the number of orders across various markets, including Canada, EU, Africa, LATAM, EMEA, US, and APAC. This indicates that the majority of customers in these markets belong to the "Consumer" segment.
- The __"Home Office"__ segment ranks third in terms of the number of orders in markets such as the US, APAC, Africa, Canada, EMEA, EU, and LATAM. This suggests that the "Home Office" segment is the least popular segment in these markets.
  
|market|segment       |no_of_orders|segment_rank|
|------|--------------|------------|------------|
|Canada|Consumer      |102         |1           |
|EU    |Consumer      |2494        |1           |
|Africa|Consumer      |1145        |1           |
|LATAM |Consumer      |2679        |1           |
|EMEA  |Consumer      |1286        |1           |
|US    |Consumer      |2586        |1           |
|APAC  |Consumer      |2817        |1           |
|US    |Home Office   |909         |3           |
|APAC  |Home Office   |1001        |3           |
|Africa|Home Office   |434         |3           |
|Canada|Home Office   |39          |3           |
|EMEA  |Home Office   |461         |3           |
|EU    |Home Office   |880         |3           |
|LATAM |Home Office   |963         |3           |

__Category__
```sql		
WITH market_category AS
	(SELECT 
		market, 
		category, 
		COUNT(DISTINCT order_id) AS no_of_orders,
		RANK () OVER (PARTITION BY market ORDER BY COUNT(DISTINCT order_id) DESC) AS category_rank
	FROM 
		superstore
	GROUP BY market, category)
SELECT 
	* 
FROM
	market_category
WHERE category_rank IN (1,3)
ORDER BY category_rank;
```
__Office Supplies Category__
- The category of "Office Supplies" ranks consistently at the top (rank 1) in all markets: Canada, EU, Africa, LATAM, EMEA, US, and APAC.  Customers across these markets show a high demand for office supplies, as evidenced by the large number of orders placed in this category.

__Technology Category__
- The category of "Technology" ranks third (rank 3) in both the US and APAC markets. Customers in these markets exhibit relatively lower demand for technology products compared to office supplies. While still significant, the number of orders placed in the technology category is lower than that of office supplies.

__Furniture Category__
- The category of "Furniture" ranks third (rank 3) in Africa, Canada, EMEA, and EU markets. Customers in these markets show a relatively lower preference for furniture compared to office supplies. The number of orders placed in the furniture category is lower than that of office supplies.
  
|market|category      |no_of_orders|category_rank|
|------|--------------|------------|-------------|
|Canada|Office Supplies|174         |1            |
|EU    |Office Supplies|3714        |1            |
|Africa|Office Supplies|1805        |1            |
|LATAM |Office Supplies|3715        |1            |
|EMEA  |Office Supplies|1953        |1            |
|US    |Office Supplies|3742        |1            |
|APAC  |Office Supplies|3920        |1            |
|US    |Technology    |1544        |3            |
|APAC  |Technology    |1958        |3            |
|Africa|Furniture     |555         |3            |
|Canada|Furniture     |40          |3            |
|EMEA  |Furniture     |647         |3            |
|EU    |Furniture     |1292        |3            |
|LATAM |Technology    |1714        |3            |

 ```sql
-- Most Common and least common ship mode in each market 
WITH market_ship_mode AS 
	(SELECT 
		market, 
		ship_mode, 
		COUNT(DISTINCT order_id) AS no_of_orders,
		RANK () OVER (PARTITION BY market ORDER BY COUNT(DISTINCT order_id) DESC) AS ship_mode_rank
	FROM 
		superstore
	GROUP BY market, ship_mode)
SELECT 
	* 
FROM
	market_ship_mode
WHERE ship_mode_rank IN (1,4)
ORDER BY ship_mode_rank;
```
- The most preferred ship mode across all markets is "Standard Class." This is evident from the ship_mode_rank column, where the ship mode "Standard Class" consistently has a rank of 1 in each market. It indicates that customers in all markets predominantly choose the standard shipping option for their orders.
- The ship mode "Same Day" is the least popular shipping mode across different markets. This suggests that while there is a preference for standard shipping, a smaller segment of customers across markets opt for expedited shipping with the "Same Day" ship mode.

|market|ship_mode     |no_of_orders|ship_mode_rank|
|------|--------------|------------|--------------|
|Canada|Standard Class|108         |1             |
|EU    |Standard Class|2856        |1             |
|Africa|Standard Class|1346        |1             |
|LATAM |Standard Class|3093        |1             |
|EMEA  |Standard Class|1488        |1             |
|US    |Standard Class|2994        |1             |
|APAC  |Standard Class|3282        |1             |
|US    |Same Day      |264         |4             |
|APAC  |Same Day      |281         |4             |
|Africa|Same Day      |113         |4             |
|Canada|Same Day      |15          |4             |
|EMEA  |Same Day      |135         |4             |
|EU    |Same Day      |266         |4             |
|LATAM |Same Day      |273         |4             |

```sql 
-- Most Common and least common order_priority in each market
WITH market_order_priority AS
	(SELECT 
		market, 
		order_priority, 
		COUNT(DISTINCT order_id) AS no_of_orders,
		RANK () OVER (PARTITION BY market ORDER BY COUNT(DISTINCT order_id) DESC) AS order_priority_rank
	FROM 
		superstore
	GROUP BY market, order_priority)
SELECT 
	* 
FROM
	market_order_priority
WHERE order_priority_rank IN (1,3)
ORDER BY order_priority_rank;
```
- "Medium" order priority is the most common across all markets, as it holds the rank 1 in all markets listed in the table.
- "Critical" order priority holds the rank 3 in all markets listed in the table, indicating that it is the least frequent order priority in all markets.
  
|market|order_priority|no_of_orders|order_priority_rank|
|------|--------------|------------|-------------------|
|Canada|Medium        |111         |1                  |
|EU    |Medium        |2757        |1                  |
|Africa|Medium        |1305        |1                  |
|LATAM |Medium        |2944        |1                  |
|EMEA  |Medium        |1415        |1                  |
|US    |Medium        |2865        |1                  |
|APAC  |Medium        |3096        |1                  |
|US    |Critical      |388         |3                  |
|APAC  |Critical      |419         |3                  |
|Africa|Critical      |176         |3                  |
|Canada|Critical      |18          |3                  |
|EMEA  |Critical      |194         |3                  |
|EU    |Critical      |397         |3                  |
|LATAM |Critical      |375         |3                  |

__4. Are there any notable customer segments that have experienced significant growth or decline?__
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
- The __"Consumer"__ segment shows a consistent positive sales growth percentage from 2011 to 2014. The sales increased by approximately 19.82%, 15.35%, and 19.24% each year compared to the previous year.
- The __"Corporate"__ segment also demonstrates consistent sales growth. The growth percentages are approximately 10.69%, 27.28%, and 17.67% for the years 2012, 2013, and 2014, respectively.
- The __"Home Office"__ segment exhibits the highest sales growth rates among all segments. The growth percentages are approximately 10.27%, 28.18%, and 29.30% for the years 2012, 2013, and 2014, respectively.

|segment|year          |to_char|to_char-2|sales_growth|
|-------|--------------|-------|---------|------------|
|Consumer|2011          |$ 1,173,671.84|NULL     |%           |
|Consumer|2012          |$ 1,463,760.95|$ 1,173,671.84|19.82%      |
|Consumer|2013          |$ 1,729,255.96|$ 1,463,760.95|15.35%      |
|Consumer|2014          |$ 2,141,263.56|$ 1,729,255.96|19.24%      |
|Corporate|2011          |$   691,662.80|NULL     |%           |
|Corporate|2012          |$   774,459.92|$   691,662.80|10.69%      |
|Corporate|2013          |$ 1,064,973.85|$   774,459.92|27.28%      |
|Corporate|2014          |$ 1,293,602.39|$ 1,064,973.85|17.67%      |
|Home Office|2011          |$   394,117.00|NULL     |%           |
|Home Office|2012          |$   439,219.04|$   394,117.00|10.27%      |
|Home Office|2013          |$   611,518.22|$   439,219.04|28.18%      |
|Home Office|2014          |$   865,001.72|$   611,518.22|29.30%      |

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
- Orders shipped using the __"Same Day"__ shipping mode have the fastest average processing time, taking approximately 1 day to process. However, it comes with a relatively higher average shipping cost of $42.94.
- Orders shipped using the __"First Class"__ shipping mode have an average processing time of around 3 days. The average shipping cost for this mode is slightly lower than Same Day shipping, at $41.05.
- The __"Second Class"__ shipping mode has an average processing time of approximately 4 days. It offers a lower average shipping cost of $30.47 compared to the previous two shipping modes.
- Orders shipped using the __"Standard Class"__ shipping mode have the longest average processing time of around 5 days. However, it provides the lowest average shipping cost among all the shipping modes, with an average cost of $19.97.

|ship_mode|avg_processing_time|avg_shipping_cost|
|---------|-------------------|-----------------|
|Same Day |1                  |$        42.94   |
|First Class|3                  |$        41.05   |
|Second Class|4                  |$        30.47   |
|Standard Class|5                  |$        19.97   |

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
- __Furniture Category__: Among the furniture sub-categories, "Furnishings" has the highest profit margin with a value of $0.12. It is followed by "Bookcases" with a profit margin of $0.11. "Chairs" has a profit margin of $0.09, while "Tables" has a negative profit margin of -$0.08.
- __Office Supplies Category__: In the office supplies category, "Paper" has the highest profit margin of $0.24, making it the most profitable sub-category. "Labels" and "Envelopes" also have relatively high profit margins of $0.20 and $0.17 respectively. "Binders," "Art," "Appliances," and "Fasteners" have profit margins ranging from $0.16 to $0.14. The remaining sub-categories within office supplies have profit margins between $0.10 and $0.09.
- __Technology Category__: Among the technology sub-categories, "Accessories" and "Copiers" have the highest profit margins, both at $0.17. "Phones" follows with a profit margin of $0.13. "Machines" has the lowest profit margin among technology sub-categories at $0.08.
- These deductions suggest the most profitable sub-categories within each category based on their profit margins presented in dollars. "Furnishings" in the "Furniture" category, "Paper" in the "Office Supplies" category, and "Accessories" and "Copiers" in the "Technology" category have the highest profit margins.
  
|category|sub_category  |profit_margin|profit_margin_rank|
|--------|--------------|-------------|------------------|
|Furniture|Furnishings   |$          .12|1                 |
|Furniture|Bookcases     |$          .11|2                 |
|Furniture|Chairs        |$          .09|3                 |
|Furniture|Tables        |$         -.08|4                 |
|Office Supplies|Paper         |$          .24|1                 |
|Office Supplies|Labels        |$          .20|2                 |
|Office Supplies|Envelopes     |$          .17|3                 |
|Office Supplies|Binders       |$          .16|4                 |
|Office Supplies|Art           |$          .16|5                 |
|Office Supplies|Appliances    |$          .14|6                 |
|Office Supplies|Fasteners     |$          .14|7                 |
|Office Supplies|Storage       |$          .10|8                 |
|Office Supplies|Supplies      |$          .09|9                 |
|Technology|Accessories   |$          .17|1                 |
|Technology|Copiers       |$          .17|2                 |
|Technology|Phones        |$          .13|3                 |
|Technology|Machines      |$          .08|4                 |

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
- Most orders in the __"First Class"__ ship mode were processed and shipped within 1-3 days, with a count of 3,821. There were no orders in this ship mode that were shipped on the same day (0 days).
- For orders shipped on the __same day__, there were 1,290 orders that were processed and shipped on the same day (0 days). Additionally, there were 57 orders in the same day ship mode that took 1-3 days for processing and shipment.
- The majority of orders in the __"Second Class"__ ship mode took 1-3 days for processing and shipment, with a count of 3,056. There were also 2,077 orders that took 4-7 days for processing and shipment.
- In the __"Standard Class"__ ship mode, the processing and shipment time ranged from 4-7 days for the majority of orders, with a count of 15,154.
- The "Same Day" ship mode had a relatively high number of orders processed and shipped on the same day, indicating efficient operations. However, the "Standard Class" ship mode had a significant number of orders taking 4-7 days for processing and shipment, suggesting potential bottlenecks or slower operational processes.
  
|ship_mode|processing_time|count|
|---------|---------------|-----|
|First Class|1-3 days       |3821 |
|Same Day |0 days         |1290 |
|Same Day |1-3 days       |57   |
|Second Class|1-3 days       |3056 |
|Second Class|4-7 days       |2077 |
|Standard Class|4-7 days       |15154|
