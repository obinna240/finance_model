SELECT ROUND(sum(sales_amount), 2) as total_sales, c.customer_name FROM `compute-1-367804.sales.Sales` s
join `sales.Customer` as c on c.customer_id = s.customer_id
group by c.customer_name
order by total_sales desc