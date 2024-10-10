-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

SELECT rn, name , revenue FROM
(SELECT category, name, revenue,
rank() over(partition by category order by revenue desc) as rn
FROM
(SELECT pt.category , pt.name, ROUND(SUM(p.price * od.quantity),2) AS revenue
FROM pizzas p 
JOIN pizza_types pt
ON pt.pizza_type_id = p.pizza_type_id
JOIN orders_details od
ON p.pizza_id = od.pizza_id
GROUP BY pt.category, pt.name) as aa) as bb
WHERE rn<=3;