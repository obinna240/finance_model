INSERT INTO
`compute-1-367804.sales.Sentiment` (product_name, sentiment, sentiment_verdict, date)

SELECT
  t.product_name,
  CASE MOD(i, 5)
    WHEN 0 THEN t.product_name || ' is an absolutely fantastic machine with great handling and reliability.'
    WHEN 1 THEN 'I had a terrible experience with the dealership and the paint chipped after two months on the ' || t.product_name || '.'
    WHEN 2 THEN 'The new ' || t.product_name || ' is decent, nothing too exciting, just standard transport.'
    WHEN 3 THEN t.product_name || ' has surprisingly high fuel efficiency, making it very economical.'
    ELSE 'Maintenance costs for the ' || t.product_name || ' seem much higher than expected.'
  END AS sentiment,
  CASE MOD(i, 5)
    WHEN 0 THEN 'positive'
    WHEN 1 THEN 'negative'
    WHEN 2 THEN 'neutral'
    WHEN 3 THEN 'positive'
    ELSE 'negative'
  END AS sentiment_verdict,
  -- Generate dates spread out over 100 days
  DATE_ADD(CURRENT_DATE(), INTERVAL MOD(i, 100) DAY) AS date
FROM
  -- 1. Define the Car Brands (excluding Ford to keep it to 10 brands for 100 total rows)
  (
    SELECT
      'Honda' AS product_name
    UNION ALL
    SELECT
      'Mazda'
    UNION ALL
    SELECT
      'Hyundai'
    UNION ALL
    SELECT
      'Kia'
    UNION ALL
    SELECT
      'Mercedes-Benz'
    UNION ALL
    SELECT
      'BMW'
    UNION ALL
    SELECT
      'Audi'
    UNION ALL
    SELECT
      'Volkswagen'
    UNION ALL
    SELECT
      'Nissan'
    UNION ALL
    SELECT
      'Toyota'
  ) AS t
  -- 2. Generate 10 Iterations (rows) for each car
CROSS JOIN
  UNNEST(GENERATE_ARRAY(1, 10)) AS iteration
  -- Create a unique index for the CASE statement across all 100 rows
CROSS JOIN
  UNNEST(GENERATE_ARRAY(1, 100)) AS i
WHERE
  MOD(i - 1, 10) = iteration - 1 -- Ensures we get exactly 10 rows per car, total 100
LIMIT 100;