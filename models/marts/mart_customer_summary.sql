WITH customer_orders AS (
    SELECT *
    FROM {{ ref('int_orders_enriched') }}
)

SELECT
    customer_id,
    customer_name,
    email,
    city,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(order_revenue) AS total_spending
FROM customer_orders
GROUP BY
    customer_id,
    customer_name,
    email,
    city
