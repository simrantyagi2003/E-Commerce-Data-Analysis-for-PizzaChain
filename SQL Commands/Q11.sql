-- Calculate the percentage contribution of each pizza type to total revenue.

SELECT 
    pt.category, round(SUM(od.quantity * p.price)/ (SELECT ROUND(SUM(od.quantity * p.price),2) AS total_sales
FROM
    orders_details od
    JOIN
        pizzas p 
	ON p.pizza_id = od.pizza_id)* 100,2) AS revenue
    FROM pizza_types pt 
    JOIN
		pizzas p 
        ON pt.pizza_type_id = p.pizza_type_id
	JOIN 
		orders_details od
		ON od.pizza_id = p.pizza_id
	GROUP BY pt.category 
    ORDER BY revenue DESC;