
WITH source AS (
    SELECT *
    FROM ECOMMERCE_DB.RAW.PRODUCTS
),

cleaned AS (
    SELECT
        PRODUCT_ID::NUMBER AS product_id,
        NULLIF(TRIM(PRODUCT_NAME), '')::VARCHAR AS product_name,
        NULLIF(TRIM(CATEGORY), '')::VARCHAR AS category,
        PRICE::NUMBER(12, 2) AS price
    FROM source
),

deduplicated AS (
    SELECT DISTINCT *
    FROM cleaned
)

SELECT *
FROM deduplicated
WHERE product_id IS NOT NULL
  AND product_name IS NOT NULL
  AND category IS NOT NULL
  AND price > 0
