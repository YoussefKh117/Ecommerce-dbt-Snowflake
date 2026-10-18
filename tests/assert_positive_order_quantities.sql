SELECT *
FROM {{ ref('stg_orders') }}
WHERE quantity <= 0
   OR quantity IS NULL
