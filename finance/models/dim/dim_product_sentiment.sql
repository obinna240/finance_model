{{
    config(
        materialized='incremental',
        unique_key=['product_id', 'date'],
        on_schema_change='fail'
    )
}}
with src_product_sentiment as (
  select *
      {% if is_incremental() %}
      where date > (select max(date) from {{ this }})
      {% endif %}
  from {{ ref('src_sentiment') }}
),
product_data as (
 select * from {{ ref('src_products') }}
)

select
    p.product_id,
    p.product_name,
    p.product_category,
    s.sentiment,
    s.sentiment_verdict,
    s.date
 from src_product_sentiment s
 inner join product_data p
 on s.product_name = p.product_name



