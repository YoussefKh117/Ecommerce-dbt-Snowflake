
WITH source AS (
    SELECT *
    FROM ECOMMERCE_DB.RAW.CUSTOMERS
),

cleaned AS (
    SELECT
        CUSTOMER_ID::NUMBER AS customer_id,
        TRIM(CUSTOMER_NAME)::VARCHAR AS customer_name,
        LOWER(TRIM(EMAIL))::VARCHAR AS email,
        TRIM(CITY)::VARCHAR AS city,
        SIGNUP_DATE::DATE AS signup_date
    FROM source
),

deduplicated AS (
    SELECT DISTINCT *
    FROM cleaned
)

SELECT *
FROM deduplicated
WHERE customer_id IS NOT NULL
  AND NULLIF(TRIM(customer_name), '') IS NOT NULL
  AND NULLIF(TRIM(email), '') IS NOT NULL
  AND signup_date IS NOT NULL
