USE brazilian_ecommerce_dataset;

/*
Project: Olist Brazilian E-Commerce Analysis
Assignment: 04 – Core SQL Insights
Author: Krishnendu Bachhar
Date:26.02.2026
Description:
    - SQL queries to extract core insights from the dataset
    - Revenue trends, customer behavior, delivery performance, review analysis, seller performance
    - Building on defined metrics for deeper understanding
    */

/* 1. Order and Revenue Analysis:  */

# 1. Monthly Revenue Trend:
SELECT DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month,
SUM(payment_value) AS total_revenue_in_dollars
FROM olist_orders_dataset o
JOIN olist_order_payments_dataset p ON o.order_id = p.order_id
GROUP BY month
ORDER BY month;

CREATE VIEW 
monthly_revenue_trend AS
SELECT DATE_FORMAT(order_purchase_timestamp,'%Y-%m') AS month,
SUM(payment_value) AS total_revenue_in_dollars
FROM olist_orders_dataset o
JOIN olist_order_payments_dataset p 
ON o.order_id = p.order_id
GROUP BY month
ORDER BY month;

# 2. Monthly Order Trend:

SELECT DATE_FORMAT(order_purchase_timestamp,'%Y-%m') AS Month,
COUNT(order_id) AS Ordres
FROM olist_orders_dataset
GROUP BY Month
ORDER BY Month;

# 3. Revenue by Category: 

SELECT p.product_category_name AS Category,
t.product_category_name_english  AS Category_English,
SUM(price) AS Total_Revenue_dollars FROM olist_products_dataset p 
JOIN olist_order_items_dataset o 
ON p.product_id = o.product_id
JOIN product_category_name_translation t 
ON p.product_category_name = t.product_category_name
GROUP BY t.product_category_name,t.product_category_name_english;

CREATE VIEW Revenue_by_Category AS
SELECT p.product_category_name AS Category,
t.product_category_name_english as Category_english,
SUM(price) AS Total_Revenue_dollars
FROM olist_products_dataset p
JOIN product_category_name_translation t 
ON p.product_category_name = t.product_category_name
JOIN olist_order_items_dataset o 
ON p.product_id = o.product_id
GROUP BY t.product_category_name,t.product_category_name_english;

# 4. Top 10 Revenue Generating Product Categories:

SELECT p.product_category_name AS Best_Revenue_Generating_Category,
t.product_category_name_english  AS Category_English,
SUM(price) AS Total_Revenue_dollars FROM olist_products_dataset p 
JOIN olist_order_items_dataset o 
ON p.product_id = o.product_id
JOIN product_category_name_translation t 
ON p.product_category_name = t.product_category_name
GROUP BY t.product_category_name,t.product_category_name_english
ORDER BY Total_Revenue_dollars DESC
LIMIT 10;

CREATE VIEW Top_10_Revenue_Generating_Product_Categories AS
SELECT p.product_category_name AS Best_Revenue_Generating_Category,
t.product_category_name_english  AS Category_English,
SUM(price) AS Total_Revenue_dollars FROM olist_products_dataset p 
JOIN olist_order_items_dataset o 
ON p.product_id = o.product_id
JOIN product_category_name_translation t 
ON p.product_category_name = t.product_category_name
GROUP BY t.product_category_name,t.product_category_name_english
ORDER BY Total_Revenue_dollars DESC
LIMIT 10;

# 5. Revenue By Seller:

SELECT s.seller_state, s.seller_city, s.seller_id AS seller, SUM(i.price) AS Total_Revenue
FROM olist_sellers_dataset s 
JOIN olist_order_items_dataset i 
ON s.seller_id = i.seller_id
GROUP BY s.seller_state,s.seller_city, s.seller_id
ORDER BY Total_Revenue DESC;

CREATE VIEW seller_revenue_segregation AS
SELECT s.seller_state, s.seller_city, s.seller_id AS seller, SUM(i.price) AS Total_Revenue
FROM olist_sellers_dataset s 
JOIN olist_order_items_dataset i 
ON s.seller_id = i.seller_id
GROUP BY s.seller_state,s.seller_city, s.seller_id
ORDER BY Total_Revenue DESC;

SELECT COUNT(seller_id) FROM olist_sellers_dataset;

/* 2. Customer Behavior Analysis: */

# 1. Customers Retention:


SELECT bucket, COUNT(*) AS customers
FROM (SELECT c.customer_unique_id,
CASE 
  WHEN COUNT(*) =1 THEN "Single Purchase Customer"
  WHEN COUNT(*) =2 THEN "Repeat Customer(2 Purchases)"
  WHEN COUNT(*) =3 THEN "Regular Customer(3 Purchases)"
  ELSE "High Frequency Customer(>3 Purchases)"
END AS bucket
  FROM olist_orders_dataset o 
  JOIN olist_customers_dataset c 
  ON o.customer_id = c.customer_id
  GROUP BY c.customer_unique_id)t
GROUP BY bucket
ORDER BY 
  CASE 
    WHEN bucket = "Single Purchase Customer" THEN 1
    WHEN bucket = "Repeat Customer(2 Purchases)" THEN 2
    WHEN bucket = "Regular Customer(3 Purchases)" THEN 3
    ELSE 4
  END; ;



CREATE VIEW customer_retention AS
(SELECT bucket, COUNT(*) AS Customers
FROM (SELECT c.customer_unique_id,
CASE 
  WHEN COUNT(*) = 1 THEN "Single Purchase Customer"
  WHEN COUNT(*) = 2 THEN "Repeat Customer(2 Purchases)"
  WHEN COUNT(*) = 3 THEN "Regular Customer(3 Purchases)"
  ELSE "High Frequency Customer(>3 Purchases)" 
END AS bucket
 FROM olist_customers_dataset c 
JOIN olist_orders_dataset o 
ON o.customer_id=c.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(*) >=1)t
GROUP BY bucket
ORDER BY bucket);


ALTER VIEW customer_retention AS
SELECT bucket, COUNT(*) AS customer_count
FROM (SELECT c.customer_unique_id,
CASE 
  WHEN COUNT(*) =1 THEN "Single Purchase Customer"
  WHEN COUNT(*) =2 THEN "Repeat Customer(2 Purchases)"
  WHEN COUNT(*) =3 THEN "Regular Customer(3 Purchases)"
  ELSE "High Frequency Customer(>3 Purchases)"
END AS bucket
  FROM olist_orders_dataset o 
  JOIN olist_customers_dataset c 
  ON o.customer_id = c.customer_id
  GROUP BY c.customer_unique_id)t
GROUP BY bucket
ORDER BY 
  CASE 
    WHEN bucket = "Single Purchase Customer" THEN 1
    WHEN bucket = "Repeat Customer(2 Purchases)" THEN 2
    WHEN bucket = "Regular Customer(3 Purchases)" THEN 3
    ELSE 4
  END;

# 2. New customer acquisition over time:

SELECT DATE_FORMAT(t.first_order, '%Y-%m') AS month,
COUNT(*) AS new_customers
FROM 
(SELECT c.customer_unique_id,
MIN(o.order_purchase_timestamp) AS first_order
FROM olist_customers_dataset c
JOIN olist_orders_dataset o
ON o.customer_id = c.customer_id
GROUP BY c.customer_unique_id
) t
GROUP BY month
ORDER BY month;

CREATE VIEW monthly_new_customer_acquisition AS
SELECT DATE_FORMAT(t.first_order,'%Y-%m') AS Month,
COUNT(*) AS New_Customers
FROM 
(SELECT c.customer_unique_id,
MIN(order_purchase_timestamp) AS first_order
FROM olist_customers_dataset c 
JOIN olist_orders_dataset o
ON c.customer_id = o.customer_id
GROUP BY customer_unique_id ) t 
GROUP BY Month
ORDER BY Month;


#3. Most Valuable Customer:

SELECT DISTINCT c.customer_id AS Most_valuable_customer, SUM(p.payment_value) AS Total_purchase_dollars
FROM olist_customers_dataset c JOIN olist_orders_dataset o 
ON c.customer_id = o.customer_id
JOIN olist_order_payments_dataset p
ON o.order_id = p.order_id
GROUP BY c.customer_id
ORDER BY Total_purchase_dollars DESC
LIMIT 1;

#4. City wise Customer Segragation

SELECT customer_state AS State, customer_city AS City, COUNT(DISTINCT customer_id) AS Customers
FROM olist_customers_dataset 
GROUP BY customer_state, customer_city;

CREATE VIEW City_wise_Customer_Segragation AS
SELECT customer_state AS State, customer_city AS City, COUNT(DISTINCT customer_id) AS Customers
FROM olist_customers_dataset
GROUP BY customer_state, customer_city;

/* 3. Logistics Analysis: */

#1. Delivery Delay:

SELECT order_id AS Orders,
(DATEDIFF(order_purchase_timestamp,order_delivered_customer_date)- 
DATEDIFF(order_purchase_timestamp,order_estimated_delivery_date))
AS Deliver_delay_by_days FROM olist_orders_dataset;

CREATE VIEW Delivery_delay AS
SELECT order_id AS Orders,
(DATEDIFF(order_purchase_timestamp,order_delivered_customer_date)- 
DATEDIFF(order_purchase_timestamp,order_estimated_delivery_date))
AS Deliver_delay_by_days FROM olist_orders_dataset;

#2.Late delivery Ratio:

SELECT "Late Delivery" AS TABLE_NAME, 
(SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date 
 THEN 1 ELSE 0 END) / COUNT(order_id) * 100) AS Order_Pct
FROM olist_orders_dataset ;

CREATE VIEW late_delivery_percentage AS
SELECT "Late Delivery" AS TABLE_NAME, 
(SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date 
 THEN 1 ELSE 0 END) / COUNT(order_id) * 100) AS Order_Pct
FROM olist_orders_dataset ;



/* 4. Review Analysis: */

#1. Top 10 product Category by Review:

SELECT p.product_category_name AS Category ,
e.product_category_name_english AS Category_English,
SUM(r.review_score)/COUNT(r.order_id) AS Average_review_score
FROM  olist_order_reviews_dataset r JOIN olist_order_items_dataset i
ON r.order_id = i.order_id 
JOIN olist_products_dataset p 
ON i.product_id = p.product_id
JOIN product_category_name_translation e
ON p.product_category_name = e.product_category_name
GROUP BY p.product_category_name,e.product_category_name_english
ORDER BY Average_review_score DESC
LIMIT 10;

CREATE VIEW Top_10_product_category_by_Review AS
SELECT p.product_category_name AS Category ,
e.product_category_name_english AS Category_English,
SUM(r.review_score)/COUNT(r.order_id) AS Average_review_score
FROM  olist_order_reviews_dataset r JOIN olist_order_items_dataset i
ON r.order_id = i.order_id 
JOIN olist_products_dataset p 
ON i.product_id = p.product_id
JOIN product_category_name_translation e
ON p.product_category_name = e.product_category_name
GROUP BY p.product_category_name,e.product_category_name_english
ORDER BY Average_review_score DESC
LIMIT 10;

#2. Impact of Delay on Review:

SELECT "Avg Review Score" AS TABLE_NAME,
 AVG(r.review_score) AS Overall, 
 AVG(CASE WHEN o.order_delivered_customer_date < o.order_estimated_delivery_date 
 THEN r.review_score END) AS No_delivery_delay, 
 AVG(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date 
 THEN r.review_score END) AS Delayed_delivery
FROM olist_orders_dataset o JOIN olist_order_reviews_dataset r
ON o.order_id = r.order_id;

CREATE VIEW Impact_of_Delivery_Delay_on_Review AS
SELECT AVG(r.review_score) AS Overall,
AVG(CASE WHEN o.order_delivered_customer_date < o.order_estimated_delivery_date 
THEN r.review_score END) AS No_Delivery_Delay,
AVG(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
THEN r.review_score END) AS Delayed_Delivery
FROM olist_orders_dataset o 
JOIN olist_order_reviews_dataset r
ON o.order_id = r.order_id;

/* 5. Product Analysis: */

#1. Best Selling Product Categories:

SELECT p.product_category_name AS Best_Sold_Categories,
t.product_category_name_english AS Best_Sold_Categories_English,
COUNT(i.order_id) AS Total_Ordered
FROM olist_products_dataset p JOIN olist_order_items_dataset i
ON p.product_id = i.product_id
JOIN product_category_name_translation t
ON p.product_category_name = t.product_category_name
GROUP BY p.product_category_name, t.product_category_name_english
ORDER BY Total_Ordered DESC
LIMIT 10;

CREATE VIEW Top_10_Sold_Product_Categories AS
SELECT p.product_category_name AS Best_Sold_Categories,
t.product_category_name_english AS Best_Sold_Categories_English,
COUNT(i.order_id) AS Total_Ordered
FROM olist_products_dataset p JOIN olist_order_items_dataset i
ON p.product_id = i.product_id
JOIN product_category_name_translation t
ON p.product_category_name = t.product_category_name
GROUP BY p.product_category_name, t.product_category_name_english
ORDER BY Total_Ordered DESC
LIMIT 10;

#2. Low Rated Product categories:

SELECT p.product_category_name AS Worst_Rated_Categories,
t.product_category_name_english AS Worst_Rated_Categories_English,
AVG(r.review_score) AS Avg_Review_Score
FROM olist_order_reviews_dataset r JOIN olist_order_items_dataset i
ON r.order_id = i.order_id
JOIN olist_products_dataset p
ON p.product_id = i.product_id
JOIN product_category_name_translation t
ON p.product_category_name = t.product_category_name
GROUP BY p.product_category_name, t.product_category_name_english
ORDER BY Avg_Review_Score ASC
LIMIT 10;

CREATE VIEW low_rated_product_categories AS
SELECT p.product_category_name AS Worst_Rated_Categories,
t.product_category_name_english AS Worst_Rated_Categories_English,
AVG(r.review_score) AS Avg_Review_Score
FROM olist_order_reviews_dataset r JOIN olist_order_items_dataset i
ON r.order_id = i.order_id
JOIN olist_products_dataset p
ON p.product_id = i.product_id
JOIN product_category_name_translation t
ON p.product_category_name = t.product_category_name
GROUP BY p.product_category_name, t.product_category_name_english
ORDER BY Avg_Review_Score ASC
LIMIT 10;

#3. Price - Review Relationship:

SELECT (SELECT
  CASE
    WHEN price BETWEEN 0 AND 20 THEN '0-20'
    WHEN price BETWEEN 21 AND 50 THEN '21-50'
    WHEN price BETWEEN 51 AND 100 THEN '51-100'
    WHEN price BETWEEN 101 AND 200 THEN '101-200'
    WHEN price BETWEEN 201 AND 500 THEN '201-500'
    WHEN price BETWEEN 501 AND 1000 THEN '501-1000'
    WHEN price BETWEEN 1001 AND 2000 THEN '1001-2000'
    WHEN price BETWEEN 2001 AND 3000 THEN '2001-3000'
    WHEN price BETWEEN 3001 AND 4000 THEN '3001-4000'
    WHEN price BETWEEN 4001 AND 5000 THEN '4001-5000'
    WHEN price BETWEEN 5001 AND 10000 THEN '5001-10000'
ELSE '>10000'END AS Price_group) AS Price_Group,
AVG(review_score) AS Avg_review_score
FROM olist_order_items_dataset i JOIN 
olist_order_reviews_dataset r ON
i.order_id = r.order_id
GROUP BY Price_Group
ORDER BY 
CASE WHEN Price_Group LIKE '>%'
THEN CAST(SUBSTRING(Price_Group, 2) AS UNSIGNED)
ELSE CAST(SUBSTRING_INDEX(Price_Group, '-', 1) AS UNSIGNED)
END;

CREATE VIEW price_review_relationship AS
SELECT (SELECT
  CASE
    WHEN price BETWEEN 0 AND 20 THEN '0-20'
    WHEN price BETWEEN 21 AND 50 THEN '21-50'
    WHEN price BETWEEN 51 AND 100 THEN '51-100'
    WHEN price BETWEEN 101 AND 200 THEN '101-200'
    WHEN price BETWEEN 201 AND 500 THEN '201-500'
    WHEN price BETWEEN 501 AND 1000 THEN '501-1000'
    WHEN price BETWEEN 1001 AND 2000 THEN '1001-2000'
    WHEN price BETWEEN 2001 AND 3000 THEN '2001-3000'
    WHEN price BETWEEN 3001 AND 4000 THEN '3001-4000'
    WHEN price BETWEEN 4001 AND 5000 THEN '4001-5000'
    WHEN price BETWEEN 5001 AND 10000 THEN '5001-10000'
ELSE '>10000'END AS Price_group) AS Price_Group,
AVG(review_score) AS Avg_review_score
FROM olist_order_items_dataset i JOIN 
olist_order_reviews_dataset r ON
i.order_id = r.order_id
GROUP BY Price_Group
ORDER BY Avg_review_score;

ALTER VIEW price_review_relationship AS
SELECT (SELECT
  CASE
    WHEN price BETWEEN 0 AND 20 THEN '0-20'
    WHEN price BETWEEN 21 AND 50 THEN '21-50'
    WHEN price BETWEEN 51 AND 100 THEN '51-100'
    WHEN price BETWEEN 101 AND 200 THEN '101-200'
    WHEN price BETWEEN 201 AND 500 THEN '201-500'
    WHEN price BETWEEN 501 AND 1000 THEN '501-1000'
    WHEN price BETWEEN 1001 AND 2000 THEN '1001-2000'
    WHEN price BETWEEN 2001 AND 3000 THEN '2001-3000'
    WHEN price BETWEEN 3001 AND 4000 THEN '3001-4000'
    WHEN price BETWEEN 4001 AND 5000 THEN '4001-5000'
    WHEN price BETWEEN 5001 AND 10000 THEN '5001-10000'
ELSE '>10000'END AS Price_group) AS Price_Group,
AVG(review_score) AS Avg_review_score
FROM olist_order_items_dataset i JOIN 
olist_order_reviews_dataset r ON
i.order_id = r.order_id
GROUP BY Price_Group
ORDER BY
CASE WHEN Price_Group LIKE '>%'
THEN CAST(SUBSTRING(Price_Group, 2) AS UNSIGNED)
ELSE CAST(SUBSTRING_INDEX(Price_Group, '-', 1) AS UNSIGNED)
END;






