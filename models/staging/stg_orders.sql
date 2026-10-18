
WITH source AS (
    SELECT *
    FROM ECOMMERCE_DB.RAW.ORDERS
),

cleaned AS (
    SELECT
        ORDER_ID::NUMBER AS order_id,
        CUSTOMER_ID::NUMBER AS customer_id,
        PRODUCT_ID::NUMBER AS product_id,
        QUANTITY::NUMBER AS quantity,
        ORDER_DATE::DATE AS order_date,
        CASE
            WHEN LOWER(TRIM(STATUS)) IN ('completed', 'pending', 'cancelled', 'shipped')
                THEN LOWER(TRIM(STATUS))
            ELSE NULL
        END AS order_status
    FROM source
),

deduplicated AS (
    SELECT DISTINCT *
    FROM cleaned
),

valid_orders AS (
    SELECT o.*
    FROM deduplicated o
    INNER JOIN {{ ref('stg_customers') }} c
        ON o.customer_id = c.customer_id
    INNER JOIN {{ ref('stg_products') }} p
        ON o.product_id = p.product_id
    WHERE o.order_id IS NOT NULL
      AND o.quantity > 0
      AND o.order_status IS NOT NULL
)

SELECT *
FROM valid_orders
