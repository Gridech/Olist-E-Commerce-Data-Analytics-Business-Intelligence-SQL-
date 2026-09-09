-- Business Overview

-- Count Total Orders
SELECT COUNT(*) AS total_orders
FROM olist_orders;

-- Count Total Customers
SELECT COUNT(*) AS total_customers
FROM customers;

-- Count Total Products
SELECT COUNT(*) AS total_products
FROM olist_products;

-- Calculate Total Revenue
SELECT SUM(payment_value) AS total_revenue
FROM olist_orders AS o
         LEFT JOIN order_payments AS p ON o.order_id = p.order_id
WHERE o.order_status NOT IN ('unavailable', 'canceled');

-- Calculate Average Order Value (AOV)
SELECT AVG(payment_value) AS average_order_value
FROM order_payments;

-- Calculate Average Orders per Customer
SELECT COUNT(*) / COUNT(DISTINCT customer_id) AS average_orders_per_customer
FROM olist_orders;

-- Calculate Average Products per Order
SELECT COUNT(*) / COUNT(DISTINCT order_id) AS average_products_per_order
FROM order_items;

-- Calculate Average Revenue Per User (ARPU)
SELECT SUM(payment_value) / COUNT(DISTINCT customer_id) AS average_revenue_per_user
FROM olist_orders AS o
         LEFT JOIN order_payments AS p ON o.order_id = p.order_id
WHERE o.order_status NOT IN ('unavailable', 'canceled');

-- Calculate Daily Revenue
SELECT DAYNAME(order_purchase_timestamp),
       SUM(payment_value) AS daily_revenue
FROM olist_orders AS o
         LEFT JOIN order_payments AS p ON o.order_id = p.order_id
WHERE o.order_status NOT IN ('unavailable', 'canceled')
GROUP BY DAYNAME(order_purchase_timestamp)
ORDER BY daily_revenue desc;

-- 10. Calculate Weekly Revenue
SELECT EXTRACT(WEEK FROM order_purchase_timestamp),
       SUM(payment_value) AS weekly_revenue
FROM olist_orders AS o
         LEFT JOIN order_payments AS p ON o.order_id = p.order_id
WHERE o.order_status NOT IN ('unavailable', 'canceled')
GROUP BY EXTRACT(WEEK FROM order_purchase_timestamp)
ORDER BY EXTRACT(WEEK FROM order_purchase_timestamp);

-- 11. Calculate Monthly Revenue
SELECT EXTRACT(MONTH FROM order_purchase_timestamp),
       SUM(payment_value) AS weekly_revenue
FROM olist_orders AS o
         LEFT JOIN order_payments AS p ON o.order_id = p.order_id
WHERE o.order_status NOT IN ('unavailable', 'canceled')
GROUP BY EXTRACT(WEEK FROM order_purchase_timestamp)
ORDER BY EXTRACT(WEEK FROM order_purchase_timestamp);

-- 12. Find Highest Revenue Month
SELECT MONTH(order_purchase_timestamp) AS month,
       SUM(payment_value)              AS max_total_revenue
FROM olist_orders AS o
         LEFT JOIN order_payments AS p ON o.order_id = p.order_id
WHERE o.order_status NOT IN ('unavailable', 'canceled')
GROUP BY MONTH(order_purchase_timestamp)
ORDER BY SUM(payment_value) DESC
LIMIT 1;

-- 13. Find Highest Revenue Day of Each Month
WITH DailyRevenue AS (SELECT EXTRACT(MONTH FROM order_purchase_timestamp) AS revenue_month,
                             EXTRACT(DAY FROM order_purchase_timestamp)   AS revenue_date,
                             SUM(payment_value)                           AS daily_revenue
                      FROM olist_orders AS o
                               LEFT JOIN order_payments AS p ON o.order_id = p.order_id
                      WHERE o.order_status NOT IN ('unavailable', 'canceled')
                      GROUP BY EXTRACT(MONTH FROM order_purchase_timestamp), EXTRACT(DAY FROM order_purchase_timestamp)
                      ORDER BY EXTRACT(MONTH FROM order_purchase_timestamp),
                               EXTRACT(DAY FROM order_purchase_timestamp)),
     RankedDays AS (SELECT revenue_month,
                           revenue_date,
                           daily_revenue,
                           ROW_NUMBER() OVER (
                               PARTITION BY revenue_month
                               ORDER BY daily_revenue DESC
                               ) AS rank_idx
                    FROM DailyRevenue)
SELECT revenue_month,
       revenue_date  AS highest_revenue_day,
       daily_revenue AS revenue_amount
FROM RankedDays
WHERE rank_idx = 1
ORDER BY revenue_month;

-- 14. Find Peak Sales Month of Each Year
WITH MonthlyOrders AS (SELECT EXTRACT(YEAR FROM o.order_purchase_timestamp)  AS order_year,
                              EXTRACT(MONTH FROM o.order_purchase_timestamp) AS order_month,
                              COUNT(o.order_id)                              AS total_monthly_orders
                       FROM olist_orders AS o
                       WHERE o.order_status NOT IN ('unavailable', 'canceled')
                       GROUP BY EXTRACT(YEAR FROM o.order_purchase_timestamp),
                                EXTRACT(MONTH FROM o.order_purchase_timestamp)),
     RankedMonths AS (SELECT order_year,
                             order_month,
                             total_monthly_orders,
                             ROW_NUMBER() OVER (
                                 PARTITION BY order_year
                                 ORDER BY total_monthly_orders DESC
                                 ) AS rank_idx
                      FROM MonthlyOrders)
SELECT order_year,
       order_month          AS highest_sales_month,
       total_monthly_orders AS highest_order_count
FROM RankedMonths
WHERE rank_idx = 1
ORDER BY order_year;

-- 15. Find Peak Sales Day of Each Month
WITH DailyOrders AS (SELECT EXTRACT(MONTH FROM o.order_purchase_timestamp) AS order_month,
                            EXTRACT(DAY FROM o.order_purchase_timestamp)   AS order_day,
                            COUNT(o.order_id)                              AS total_daily_orders
                     FROM olist_orders AS o
                     WHERE o.order_status NOT IN ('unavailable', 'canceled')
                     GROUP BY EXTRACT(MONTH FROM o.order_purchase_timestamp),
                              EXTRACT(DAY FROM o.order_purchase_timestamp)),
     RankedDays AS (SELECT order_month,
                           order_day,
                           total_daily_orders,
                           ROW_NUMBER() OVER (
                               PARTITION BY order_month
                               ORDER BY total_daily_orders DESC
                               ) AS rank_idx
                    FROM DailyOrders)
SELECT order_month,
       order_day          AS highest_sales_day,
       total_daily_orders AS highest_order_count
FROM RankedDays
WHERE rank_idx = 1
ORDER BY order_month;

-- 16. Find Busiest Day of the Week
SELECT DAYNAME(order_purchase_timestamp) AS day_of_week,
       COUNT(o.order_id)                 AS daily_revenue
FROM olist_orders AS o
         LEFT JOIN order_payments AS p ON o.order_id = p.order_id
WHERE o.order_status NOT IN ('unavailable', 'canceled')
GROUP BY DAYNAME(order_purchase_timestamp)
ORDER BY daily_revenue desc;

-- 17. Find Peak Ordering Hour
SELECT HOUR(order_purchase_timestamp) AS ordering_hour,
       COUNT(o.order_id)              AS daily_revenue
FROM olist_orders AS o
         LEFT JOIN order_payments AS p ON o.order_id = p.order_id
WHERE o.order_status NOT IN ('unavailable', 'canceled')
GROUP BY HOUR(order_purchase_timestamp)
ORDER BY daily_revenue desc;


-- 18. Find Orders Worth More Than a Threshold
WITH OrderTotals AS (SELECT order_id,
                            SUM(price) AS total_order_value
                     FROM order_items
                     GROUP BY order_id),
     OrderPercentiles AS (SELECT order_id,
                                 total_order_value,
                                 CUME_DIST() OVER (ORDER BY total_order_value) AS value_percentile
                          FROM OrderTotals)
SELECT CASE
           WHEN op.total_order_value >= 500.00 THEN '4. High-Value Outliers (>= R$ 500)'
           WHEN op.value_percentile >= 0.75 THEN '3. Premium Orders (>= 75th Percentile)'
           WHEN op.value_percentile > 0.5 THEN '2. Above Average (>= 50th Percentile)'
           ELSE '1. Standard/Low Value'
           END                             AS order_category,
       COUNT(DISTINCT op.order_id)         AS total_orders,
       ROUND(SUM(op.total_order_value), 2) AS total_revenue_brl
FROM OrderPercentiles op
GROUP BY order_category
ORDER BY order_category;

-- 19. Find Highest Revenue Order for Each Customer
SELECT customer_id,
       MAX(payment_value) AS highest_revenue_order
FROM olist_orders AS o
         LEFT JOIN order_payments AS p ON o.order_id = p.order_id
WHERE o.order_status NOT IN ('unavailable', 'canceled')
GROUP BY customer_id
ORDER BY highest_revenue_order DESC;

-- 20. Compare Delivered vs Cancelled Orders
SELECT order_status,
       COUNT(order_id)                                      AS total_orders,
       COUNT(order_id) / SUM(COUNT(order_id)) OVER () * 100 AS percentage
FROM olist_orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- 21. Calculate Order Cancellation Rate
SELECT DATE_FORMAT(order_purchase_timestamp, '%Y-%m')                             AS month,
       COUNT(*)                                                                   AS total_orders,
       COUNT(CASE WHEN order_status = 'canceled' THEN 1 END)                      AS cancelled_orders,
       ROUND(AVG(CASE WHEN order_status = 'canceled' THEN 1 ELSE 0 END) * 100, 2) AS cancellation_rate_percent
FROM olist_orders
GROUP BY DATE_FORMAT(order_purchase_timestamp, '%Y-%m')
ORDER BY month DESC;

-- 22. Calculate Average Delivery Time
SELECT DATE_FORMAT(order_purchase_timestamp, '%Y-%m')                                  AS month,
       AVG(TIMESTAMPDIFF(DAY, order_purchase_timestamp, order_delivered_carrier_date)) AS average_delivery_days
FROM olist_orders
WHERE order_status = 'delivered'
GROUP BY DATE_FORMAT(order_purchase_timestamp, '%Y-%m')
ORDER BY month DESC;

-- 23. Calculate Average Delivery Delay
SELECT DATE_FORMAT(order_purchase_timestamp, '%Y-%m')                           AS month,
       AVG(TIMESTAMPDIFF(DAY, order_approved_at, order_delivered_carrier_date)) AS average_delivery_delay_days
FROM olist_orders
WHERE order_status = 'delivered'
GROUP BY DATE_FORMAT(order_purchase_timestamp, '%Y-%m')
ORDER BY month DESC;

-- 24. Find Best Selling Product
SELECT product_id,
       COUNT(order_item_id) AS total_sales
FROM order_items
GROUP BY product_id
ORDER BY total_sales DESC
LIMIT 1;

-- 25. Find Top-Selling Products
SELECT product_id,
       COUNT(order_item_id) AS total_sales
FROM order_items
GROUP BY product_id
ORDER BY total_sales DESC;

-- 26. Find 20 Highest Revenue Products
SELECT product_id,
       SUM(price) AS total_revenue
FROM order_items
GROUP BY product_id
ORDER BY total_revenue DESC
LIMIT 20;

-- 27. Find 20 Lowest Revenue Products
SELECT product_id,
       SUM(price) AS total_revenue
FROM order_items
GROUP BY product_id
ORDER BY total_revenue
LIMIT 20;

-- 28. Find Most Expensive Product Sold
SELECT product_id,
       MAX(price) AS most_expensive_product
FROM order_items
GROUP BY product_id
ORDER BY most_expensive_product DESC
LIMIT 1;

-- 29. Find Top Selling Product in Each Category
WITH RankedProducts AS (SELECT pc.product_category_name_english                                                                   AS product_category,
                               oi.product_id,
                               COUNT(oi.order_id)                                                                                 AS total_sales,
                               ROW_NUMBER() OVER (PARTITION BY pc.product_category_name_english ORDER BY COUNT(oi.order_id) DESC) AS rank_idx
                        FROM order_items AS oi
                                 INNER JOIN olist_products AS op ON oi.product_id = op.product_id
                                 INNER JOIN product_category_name_translation AS pc
                                            ON op.product_category_name = pc.product_category_name
                        GROUP BY pc.product_category_name_english, oi.product_id)
SELECT product_category,
       product_id,
       total_sales
FROM RankedProducts
WHERE rank_idx = 1
ORDER BY total_sales DESC;

-- 30. Find Top-Selling 10 Products in Each Category
WITH RankedProducts AS (SELECT pc.product_category_name_english                                                                   AS product_category,
                               oi.product_id,
                               COUNT(oi.order_id)                                                                                 AS total_sales,
                               ROW_NUMBER() OVER (PARTITION BY pc.product_category_name_english ORDER BY COUNT(oi.order_id) DESC) AS rank_idx
                        FROM order_items AS oi
                                 INNER JOIN olist_products AS op ON oi.product_id = op.product_id
                                 INNER JOIN product_category_name_translation AS pc
                                            ON op.product_category_name = pc.product_category_name
                        GROUP BY pc.product_category_name_english, oi.product_id)
SELECT product_category,
       product_id,
       total_sales
FROM RankedProducts
WHERE rank_idx BETWEEN 1 AND 10
ORDER BY product_category, total_sales DESC;

-- 31. Find Top Selling Category
SELECT pc.product_category_name_english AS product_category,
       COUNT(oi.order_id)               AS total_sales
FROM order_items AS oi
         INNER JOIN olist_products AS op ON oi.product_id = op.product_id
         INNER JOIN product_category_name_translation AS pc ON op.product_category_name = pc.product_category_name
GROUP BY pc.product_category_name_english
ORDER BY total_sales DESC
LIMIT 20;

-- 32. Find Worst Selling Category
SELECT pc.product_category_name_english AS product_category,
       COUNT(oi.order_id)               AS total_sales
FROM order_items AS oi
         INNER JOIN olist_products AS op ON oi.product_id = op.product_id
         INNER JOIN product_category_name_translation AS pc ON op.product_category_name = pc.product_category_name
GROUP BY pc.product_category_name_english
ORDER BY total_sales
LIMIT 20;

-- 33. Calculate Revenue by Product
SELECT product_id,
       SUM(price) AS total_revenue
FROM order_items
GROUP BY product_id
ORDER BY total_revenue DESC;

-- 34. Calculate Revenue by Product Category / 35. Calculate Revenue Contribution by Product Category
WITH TotalRevenue AS (SELECT SUM(payment_value) AS total_revenue
                      FROM olist_orders AS o
                               LEFT JOIN order_payments AS p ON o.order_id = p.order_id
                      WHERE o.order_status NOT IN ('unavailable', 'canceled'))
SELECT Pc.product_category_name_english                                      AS product_category,
       SUM(price)                                                            AS total_category_revenue,
       ROUND(SUM(price) / (SELECT total_revenue FROM TotalRevenue), 5) * 100 AS percent_category_contribution
FROM order_items AS oi
         INNER JOIN olist_products AS op ON oi.product_id = op.product_id
         INNER JOIN product_category_name_translation AS pc ON op.product_category_name = pc.product_category_name
GROUP BY Pc.product_category_name_english
ORDER BY percent_category_contribution DESC;

-- 36. Calculate Product Contribution to Total Revenue
WITH TotalRevenue AS (SELECT SUM(payment_value) AS total_revenue
                      FROM olist_orders AS o
                               LEFT JOIN order_payments AS p ON o.order_id = p.order_id
                      WHERE o.order_status NOT IN ('unavailable', 'canceled'))
SELECT product_id,
       SUM(price)                                                            AS total_product_revenue,
       ROUND(SUM(price) / (SELECT total_revenue FROM TotalRevenue), 5) * 100 AS percent_product_contribution
FROM order_items
GROUP BY product_id
ORDER BY percent_product_contribution DESC;

-- 37. Find Products with Revenue Above Category Average
WITH ProductRevenue AS (
    SELECT
        oi.product_id,
        product_category_name_english AS product_category_name,
        SUM(oi.price) AS total_product_revenue
    FROM order_items oi
    LEFT JOIN olist_products p ON oi.product_id = p.product_id
    LEFT JOIN olist_orders o ON oi.order_id = o.order_id
    LEFT JOIN product_category_name_translation AS pc ON p.product_category_name = pc.product_category_name
    WHERE o.order_status NOT IN ('unavailable', 'canceled')
      AND product_category_name_english IS NOT NULL
    GROUP BY oi.product_id, p.product_category_name
),
CategoryAverage AS (
    SELECT
        product_id,
        product_category_name,
        total_product_revenue,
        AVG(total_product_revenue) OVER(PARTITION BY product_category_name) AS avg_category_revenue
    FROM ProductRevenue
)
SELECT
    product_id,
    product_category_name,
    ROUND(total_product_revenue, 2) AS product_revenue,
    ROUND(avg_category_revenue, 2) AS category_average_revenue
FROM CategoryAverage
WHERE total_product_revenue > avg_category_revenue
ORDER BY product_category_name , total_product_revenue DESC;

-- 38. Find Products Never Sold
SELECT COUNT(product_id)
FROM olist_products AS op
WHERE op.product_id NOT IN (SELECT DISTINCT product_id FROM order_items);

-- 39. Find Products Purchased by Exactly One Customer
SELECT Product_id
FROM olist_orders AS o
         LEFT JOIN order_items AS oi ON o.order_id = oi.order_id
GROUP BY Product_id
HAVING COUNT(DISTINCT customer_id) = 1;

-- 40. Calculate Revenue by City
SELECT c.customer_city AS city,
       SUM(p.payment_value) AS total_revenue
FROM customers AS c
LEFT JOIN olist_orders AS o ON c.customer_id = o.customer_id
LEFT JOIN order_payments AS p ON o.order_id = p.order_id
WHERE o.order_status NOT IN ('unavailable', 'canceled')
GROUP BY c.customer_city
ORDER BY total_revenue DESC;

-- 41. Calculate Revenue by Region (State)
SELECT c.customer_state AS state,
       SUM(p.payment_value) AS total_revenue
FROM customers AS c
LEFT JOIN olist_orders AS o ON c.customer_id = o.customer_id
LEFT JOIN order_payments AS p ON o.order_id = p.order_id
WHERE o.order_status NOT IN ('unavailable', 'canceled')
GROUP BY c.customer_state
ORDER BY total_revenue DESC;



