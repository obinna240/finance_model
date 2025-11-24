with dim_customers as (
  SELECT * FROM {{ ref('src_customer') }}
)
select
  *
 from
    dim_customers