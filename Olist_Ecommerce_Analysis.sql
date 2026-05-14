-- Q1: Total Revenue & Orders

-- Business question: What is the total revenue and total number of delivered orders?

SELECT
COUNT(DISTINCT o.order_id)    AS total_orders,
ROUND(SUM(oi.price), 2)       AS total_revenue,
ROUND(AVG(oi.price), 2)       AS avg_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';

-- Q2: Monthly Revenue Trend

-- Business question: How has revenue changed month over month?

SELECT
DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
COUNT(DISTINCT o.order_id)      AS orders,
ROUND(SUM(oi.price), 2)    AS revenue
FROM orders o 
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY 1;

-- Q3: Revenue by Order Status

-- Business question: How many orders are in each status? 
-- What revenue is at risk from non-delivered orders?

SELECT
o.order_status,
COUNT(DISTINCT o.order_id) AS total_orders,
ROUND(SUM(oi.price), 2)  AS total_value
FROM orders o 
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_status
ORDER BY total_orders DESC;

-- Q4: Top 10 Revenue Days

-- Business question: Which specific days generated the most revenue?

SELECT
DATE(o.order_purchase_timestamp)  AS order_date,
COUNT(DISTINCT o.order_id) AS orders,
ROUND(SUM(oi.price), 2)  AS revenue
FROM orders o 
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY 1
ORDER BY revenue DESC
LIMIT 10;

-- Q5: Orders per Customer

-- Business question: How many customers placed more than one order?

SELECT
c.customer_unique_id,
COUNT(o.order_id) AS total_orders,
ROUND(SUM(oi.price), 2) AS total_spent
FROM customers c
JOIN orders o  ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_unique_id
HAVING COUNT(o.order_id) > 1
ORDER BY total_orders DESC;

-- Q6: Top Customer States by Orders

-- Business question: Which Brazillian states have the most customers and highest spend?

SELECT
c.customer_state,
COUNT(DISTINCT c.customer_unique_id)  AS unique_customers,
COUNT(DISTINCT o.order_id)   AS total_orders,
ROUND(SUM(oi.price), 2)  AS total_revenue
FROM customers c 
JOIN orders o   ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY total_revenue DESC;

-- Q7: Top 10 Cities by Orders

-- Business question: Which cities generate the most orders?

SELECT
c.customer_city,
c.customer_state,
COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c 
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_city, c.customer_state
ORDER BY total_orders DESC
LIMIT 10;

-- Q8: Customers Segmentation by Spend (RFM-lite)

-- Business question: Segment customers into High / Mid / Low value based on total spend.

WITH customer_spend AS (
    SELECT
    c.customer_unique_id,
    ROUND(SUM(oi.price), 2) AS total_spent
    FROM customers c 
    JOIN orders o  ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
CASE
WHEN total_spent >= 500 THEN 'High Value'
WHEN total_spent >= 200 THEN 'Mid Value'
ELSE 'Low Value'
END AS segment,
COUNT(*) AS customer_count,
ROUND(AVG(total_spent), 2) AS avg_spend
FROM customer_spend
GROUP BY segment
ORDER BY avg_spend DESC;

-- Q9: Top 10 Product Categories by Revenue

-- Business question: Which product categories generate the most revenue?

SELECT 
t.product_category_name_english  AS category,
COUNT(DISTINCT oi.order_id)   AS total_orders,
ROUND(SUM(oi.price), 2)        AS total_revenue,
ROUND(AVG(oi.price), 2)       AS avg_price
FROM order_items oi 
JOIN products p ON oi.product_id = p.product_id
JOIN product_category_translation t 
ON p.product_category_name = t.product_category_name
GROUP BY t.product_category_name_english
ORDER BY total_revenue DESC
LIMIT 10;

-- Q10: Most Reviewed Products

-- Business question: Which products have the most reviews and what is their average score?

SELECT
oi.product_id,
t.product_category_name_english  AS category,
COUNT(r.review_id)          AS total_reviews,
ROUND(AVG(r.review_score), 2) AS avg_score
FROM order_items oi 
JOIN products p ON oi.product_id = p.product_id
JOIN product_category_translation t 
ON p.product_category_name = t.product_category_name
JOIN order_reviews r ON oi.order_id = r.order_id
GROUP BY oi.product_id, t.product_category_name_english
ORDER BY total_reviews DESC
LIMIT 15;

-- Q11: Average Rating by Category

-- Business question: Which categories have the best and worst customer satisfaction?

SELECT
t.product_category_name_english  AS category,
COUNT(r.review_id)               AS review_count,
ROUND(AVG(r.review_score), 2)    AS avg_rating
FROM order_items oi 
JOIN products p  ON oi.product_id = p.product_id
JOIN product_category_translation t 
ON p.product_category_name = t.product_category_name
JOIN order_reviews r ON oi.order_id = r.order_id
GROUP BY t.product_category_name_english
HAVING COUNT(r.review_id) > 100
ORDER BY avg_rating DESC;

-- Q12: Price Distribution by Category

-- Business question: What is the price range and median price per category?

SELECT
t.product_category_name_english   AS category,
ROUND(MIN(oi.price), 2)      AS min_price,
ROUND(MAX(oi.price), 2)      AS max_price,
ROUND(AVG(oi.price), 2)      AS avg_price,
ROUND(PERCENTILE_CONT(0.5)
WITHIN GROUP (ORDER BY oi.price)::numeric, 2) AS median_price
FROM order_items oi 
JOIN products p ON oi.product_id = p.product_id
JOIN product_category_translation t 
ON p.product_category_name = t.product_category_name
GROUP BY t.product_category_name_english
ORDER BY avg_price DESC;

-- Q13: Top 10 Sellers by Revenue

-- Business question: Who are the top-performing sellers on the platform?

SELECT
oi.seller_id,
s.seller_city,
s.seller_state,
COUNT(DISTINCT oi.order_id)    AS total_orders,
ROUND(SUM(oi.price), 2)        AS total_revenue
FROM order_items oi 
JOIN sellers s ON oi.seller_id = s.seller_id
GROUP BY oi.seller_id, s.seller_city, s.seller_state
ORDER BY total_revenue DESC
LIMIT 10;

-- Q14: Seller Count & Revenue by State

-- Business question: Which states have the most active sellers and highest sales?

SELECT 
s.seller_state,
COUNT(DISTINCT s.seller_id)   AS seller_count,
COUNT(DISTINCT oi.order_id)   AS total_orders,
ROUND(SUM(oi.price), 2)       AS total_revenue
FROM sellers s 
JOIN order_items oi ON s.seller_id = oi.seller_id
GROUP BY s.seller_state
ORDER BY total_revenue DESC;

-- Q15: Seller Average Review Score

-- Business question: Which sellers have the best and worst customer ratings?

WITH seller_ratings AS (
    SELECT
    oi.seller_id,
    COUNT(r.review_id)       AS review_count,
    ROUND(AVG(r.review_score), 2)   AS avg_rating
    FROM order_items oi    
    JOIN order_reviews r ON oi.order_id = r.order_id
    GROUP BY oi.seller_id
    HAVING COUNT(r.review_id) >= 50
)
SELECT
sr.seller_id,
s.seller_state,
sr.review_count,
sr.avg_rating
FROM seller_ratings sr 
JOIN sellers s ON sr.seller_id = s.seller_id
ORDER BY sr.avg_rating DESC;

-- Q16: Seller Revenue Rank (Window Function)

-- Business question: Rank all sellers by revenue within their state.

SELECT
s.seller_id,
s.seller_state,
ROUND(SUM(oi.price), 2) AS revenue,
RANK() OVER(
    PARTITION BY s.seller_state
    ORDER BY SUM (oi.price) DESC
) AS state_rank
FROM sellers s 
JOIN order_items oi ON s.seller_id = oi.seller_id
GROUP BY s.seller_id, s.seller_state
ORDER BY s.seller_state, state_rank;

-- Q17: Average Delivery Time by State

-- Business question: Which states experience the fastest and slowest delivery times?

SELECT
c.customer_state,
ROUND(AVG(
    DATE_PART('day',
    o.order_delivered_customer - o.order_purchase_timestamp)
)::numeric, 1) AS avg_delivery_days,
COUNT(*) AS delivered_orders
FROM orders o 
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
AND o.order_delivered_customer IS NOT NULL
GROUP BY c.customer_state
ORDER BY avg_delivery_days ASC;

-- Q18: Late Delivery Rate

-- Business question: What percentage of orders were delivered after the estimated date?

SELECT
COUNT(*) AS total_delivered,
SUM(CASE WHEN
o.order_delivered_customer > o.order_estimated_delivery
THEN 1 ELSE 0
END) AS late_orders,
ROUND(
    100.0 * SUM(CASE WHEN
    o.order_delivered_customer > o.order_estimated_delivery
    THEN 1 ELSE 0
    END) / COUNT(*), 2
) AS late_percentage
FROM orders o 
WHERE o.order_status = 'delivered'
AND o.order_delivered_customer IS NOT NULL
AND o.order_estimated_delivery IS NOT NULL;

-- Q19: Payment Type Breakdown

-- Business question: What payment methods do customers prefer?
-- What is average installment count per method?

SELECT
payment_type,
COUNT(*)               AS total_transactions,
ROUND(SUM(payment_value), 2)   AS total_value,
ROUND(AVG(payment_value), 2)   AS avg_value,
ROUND(AVG(payment_installments), 1) AS avg_installments
FROM order_payments
GROUP BY payment_type
ORDER BY total_transactions DESC;

-- Q20: Review Score vs Delivery Speed (Correlation)

-- Business question: Do faster deliveries lead to better review scores?

WITH delivery_reviews AS (
    SELECT
    r.review_score,
    DATE_PART('day',
    o.order_delivered_customer - o.order_purchase_timestamp
    ) AS delivery_days
    FROM orders o   
    JOIN order_reviews r ON o.order_id = r.order_id
    WHERE o.order_status = 'delivered'
    AND o.order_delivered_customer IS NOT NULL
) 
SELECT
review_score,
COUNT(*)          AS order_count,
ROUND(AVG(delivery_days)::numeric, 1)   AS avg_delivery_days
FROM delivery_reviews
GROUP BY review_score
ORDER BY review_score DESC;
