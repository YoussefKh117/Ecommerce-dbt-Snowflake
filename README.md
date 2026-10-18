
# E-Commerce Data Pipeline — Snowflake & dbt

## Project Overview

This project builds an analytics-ready data pipeline using Snowflake and dbt. It loads e-commerce data, cleans and transforms it, applies data quality tests, and creates analytical models for reporting.

## 1. Source Data

The project uses three CSV files:

- `customers.csv` — Customer information.
- `products.csv` — Product information, categories, and prices.
- `orders.csv` — Order details, quantities, dates, and statuses.

The source tables are stored in the `ECOMMERCE_DB.RAW` schema.

## 2. Data Architecture

The project follows a layered architecture:

- **RAW:** Original source data.
- **STAGING:** Cleaned and standardized data.
- **INTERMEDIATE:** Orders enriched with customer and product information.
- **MARTS:** Final analytical models.

### Data Flow

```text
CSV Files
   |
   v
Snowflake RAW
   |
   v
STAGING Models
   |
   v
int_orders_enriched
   |
   +-------------------+
   |                   |
   v                   v
fct_orders       mart_customer_summary
   |
   v
mart_category_sales
```

The three final marts depend on `int_orders_enriched`.

## 3. dbt Models

### Staging Models

- `stg_customers` — Cleans customer data and standardizes fields.
- `stg_products` — Cleans product data and validates prices.
- `stg_orders` — Standardizes order statuses and filters invalid orders.

### Intermediate Model

- `int_orders_enriched` — Joins orders with customers and products and calculates order revenue.

### Final Marts

- `fct_orders` — One row per valid order, with customer and product details and calculated revenue.
- `mart_customer_summary` — Total order count and spending per customer.
- `mart_category_sales` — Order count and revenue by product category.

## 4. Revenue Rules

Order revenue is calculated as:

`order_revenue = quantity * product_price`

Revenue is counted only for orders with status `completed`.

The following statuses contribute zero revenue:

- `pending`
- `cancelled`
- `shipped`

Customer order counts include all valid order statuses.

## 5. Data Quality Tests

The project includes tests for:

- Unique and non-null customer, product, and order identifiers.
- Valid customer and product references.
- Positive product prices.
- Positive order quantities.
- Accepted order statuses.
- Non-negative revenue for completed orders.

## 6. Execution

Run all models and their configured tests:

```bash
dbt build
```

Run models only:

```bash
dbt run
```

Run tests only:

```bash
dbt test
```

Generate documentation:

```bash
dbt docs generate
```

Serve the documentation locally:

```bash
dbt docs serve
```

## 7. Latest Execution Results

The latest `dbt build` completed successfully:

- Models built: 7
- Data tests passed: 28
- Warnings: 0
- Errors: 0

The final models are located in the `MARTS` schema, while staging and intermediate models are located in `STAGING`.

## 8. Rerunning the Pipeline

When new orders arrive:

1. Load the new source records into the appropriate RAW tables.
2. Run `dbt build`.
3. Review the test results.
4. Refresh downstream reporting tools if applicable.

**Note:** Running dbt does not load new CSV files into RAW automatically. Source ingestion must be performed separately. The current models are configured as views, and this project does not implement a dedicated incremental ingestion process.

## 9. Documentation and Lineage

The dbt documentation describes the models, columns, tests, and dependencies. The lineage graph shows how source staging models feed the intermediate model and how the intermediate model feeds the final marts.

