
-- =============================================
-- KPI
-- =============================================


-- =============================================
-- CORE KPI
-- =============================================
SELECT
    ROUND(SUM(total_payment)::numeric, 2)        AS revenue,
    COUNT(DISTINCT order_id)                      AS total_orders,
    COUNT(DISTINCT customer_unique_id)            AS unique_customers,
    ROUND(AVG(total_payment)::numeric, 2)         AS aov,
    ROUND(AVG(delivery_days)::numeric, 1)         AS avg_delivery_days
FROM fact_orders
WHERE order_status = 'delivered';
-- =============================================
-- MONTHLY TREND
-- =============================================
SELECT
    DATE_TRUNC('month', order_date)              AS month,
    COUNT(DISTINCT order_id)                     AS orders,
    ROUND(SUM(total_payment)::numeric, 2)        AS revenue,
    ROUND(AVG(total_payment)::numeric, 2)        AS aov
FROM fact_orders
WHERE order_status = 'delivered'
GROUP BY 1
ORDER BY 1;
-- =============================================
-- REPEAT RATE 
-- =============================================
WITH customer_orders AS (
    SELECT
        customer_unique_id,
        COUNT(DISTINCT order_id) AS order_count
    FROM fact_orders
    WHERE order_status = 'delivered'
    GROUP BY customer_unique_id
)
SELECT
    COUNT(*)                                                        AS total_customers,
    COUNT(*) FILTER (WHERE order_count = 1)                        AS one_time_customers,
    COUNT(*) FILTER (WHERE order_count > 1)                        AS repeat_customers,
    ROUND(COUNT(*) FILTER (WHERE order_count > 1) * 100.0 
        / COUNT(*), 2)                                             AS repeat_rate_pct
FROM customer_orders;
-- =============================================
-- REVENUE BY CATEGORY
-- =============================================
SELECT
    COALESCE(t.product_category_name_english, 'Unknown') AS category,
    COUNT(DISTINCT oi.order_id)                          AS orders,
    ROUND(SUM(oi.price)::numeric, 2)                     AS revenue
FROM order_items oi
JOIN products p     ON oi.product_id = p.product_id
JOIN fact_orders fo ON oi.order_id = fo.order_id
LEFT JOIN product_category_translation t 
                    ON p.product_category_name = t.product_category_name
WHERE fo.order_status = 'delivered'
GROUP BY 1
ORDER BY 3 DESC
LIMIT 10;
-- =============================================
-- PAYMENT TYPE BREAKDOWN
-- =============================================
SELECT
    payment_type,
    COUNT(DISTINCT order_id)                     AS orders,
    ROUND(SUM(payment_value)::numeric, 2)        AS revenue
FROM order_payments
WHERE order_id IN (
    SELECT order_id FROM fact_orders
    WHERE order_status = 'delivered'
)
GROUP BY 1
ORDER BY 3 DESC;
-- =============================================
-- DELIVERY PERFORMANCE
-- =============================================
SELECT
    ROUND(AVG(delivery_days)::numeric, 1)                    AS avg_delivery_days,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP 
        (ORDER BY delivery_days)::numeric, 1)                AS median_delivery_days,
    COUNT(*) FILTER (WHERE delivered_date > estimated_date)  AS late_orders,
    ROUND(COUNT(*) FILTER (WHERE delivered_date > estimated_date) 
        * 100.0 / COUNT(*), 2)                               AS late_rate_pct
FROM fact_orders
WHERE order_status = 'delivered'
  AND delivery_days IS NOT NULL;
-- =============================================
-- REVENUE BY STATE
-- =============================================
SELECT
    customer_state                               AS state,
    COUNT(DISTINCT order_id)                     AS orders,
    ROUND(SUM(total_payment)::numeric, 2)        AS revenue
FROM fact_orders
WHERE order_status = 'delivered'
GROUP BY 1
ORDER BY 3 DESC;