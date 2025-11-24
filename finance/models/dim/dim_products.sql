with dim_product as (
  select * from {{ ref('src_products') }}
)
select product_id,
product_name,
product_category,
case
    when LOWER(product_name) IN ('kia', 'hyundai') THEN STRUCT('South Korea' AS country, 'SK' AS code, 'Asia' AS continent)
    when LOWER(product_name) IN ('honda', 'mazda', 'toyota', 'nissan') THEN STRUCT('Japan' AS country, 'JP' AS code, 'Asia' AS continent)
    when LOWER(product_name) IN ('mercedes-benz', 'audi', 'bmw', 'volkswagen') THEN STRUCT('Germany' AS country, 'DE' AS code, 'Europe' AS continent)
    when LOWER(product_name) IN ('ford') THEN STRUCT('United States' AS country, 'US' AS code, 'North America' AS continent)
    ELSE NULL
end as manufacturer_data
from dim_product


