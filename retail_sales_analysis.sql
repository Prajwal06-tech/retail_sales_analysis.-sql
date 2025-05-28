-- SQL Retail Sales Analysis --
CREATE DATABASE retail_sales_db;


-- Create Table --
CREATE TABLE sales_data(
		
        transactions_id INT PRIMARY KEY ,
		sale_date DATE,
		sale_time TIME,
		customer_id INT,
		gender VARCHAR(15),
		age INT,
		category VARCHAR(20),
		quantity INT,
		price_per_unit FLOAT,
		cogs FLOAT,
		total_sale FLOAT
);

SELECT * FROM sales_data
LIMIT 10;

SELECT COUNT(*) FROM sales_data;
     
-- Data Cleaning --
SELECT * FROM sales_data
WHERE transactions_id IS NULL
OR 
	sale_date IS NULL
OR
	sale_time IS NULL
OR
	customer_id IS NULL
OR
	gender IS NULL
OR
	age IS NULL
OR
	category IS NULL
OR
	quantity IS NULL
OR
	price_per_unit IS NULL
OR
	cogs IS NULL 
OR
	total_sale IS NULL;


-- Data Exploration --

-- How many sales we have ?
SELECT COUNT(*) AS Total_Sales
FROM sales_data;

-- How many unique customers we have ? 
SELECT COUNT(DISTINCT customer_id) AS Total_Customer
FROM sales_data;

-- What are the different product categories we have ?
SELECT DISTINCT category 
FROM sales_data;


-- Data Analysis & Business Key Problems & Answers --

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * FROM sales_data
WHERE sale_date = '2022-11-05'
ORDER BY sale_time;

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022
SELECT * FROM sales_data 
WHERE category = 'Clothing' 
AND quantity >3 
AND sale_date BETWEEN '2022-11-01' AND '2022-11-30'
ORDER BY sale_date;

-- Q.3 Write a SQL query to calculate the total sales for each category.
SELECT category AS CATEGORY, SUM(total_sale) AS Net_Sales, COUNT(*) AS Total_Sales 
FROM sales_data
GROUP BY category
ORDER BY Net_Sales DESC;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT AVG(age) AS Avg_Age, category
FROM sales_data
WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM sales_data 
WHERE total_sale >1000
ORDER BY total_sale DESC;

-- Q.6 Write a SQL query to find the total number of transactions made by each gender in each category.
SELECT category, gender, COUNT(*) AS Total_Transactions
FROM sales_data
GROUP BY category, gender
ORDER BY Total_Transactions DESC;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT 
       Year,
       Month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as Year,
    EXTRACT(MONTH FROM sale_date) as Month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS Ranking
FROM sales_data
GROUP BY 1, 2
) as t1
WHERE Ranking = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT customer_id, SUM(total_sale) AS Total_Sales
FROM sales_data
GROUP BY customer_id
ORDER BY Total_Sales DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category, COUNT(DISTINCT customer_id) AS Unique_Customers
FROM sales_data
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
SELECT
  CASE
    WHEN HOUR(sale_time) < 12 THEN 'Morning'
    WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
  END AS Shift,
  COUNT(*) AS Number_of_orders
FROM sales_data
GROUP BY shift;

-- End Of Project --