WITH orders AS (
    SELECT *
    FROM {{ ref('stg_orders') }}
),

customers AS (
    SELECT *
    FROM {{ ref('stg_customers') }}
),

products AS (
    SELECT *
    FROM {{ ref('stg_products') }}
)

SELECT
    o.order_id,
    o.customer_id,
    c.customer_name,
    c.email,
    c.city,
    o.product_id,
    p.product_name,
    p.category,
    p.price,
    o.quantity,
    o.order_date,
    o.order_status,
    CASE
        WHEN o.order_status = 'completed'
            THEN o.quantity * p.price
        ELSE 0
    END AS order_revenue
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
LEFT JOIN products p
    ON o.product_id = p.product_id
