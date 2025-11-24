with src_sales as (
  select * from {{ source('sales', 'Sales') }}
)
select
  sales_id,
  product_id,
  customer_id,
  sales_amount
from src_sales