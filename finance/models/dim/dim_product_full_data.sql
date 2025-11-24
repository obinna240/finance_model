
with dim_product_full_data as (
    select * from {{ ref('dim_products') }}
)
select product_id,
    product_name,
    product_category,
    manufacturer_data.country as product_country,
    manufacturer_data.code as product_country_code,
    manufacturer_data.continent as product_continent
from dim_product_full_data