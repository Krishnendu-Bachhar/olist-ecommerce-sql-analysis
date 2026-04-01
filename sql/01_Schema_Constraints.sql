USE brazilian_ecommerce_dataset;
 # Assignment 1:
/*
Project: Olist Brazilian E-Commerce Analysis
Assignment: 01 – Schema Design & Integrity
Author: Krishnendu Bachhar
Date:23.02.2026
Description:
  - Primary key validation
  - Foreign key enforcement
  - Integrity checks
*/

#Identify the primary key


SELECT COUNT(DISTINCT customer_id) AS unique_customers,
COUNT(*) AS total_records
FROM olist_customers_dataset;
/**
 The primary key is customer_id since it uniquely identifies each record in the table.**/

SELECT 
COUNT(DISTINCT order_id) AS unique_orders,
COUNT(*) AS total_records
FROM olist_orders_dataset;

# The primary key is order_id since it uniquely identifies each record in the table.

ALTER TABLE olist_orders_dataset
ADD PRIMARY KEY (order_id);

ALTER TABLE olist_products_dataset
ADD PRIMARY KEY (product_id);

ALTER TABLE olist_sellers_dataset
ADD PRIMARY KEY (seller_id);

SELECT COUNT(*) AS total_rows,
COUNT(DISTINCT order_id, product_id, seller_id) AS distinct_rows
FROM olist_order_items_dataset;
# The combination of order_id, product_id, and seller_id serves as the composite primary key for the olist_order_items_dataset table.

ALTER TABLE olist_order_items_dataset
ADD PRIMARY KEY (order_id, order_item_id);

/* Add Foreign Key Constraints:*/

SELECT order_id, order_delivered_carrier_date
FROM olist_orders_dataset
WHERE order_delivered_carrier_date IS NOT NULL
AND CAST(order_delivered_carrier_date AS CHAR) = '0000-00-00 00:00:00';

UPDATE olist_orders_dataset
SET order_delivered_carrier_date = NULL
WHERE order_delivered_carrier_date IS NOT NULL
AND CAST(order_delivered_carrier_date AS CHAR) = '0000-00-00 00:00:00';

UPDATE olist_orders_dataset
SET order_delivered_customer_date = NULL
WHERE order_delivered_customer_date IS NOT NULL
AND CAST(order_delivered_customer_date  AS CHAR) = "0000-00-00 00:00:00";

UPDATE olist_orders_dataset
SET order_approved_at = NULL
WHERE order_approved_at IS NOT NULL
AND CAST(order_approved_at AS CHAR) = '0000-00-00 00:00:00';

# Null value handled for foreign key constraints

#1
ALTER TABLE olist_orders_dataset
ADD CONSTRAINT fk_customer 
FOREIGN KEY (customer_id)
REFERENCES olist_customers_dataset(customer_id);
#2
ALTER TABLE olist_order_items_dataset
ADD CONSTRAINT fk_order
FOREIGN KEY (order_id)
REFERENCES olist_orders_dataset(order_id);

ALTER TABLE olist_order_items_dataset
ADD CONSTRAINT fk_product
FOREIGN KEY (product_id)
REFERENCES olist_products_dataset(product_id);
#3
ALTER TABLE olist_order_payments_dataset
ADD CONSTRAINT fk_order_payment
FOREIGN KEY (order_id)
REFERENCES olist_orders_dataset(order_id);

# Null value handled for foreign key constraints
#4
ALTER TABLE olist_order_reviews_dataset
ADD CONSTRAINT fk_order_review
FOREIGN KEY (order_id)
REFERENCES olist_orders_dataset(order_id);

UPDATE olist_order_reviews_dataset
SET review_creation_date = NULL
WHERE review_creation_date IS NOT NULL
AND CAST(review_creation_date AS CHAR) = '0000-00-00 00:00:00';

UPDATE olist_order_reviews_dataset
SET review_answer_timestamp =NULL
WHERE review_answer_timestamp IS NOT NULL
AND CAST(review_answer_timestamp AS CHAR) = '0000-00-00 00:00:00';

/** Null value handled for foreign key constraints**/

/**Validating the Data Integrity After Adding Constraints**/

SELECT COUNT(*)
FROM olist_orders_dataset o
LEFT JOIN olist_customers_dataset c
ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;
/*   Count = 0 : perfect integrity  */


