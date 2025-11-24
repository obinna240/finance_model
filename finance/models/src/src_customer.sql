--Model that creates first name last name for customers from the customers table
with raw_customers as (
  SELECT * FROM {{ source('sales', 'Customer') }}
)
select
  customer_id,
  customer_name as customer_full_name,
  SPLIT(customer_name, ' ')[SAFE_OFFSET(0)] AS first_name,
  SUBSTR(customer_name, LENGTH(SPLIT(customer_name, ' ')[SAFE_OFFSET(0)]) + 2) AS last_name,
  location
 from
    raw_customers
