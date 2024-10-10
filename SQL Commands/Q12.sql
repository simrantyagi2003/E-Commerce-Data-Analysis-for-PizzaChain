-- Analyze the cumulative revenue generated over time.

SELECT order_date,ROUND(SUM(revenue) over(order by order_date),2) AS cum_revenue
FROM (SELECT o.order_date, 
SUM(od.quantity*p.price) AS revenue
FROM orders_details od
JOIN pizzas p
    ON od.pizza_id = p.pizza_id
JOIN orders o 
	ON o.order_id = od.order_id
GROUP BY o.order_date) AS sales