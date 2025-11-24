with src_product as (
  select * from {{ source('sales', 'Product') }}
)
select product_id,
product_name,
category as product_category
from src_product