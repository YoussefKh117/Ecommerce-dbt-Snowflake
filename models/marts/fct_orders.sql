SELECT
    order_id,
    customer_id,
    customer_name,
    email,
    city,
    product_id,
    product_name,
    category,
    price,
    quantity,
    order_date,
    order_status,
    order_revenue
FROM {{ ref('int_orders_enriched') }}
