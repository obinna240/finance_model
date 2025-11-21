-- insert 50 rows into Sales table using references from Customer and Product table
INSERT INTO
  `compute-1-367804`.`sales`.`Sales` (sales_id,
    product_id,
    customer_id,
    sales_amount)
SELECT
  s.sales_id,
  p.product_id,
  c.customer_id,
  ROUND(RAND() * 1000 + 100, 2) AS sales_amount
FROM (
  SELECT
    ROW_NUMBER() OVER () AS sales_id
  FROM
    UNNEST(GENERATE_ARRAY(1, 50)) AS _ ) AS s
LEFT JOIN (
  SELECT
    product_id,
    ROW_NUMBER() OVER (ORDER BY product_id) AS rn_p,
    COUNT(product_id) OVER () AS total_products
  FROM
    `compute-1-367804`.`sales`.`Product` ) AS p
ON
  MOD(s.sales_id - 1, p.total_products) + 1 = p.rn_p
LEFT JOIN (
  SELECT
    customer_id,
    ROW_NUMBER() OVER (ORDER BY customer_id) AS rn_c,
    COUNT(customer_id) OVER () AS total_customers
  FROM
    `compute-1-367804`.`sales`.`Customer` ) AS c
ON
  MOD(s.sales_id - 1, c.total_customers) + 1 = c.rn_c;