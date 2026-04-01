USE brazilian_ecommerce_dataset;

/*
Project: Olist Brazilian E-Commerce Analysis
Assignment: 03 – Business Metric Definitions
Author: Krishnendu Bachhar
Description:
  - Definition of core e-commerce KPIs
  - Revenue, Orders, Customers, AOV, GMV, Delivery, Reviews
  - Metrics defined before analysis
*/


# 1. Total Revenue

SELECT 
'All Time' AS period,
SUM(price) AS total_revenue_dollars
FROM olist_order_items_dataset;

CREATE VIEW Total_Revenue AS
SELECT "All Time" AS period,
SUM(price)AS total_revenue_dollars
FROM olist_order_items_dataset;

# 2. Total Orders
SELECT 
COUNT(DISTINCT order_id) AS total_orders
FROM olist_orders_dataset;

CREATE VIEW total_orders AS
SELECT "All Time" AS period,
COUNT(DISTINCT order_id) AS total_orders
FROM olist_orders_dataset;

# 3. Unique Customers
SELECT
COUNT(DISTINCT customer_unique_id) AS total_customers
FROM olist_customers_dataset;

CREATE VIEW total_customers AS
SELECT "All Time" AS period,
COUNT(DISTINCT customer_id) AS total_customers
FROM olist_customers_dataset;

ALTER VIEW total_customers AS 
SELECT "All Time" AS period,
COUNT(DISTINCT customer_unique_id) AS total_customers
FROM olist_customers_dataset;

# 4. Average Order Value (AOV)
SELECT
SUM(p.payment_value) / COUNT(DISTINCT o.order_id) AS average_order_value_dollars
FROM olist_order_payments_dataset p
JOIN olist_orders_dataset o ON p.order_id = o.order_id;

CREATE VIEW average_order_value AS
SELECT "AOV" AS metric,
SUM(p.payment_value) / COUNT(DISTINCT o.order_id) AS in_dollars
FROM olist_order_payments_dataset p
JOIN olist_orders_dataset o
ON p.order_id = o.order_id;

# 5. Gross Merchandise Value (GMV)

SELECT 
SUM(price) AS GMV_dollars
FROM olist_order_items_dataset;

CREATE VIEW gross_merchandise_value AS
SELECT "GMV" AS metric,
SUM(price) AS in_dollars
FROM olist_order_items_dataset;

# 6. Average Delivery Time (in days)

SELECT AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp))
AS average_delivery_time_days
FROM olist_orders_dataset
WHERE order_delivered_customer_date IS NOT NULL;

CREATE VIEW average_delivery_time AS
SELECT "Average Delivery Time" AS metrics,
AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)) AS Days
FROM olist_orders_dataset
WHERE order_delivered_customer_date IS NOT NULL;

# 7. Top 10 Fastest Delivery Times (in days)
 
SELECT order_id, DATEDIFF(order_delivered_customer_date, order_purchase_timestamp) AS delivery_time_days
FROM olist_orders_dataset
WHERE order_delivered_customer_date IS NOT NULL
ORDER BY delivery_time_days ASC
LIMIT 10;

#Most Delayed Deliveries:

 SELECT bucket, COUNT(*) AS Customer_Count FROM
(SELECT 
 DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp) AS delivery_time_days,
  CASE 
  WHEN DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp) BETWEEN 13 AND 30 THEN " Delay (13-30 Days)"
  WHEN DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp) BETWEEN 31 AND 45 THEN "Significant Delay (31-45 Days)"
  WHEN DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp) BETWEEN 46 AND 90 THEN "Much Delay (46-90 Days)"
  WHEN DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp) BETWEEN 91 AND 180 THEN "Extreme Delay (91-180 Days)"
  WHEN DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp) > 180 THEN "Beyond Extreme Delay (>180 Days)"
  ELSE "Within Avg Delivery Time (12 Days)" 
END AS bucket
FROM olist_orders_dataset o
JOIN olist_customers_dataset c
ON o.customer_id=c.customer_id
GROUP BY o.order_id)t
GROUP BY bucket
ORDER BY 
CASE 
  WHEN bucket = "(13-30 Days) Delay" THEN 1
  WHEN bucket = "(31-45 Days)Significant Delay" THEN 2
  WHEN bucket = "(46-90 Days)Much Delay" THEN 3
  WHEN bucket = "(91-180 Days)Extreme Delay" THEN 4
  WHEN bucket = "(>180 Days)Beyond Extreme Delay" THEN 5
  ELSE 0
END;


CREATE VIEW delayed_delivery AS
SELECT bucket, COUNT(*) as Customer_Count FROM
(SELECT 
 DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp) AS delivery_time_days,
  CASE 
  WHEN DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp) BETWEEN 13 AND 30 THEN " Delay (13-30 Days)"
  WHEN DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp) BETWEEN 31 AND 45 THEN "Significant Delay (31-45 Days)"
  WHEN DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp) BETWEEN 46 AND 90 THEN "Much Delay (46-90 Days)"
  WHEN DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp) BETWEEN 91 AND 180 THEN "Extreme Delay (91-180 Days)"
  WHEN DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp) > 180 THEN "Beyond Extreme Delay (>180 Days)"
  ELSE "Within Avg Delivery Time (12 Days)" 
END AS bucket
FROM olist_orders_dataset o
JOIN olist_customers_dataset c
ON o.customer_id=c.customer_id
GROUP BY o.order_id)t
GROUP BY bucket
ORDER BY 
CASE 
  WHEN bucket = "(13-30 Days) Delay" THEN 1
  WHEN bucket = "(31-45 Days)Significant Delay" THEN 2
  WHEN bucket = "(46-90 Days)Much Delay" THEN 3
  WHEN bucket = "(91-180 Days)Extreme Delay" THEN 4
  WHEN bucket = "(>180 Days)Beyond Extreme Delay" THEN 5
  ELSE 0
END; 

ALTER VIEW delayed_delivery AS
SELECT
  bucket,
  COUNT(*) AS Customer_Count,
  ROUND(100 * COUNT(*) / t.total_orders, 2) AS pct_of_total
FROM (
  SELECT
    CASE 
      WHEN DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp) BETWEEN 13 AND 30
        THEN 'Delay (13-30 Days)'
      WHEN DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp) BETWEEN 31 AND 45
        THEN 'Significant Delay (31-45 Days)'
      WHEN DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp) BETWEEN 46 AND 90
        THEN 'Much Delay (46-90 Days)'
      WHEN DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp) BETWEEN 91 AND 180
        THEN 'Extreme Delay (91-180 Days)'
      WHEN DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp) > 180
        THEN 'Beyond Extreme Delay (>180 Days)'
      ELSE 'Within Avg Delivery Time (12 Days)'
    END AS bucket
  FROM olist_orders_dataset o
  JOIN olist_customers_dataset c
    ON o.customer_id = c.customer_id
  GROUP BY o.order_id
) t_buckets
CROSS JOIN (
  SELECT COUNT(*) AS total_orders
  FROM olist_orders_dataset
) t
GROUP BY bucket, t.total_orders
ORDER BY 
  CASE 
    WHEN bucket = 'Delay (13-30 Days)' THEN 1
    WHEN bucket = 'Significant Delay (31-45 Days)' THEN 2
    WHEN bucket = 'Much Delay (46-90 Days)' THEN 3
    WHEN bucket = 'Extreme Delay (91-180 Days)' THEN 4
    WHEN bucket = 'Beyond Extreme Delay (>180 Days)' THEN 5
    ELSE 0
  END;


# 8. Average Review Score

SELECT AVG(review_score) AS average_review_score
FROM olist_order_reviews_dataset;

CREATE VIEW average_review_score AS
SELECT "Average Review Score" AS metric,
AVG(review_score) AS stars
FROM olist_order_reviews_dataset;

# 9. Total Cancellations
SELECT COUNT(*) AS total_cancellations
FROM olist_orders_dataset
WHERE order_status = 'canceled';

CREATE VIEW total_cancellations AS
SELECT "Total Cancellations" AS metric,
COUNT(*) AS number
FROM olist_orders_dataset
WHERE order_status = 'canceled';

#10. Top 10 Highest Rated Products

SELECT p.product_category_name , t.product_category_name_english,
AVG(r.review_score) AS review_scores
FROM olist_order_items_dataset i
JOIN olist_order_reviews_dataset r ON i.order_id = r.order_id
JOIN olist_products_dataset p ON i.product_id = p.product_id
JOIN product_category_name_translation t 
ON p.product_category_name = t.product_category_name
GROUP BY p.product_category_name, t.product_category_name_english
ORDER BY review_scores DESC
LIMIT 10;

CREATE VIEW Top_10_Highest_Rated_Products AS
SELECT p.product_category_name , t.product_category_name_english,
AVG(r.review_score) AS avg_review_score
FROM olist_order_items_dataset i
JOIN olist_order_reviews_dataset r 
ON i.order_id = r.order_id
JOIN olist_products_dataset p 
ON i.product_id = p.product_id
JOIN product_category_name_translation t 
ON p.product_category_name = t.product_category_name
GROUP BY p.product_category_name, t.product_category_name_english
ORDER BY avg_review_score DESC
LIMIT 10;

