SELECT *
FROM {{ ref('int_orders_enriched') }}
WHERE order_status = 'completed'
  AND order_revenue < 0
