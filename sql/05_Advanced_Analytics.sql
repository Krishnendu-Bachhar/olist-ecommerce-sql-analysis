/**
Project: Olist Brazilian E-Commerce Analysis
Assignment: 05 – Advanced SQL Analytics
Description:
  - Window functions
  - Customer segmentation
  - Seller ranking
  - Growth analysis
**/



USE brazilian_ECommerce_dataset;

1. /** Top 10 customer By Revenue **/

SELECT c.customer_unique_id AS Customer , SUM(p.payment_value) AS Total_Revenue
FROM olist_customers_dataset c
JOIN olist_orders_dataset o
ON c.customer_id = o.customer_id
JOIN olist_order_payments_dataset p
ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
ORDER BY Total_Revenue DESC
LIMIT 10;

2. /** revenue Wise Seller Rank **/


SELECT 
RANK() OVER( ORDER BY seller_revenue DESC ) AS seller_rank, 
seller_id, seller_revenue
FROM 
(SELECT seller_id, SUM(price) AS seller_revenue
FROM olist_order_items_dataset 
GROUP BY seller_id) AS revenue_table;

CREATE VIEW seller_rank AS
SELECT 
RANK() OVER( ORDER BY seller_revenue DESC ) AS seller_rank, 
seller_id, seller_revenue
FROM 
(SELECT seller_id, SUM(price) AS seller_revenue
FROM olist_order_items_dataset 
GROUP BY seller_id) AS revenue_table;

3./** Month-Over-Month Revenue Growth **/ 

WITH monthly_sales AS 
(SELECT
DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS Month,
CAST(SUM(oi.price) AS DECIMAL(18,2)) AS Revenue
FROM olist_order_items_dataset oi
JOIN olist_orders_dataset o ON o.order_id = oi.order_id
GROUP BY Month)
SELECT
Month,
Revenue,
LAG(Revenue) OVER (ORDER BY Month) AS prev_month_revenue,
CASE WHEN LAG(Revenue) OVER (ORDER BY Month) IS NULL THEN NULL
     WHEN LAG(Revenue) OVER (ORDER BY Month) = 0 THEN NULL
ELSE 
CONCAT(CAST(((Revenue - LAG(Revenue) OVER (ORDER BY Month)) / LAG(Revenue)
OVER (ORDER BY Month)) * 100
AS DECIMAL(18,2)), '%')
END AS Growth_Rate
FROM monthly_sales;


CREATE VIEW month_over_month_growth_rate AS
( WITH monthly_sales AS 
(SELECT
DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS Month,
CAST(SUM(oi.price) AS DECIMAL(18,2)) AS Revenue
FROM olist_order_items_dataset oi
JOIN olist_orders_dataset o ON o.order_id = oi.order_id
GROUP BY Month)
SELECT
Month,
Revenue,
LAG(Revenue) OVER (ORDER BY Month) AS prev_month_revenue,
CASE WHEN LAG(Revenue) OVER (ORDER BY Month) IS NULL THEN NULL
     WHEN LAG(Revenue) OVER (ORDER BY Month) = 0 THEN NULL
ELSE 
CONCAT(CAST(((Revenue - LAG(Revenue) OVER (ORDER BY Month)) / LAG(Revenue)
OVER (ORDER BY Month)) * 100
AS DECIMAL(18,2)), '%')
END AS Growth_Rate
FROM monthly_sales);


4. /** Customer Segragation **/

WITH Customer_Purchase AS 
(SELECT c.customer_unique_id AS Customer,
SUM(oi.price) AS Total_Purchase
FROM olist_customers_dataset c JOIN 
olist_orders_dataset o  ON 
c.customer_id = o.customer_id JOIN
olist_order_items_dataset oi ON
o.order_id = oi.order_id
GROUP BY c.customer_unique_id)
SELECT CASE 
  WHEN Total_Purchase > 1000 THEN "Premium Customer" 
  WHEN Total_Purchase BETWEEN 300 AND 1000 THEN "Plus Customer"
  WHEN Total_Purchase BETWEEN 50 AND 300 THEN "Mid Value Customer"
  ELSE "Low Value Customer"
END AS Customer_Segment,
COUNT(*) AS Customers
FROM `Customer_Purchase`
GROUP BY Customer_Segment
ORDER BY Customer_Segment;

CREATE VIEW customer_segment AS
( WITH customer_purchase AS
 (SELECT c.customer_unique_id, SUM(oi.price) AS total_purchase
 FROM olist_customers_dataset c JOIN olist_orders_dataset o 
 ON c.customer_id = o.customer_id JOIN
 olist_order_items_dataset oi ON o.order_id = oi.order_id
 GROUP BY c.customer_unique_id)

 (SELECT CASE 
  WHEN total_purchase > 1000  THEN "Premium Customer" 
  WHEN total_purchase BETWEEN 300 AND 1000 THEN "Plus Customer"
  WHEN total_purchase BETWEEN 50 AND 300 THEN "Mid Value Customer"
  ELSE "Low Value Customer" 
 END AS Customer_Segment,
 COUNT(*) AS Customers
 FROM customer_purchase
 GROUP BY Customer_Segment
 ORDER BY Customers));
 
 