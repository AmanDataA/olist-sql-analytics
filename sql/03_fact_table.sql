-- =============================================
-- CREATE FACT TABLE
-- =============================================
-- FACT TABLE
DROP TABLE IF EXISTS fact_orders;
CREATE TABLE fact_orders AS
SELECT
    o.order_id,
    o.customer_id,
    c.customer_unique_id,
    c.customer_city,
    c.customer_state,
    o.order_status,
    o.order_purchase_timestamp                    AS order_date,
    o.order_delivered_customer_date               AS delivered_date,
    o.order_estimated_delivery_date               AS estimated_date,

    -- DELIVERY
    EXTRACT(DAY FROM (
        o.order_delivered_customer_date - o.order_purchase_timestamp
    ))                                            AS delivery_days,

    -- MONEY FROM ORDER_ITEMS
    COALESCE(i.total_price, 0)                    AS total_price,
    COALESCE(i.total_freight, 0)                  AS total_freight,
    COALESCE(i.items_count, 0)                    AS items_count,

    -- MONEY FROM PAYMENTS
    COALESCE(p.total_payment, 0)                  AS total_payment,
    p.payment_types,
    COALESCE(p.payment_types_count, 0)            AS payment_types_count,
    COALESCE(p.has_credit_card, 0)                AS has_credit_card,
    COALESCE(p.has_voucher, 0)                    AS has_voucher

FROM orders o
JOIN customers c ON o.customer_id = c.customer_id

-- AGGREGATION ORDER_ITEMS
LEFT JOIN (
    SELECT
        order_id,
        SUM(price)                                AS total_price,
        SUM(freight_value)                        AS total_freight,
        COUNT(*)                                  AS items_count
    FROM order_items
    GROUP BY order_id
) i ON o.order_id = i.order_id

-- AGGREGATION PAYMENTS
LEFT JOIN (
    SELECT
        order_id,
        SUM(payment_value)                        AS total_payment,
        COUNT(DISTINCT payment_type)              AS payment_types_count,
        STRING_AGG(DISTINCT payment_type, ', ')   AS payment_types,
        MAX(CASE WHEN payment_type = 'credit_card'
            THEN 1 ELSE 0 END)                    AS has_credit_card,
        MAX(CASE WHEN payment_type = 'voucher'
            THEN 1 ELSE 0 END)                    AS has_voucher
    FROM order_payments
    GROUP BY order_id
) p ON o.order_id = p.order_id;