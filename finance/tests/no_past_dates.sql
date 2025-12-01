select * from {{ ref('src_sentiment') }}
where date < '2024-12-31'