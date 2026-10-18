-- Mart: Category Sales
-- Purpose: Calculate order count and revenue for each product category.
-- Revenue is calculated from completed orders only.

WITH orders_enriched AS (

    SELECT *
    FROM {{ ref('int_orders_enriched') }}

)

SELECT
    category,

    -- Count all valid orders in each category
    COUNT(DISTINCT order_id) AS total_orders,

    -- Sum revenue from completed orders only
    SUM(order_revenue) AS total_revenue

FROM orders_enriched

GROUP BY category
