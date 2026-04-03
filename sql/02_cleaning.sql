-- =============================================
-- DATA QUALITY CHECKS
-- =============================================
-- All checks returned 0 — no cleaning required

-- DUPLICATES
SELECT 'orders_duplicates', COUNT(*) FROM (
    SELECT order_id FROM orders GROUP BY 1 HAVING COUNT(*) > 1) t;

SELECT 'order_items_duplicates', COUNT(*) FROM (
    SELECT order_id, order_item_id FROM order_items GROUP BY 1,2 HAVING COUNT(*) > 1) t;

-- NULLs
SELECT 'orders_nulls', COUNT(*) FROM orders WHERE order_id IS NULL OR customer_id IS NULL;
SELECT 'order_items_null_price', COUNT(*) FROM order_items WHERE price IS NULL;
SELECT 'payments_null_value', COUNT(*) FROM order_payments WHERE payment_value IS NULL;

-- ANOMALIES
SELECT 'negative_payments', COUNT(*) FROM order_payments WHERE payment_value < 0;
SELECT 'negative_prices', COUNT(*) FROM order_items WHERE price < 0;

-- DATES
SELECT 'missing_purchase_timestamp', COUNT(*) FROM orders WHERE order_purchase_timestamp IS NULL;
SELECT 'invalid_delivery_date', COUNT(*) FROM orders WHERE order_delivered_customer_date < order_purchase_timestamp;

-- NORMALIZE CATEGORIES
UPDATE product_category_translation
SET product_category_name_english = INITCAP(REPLACE(product_category_name_english, '_', ' '));