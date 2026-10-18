SELECT *
FROM {{ ref('stg_products') }}
WHERE price <= 0
   OR price IS NULL