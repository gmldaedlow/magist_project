
/*** Explore magist DB ***/

USE magist;

-- 1. how many orders
SELECT COUNT(*) AS orders_count FROM orders;

-- 2. how many orders are delivered, canceled or unavailable
SELECT order_status, COUNT(order_status) FROM orders
GROUP BY order_status;

-- 2b. what happens to unavailable parcels?
SELECT review_comment_message FROM order_reviews
LEFT JOIN orders ON orders.order_id=order_reviews.order_id
WHERE order_status="unavailable";

-- 3. user growth? 
SELECT YEAR(order_purchase_timestamp), MONTH(order_purchase_timestamp), COUNT(order_id) FROM orders
GROUP BY MONTH(order_purchase_timestamp), YEAR(order_purchase_timestamp)
ORDER BY YEAR(order_purchase_timestamp), MONTH(order_purchase_timestamp) ASC;

-- 4. how many products
SELECT COUNT(DISTINCT product_id) FROM products;

-- 5. categories with most products
SELECT product_category_name, COUNT(DISTINCT product_id) AS products_per_category FROM products
GROUP BY product_category_name
ORDER BY products_per_category DESC;

-- 6. how many products were present in transactions?
SELECT COUNT(DISTINCT product_id) FROM order_items;

-- 7. cheapest and most expensive price?
SELECT MAX(price) AS max, MIN(price) AS min, AVG(price) AS avg FROM order_items;

-- 8. min and max order payments
SELECT MAX(payment_value) AS max, MIN(payment_value) AS min, AVG(payment_value) AS avg FROM order_payments;

-- 9. how many products per order
SELECT COUNT(product_id) AS prod_per_order, order_id FROM order_items
GROUP BY order_id
ORDER BY prod_per_order DESC;

-- 10. ratings/reviews
SELECT AVG(review_score) AS avg_review_score, YEAR(review_creation_date) AS year, MAX(review_score) AS max_rev, MIN(review_score) AS min_rev
FROM order_reviews
GROUP BY YEAR(review_creation_date)
ORDER BY YEAR(review_creation_date) DESC;


-- 11. how long does it take to deliver parcels?
SELECT order_id, TIMESTAMPDIFF(DAY, order_purchase_timestamp, order_delivered_carrier_date)
FROM orders;

SELECT order_id, DAY(order_purchase_timestamp) - DAY(order_delivered_carrier_date) AS DELIVERY_DAY
FROM orders;

-- 12. how exact is the estimated delivery? HUGE!
SELECT AVG(TIMESTAMPDIFF(DAY, order_estimated_delivery_date, order_delivered_carrier_date))
FROM orders;

