SELECT sum(sales_amount) as total_sales, c.location FROM `compute-1-367804.sales.Sales` s
join `sales.Customer` as c on c.customer_id = s.customer_id
group by c.location
order by total_sales desc