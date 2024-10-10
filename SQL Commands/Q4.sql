-- Identify the most common pizza size ordered.

SELECT 
    p.size, COUNT(o.order_details_id) AS No_of_Pizzas_Ordered
FROM
    pizzas p
        JOIN
    orders_details o ON p.pizza_id = o.pizza_id
GROUP BY p.size
order by No_of_Pizzas_Ordered DESC;