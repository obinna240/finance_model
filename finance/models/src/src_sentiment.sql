with src_sentiment as (
  select * from {{ source('sales', 'Sentiment') }}
)
select * from src_sentiment