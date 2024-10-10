-- Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT pt.category, SUM(od.quantity) total_quantity_ordered
FROM pizzas p
JOIN orders_details od
ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.category
ORDER BY total_quantity_ordered DESC
