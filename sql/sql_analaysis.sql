-- name of tables
SELECT tablename
FROM pg_tables
WHERE schemaname = 'public';


--CUSTOMERS
SELECT * FROM customers;

-- sum of total delivered orders
SELECT SUM(payment_value) AS total_revenue FROM orders o
INNER JOIN payments p on o.order_id = p.order_id
WHERE o.order_status = 'delivered';

-- most ordered region
WITH cte AS (SELECT
	c.customer_state,
	c.customer_city,
	COUNT(o.order_id) AS count_of_orders,
	DENSE_RANK() OVER(PARTITION BY c.customer_state ORDER BY COUNT(o.order_id) DESC) AS rnk
FROM customers c
INNER JOIN orders o ON o.customer_id = c.customer_id
GROUP BY customer_state,c.customer_city
ORDER BY customer_state,rnk)

SELECT
	customer_state,
	customer_city,
	count_of_orders
FROM cte
WHERE rnk = 1;

--ORDERS
SELECT * FROM orders;

--count of orders by month
SELECT 
	TO_CHAR(order_purchase_timestamp::DATE, 'MM-YYYY') AS month_year,
	COUNT(order_id) AS count_of_orders
FROM orders
GROUP BY month_year
ORDER BY month_year;

------------------------

SELECT
	*,
	order_estimated_delivery_date::DATE - order_purchase_timestamp::DATE AS estimated_delivery_days
FROM orders;

--AVG estimated deliver days
SELECT
	ROUND(AVG(order_estimated_delivery_date::DATE - order_purchase_timestamp::DATE),2) AS AVG_estimated_delivery_days
FROM orders;

-- how many orders are late
SELECT
	COUNT(order_id) AS count_of_late_orders
FROM orders
WHERE order_delivered_customer_date IS NOT NULL AND order_delivered_customer_date::DATE > order_estimated_delivery_date::DATE;

--orders status
SELECT
	order_status,
	COUNT(order_id) AS count_of_orders,
	ROUND(COUNT(order_id) * 100.0/(SELECT COUNT(order_id) FROM orders),2)::text || '%' AS share_of_orders
FROM orders
GROUP BY order_status;

--ORDER_ITEMS
SELECT * FROM order_items;


--top 10 most saled products
SELECT
	product_id,
	COUNT(product_id) AS times_saled
FROM order_items
GROUP BY product_id
ORDER BY times_saled DESC
LIMIT 10;


-------------------------
SELECT 
    ROUND(AVG(price)::numeric, 2)::text || '%' AS avg_price,
    ROUND(AVG(freight_value)::numeric, 2)::text || '%' AS avg_freight,
    ROUND(AVG(freight_value)::numeric / AVG(price)::numeric * 100, 2)::text || '%' AS freight_percentage
FROM order_items;


--avg count of products in order
SELECT
	ROUND(AVG(count_of_products),2) AS avg_count_of_products
FROM
(SELECT
	order_id,
	COUNT(product_id) AS count_of_products
FROM order_items
GROUP BY order_id);

--PAYMENTS
SELECT * FROM payments;

--most used payment type
WITH cte AS (SELECT 
	payment_type, 
	COUNT(*) AS count_of_payment
FROM payments
GROUP BY payment_type)

SELECT
	payment_type AS most_used_payment_type,
	count_of_payment
FROM cte
WHERE count_of_payment = (SELECT MAX(count_of_payment) FROM cte);

--AVG payment installment
SELECT
	AVG(payment_installments) AS avg_payment_installment
FROM payments;

--total payment
SELECT
	SUM(payment_value) AS total_payment
FROM payments;


--PRODUCTS
SELECT * FROM products;

-- most saled products by category
SELECT
	product_category_name,
	total_revenue
FROM
(SELECT
	p.product_category_name,
	SUM(oi.price) AS total_revenue
FROM products p
INNER JOIN order_items oi ON oi.product_id = p.product_id
GROUP BY p.product_category_name)
ORDER BY total_revenue DESC
LIMIT 10;

--sales by product photos

WITH cte AS (
	SELECT
        p.product_id,
        p.product_photos_qty,
		CASE
			WHEN p.product_photos_qty > (SELECT AVG(product_photos_qty) FROM products) THEN 'More photos'
			ELSE 'Fewer photos'
		END AS photos_group
	FROM products p
	INNER JOIN order_items oi ON oi.product_id = p.product_id
)
SELECT
	photos_group,
	COUNT(photos_group) AS product_sales_by_photos
FROM cte
GROUP BY photos_group;

--SELLERS
SELECT * FROM sellers;

-- best seller
SELECT
	s.seller_id,
	ROUND(SUM(oi.price)::numeric,2) AS total_revenue
FROM sellers s
INNER JOIN order_items oi ON oi.seller_id = s.seller_id
GROUP BY s.seller_id
ORDER BY total_revenue DESC
LIMIT 1;

--more sellers in state
SELECT seller_state,
		COUNT(seller_id) AS count_of_seller
FROM sellers
GROUP BY seller_state
ORDER BY count_of_seller DESC;

--REVIEWS
SELECT * FROM reviews;

--avg score
SELECT
	AVG(review_score) AS avg_score
FROM reviews;

--catigories that gotten low grade
select * from orders;

SELECT
	p.product_category_name,
	COUNT(r.review_id) AS count_of_low_score
FROM products p
INNER JOIN order_items oi ON oi.product_id = p.product_id
INNER JOIN orders o ON o.order_id = oi.order_id
INNER JOIN reviews r ON r.order_id = o.order_id
WHERE review_score <= 2 AND review_score > 0
GROUP BY p.product_category_name
ORDER BY count_of_low_score DESC;