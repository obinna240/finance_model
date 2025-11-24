with dim_sales as (
  select * from {{ ref('src_sales') }}
)
select
  *
from dim_sales