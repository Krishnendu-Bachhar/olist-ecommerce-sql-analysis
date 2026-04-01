USE brazilian_ecommerce_dataset;

/*
Project: Olist Brazilian E-Commerce Analysis
Assignment: 02 – Data Quality & Profiling
Author: Krishnendu Bachhar
Date:24.02.2026
Description:
  - Row count validation
  - Null value analysis
  - Duplicate checks
  - Date range sanity checks
*/

/* Row Count Validation: Total Dataset Records */ 

SELECT 'customers' AS Table_Name, COUNT(*) AS Total_Records FROM olist_customers_dataset
UNION ALL
SELECT 'orders', COUNT(*) FROM olist_orders_dataset
UNION ALL
SELECT 'order_items', COUNT(*) FROM olist_order_items_dataset
UNION ALL
SELECT 'products', COUNT(*) FROM olist_products_dataset
UNION ALL
SELECT 'sellers', COUNT(*) FROM olist_sellers_dataset
UNION ALL
SELECT 'payments', COUNT(*) FROM olist_order_payments_dataset
UNION ALL
SELECT 'reviews', COUNT(*) FROM olist_order_reviews_dataset
UNION ALL
SELECT 'geolocation', COUNT(*) FROM olist_geolocation_dataset;

/* Null Value Analysis: Count of NULLs in Critical Columns */

# Customers
SELECT
  SUM(customer_id IS NULL) AS null_customer_id,
  SUM(customer_city IS NULL) AS null_city,
  SUM(customer_state IS NULL) AS null_state
FROM olist_customers_dataset;

# Orders

SELECT
 SUM (order_id IS NULL) AS null_order_id,
 SUM(customer_id IS NULL) AS null_customer_id,
 SUM(order_status IS NULL) AS null_order_status,
 SUM(order_purchase_timestamp IS NULL) AS null_purchase_timestamp,
 SUM(order_approved_at IS NULL) AS null_approved_at,
 SUM(order_delivered_carrier_date IS NULL) AS null_delivered_carrier_date,
 SUM(order_delivered_customer_date IS NULL) AS null_delivered_customer_date
FROM olist_orders_dataset;

/* Fixed null values previously */

# Order Items

SELECT 
SUM(order_id IS NULL) AS null_order_id,
SUM(product_id IS NULL) AS null_product_id,
SUM(seller_id IS NULL)  AS null_seller_id,
SUM(price IS NULL) AS null_price,
SUM(freight_value IS NULL) AS null_freight_value,
SUM(shipping_limit_date IS NULL) AS null_shipping_limit_date
FROM olist_order_items_dataset;

# review 

SELECT 
SUM(review_score IS NULL) AS null_score,
SUM(review_comment_message IS NULL) AS null_review
FROM olist_order_reviews_dataset;

SELECT review_comment_message FROM olist_order_reviews_dataset
WHERE review_comment_message IS NULL;

SELECT order_approved_at FROM olist_orders_dataset
WHERE  order_approved_at IS NULL;

/* Duplicate Checks: Identify Duplicate Records Based on Primary Keys */

# Customer - unique customers with miltiple customer IDs :

SELECT customer_unique_id, COUNT(DISTINCT customer_id) AS id_count
FROM olist_customers_dataset
GROUP BY customer_unique_id
HAVING id_count > 1;
/* 2997 unique customers have multiple customer IDs */

# Orders - check duplicate order IDs

SELECT order_id,COUNT(*) AS duplicate_count
FROM olist_orders_dataset
GROUP BY order_id
HAVING duplicate_count > 1;

/* No duplicate order IDs found */

/* Date Range & Sanity Checks: Validate Date Fields for Logical Consistency */

# Orders - Date Range 

SELECT  
MIN(order_purchase_timestamp) AS first_purchase,
MAX(order_purchase_timestamp) AS latest_purchase
FROM olist_orders_dataset;

# delivery sanity check: delivered date should be after purchase date
SELECT COUNT(*) AS invalid_delivery_dates
FROM olist_orders_dataset
WHERE order_delivered_customer_date< order_purchase_timestamp;
/* No invalid delivery dates found */


