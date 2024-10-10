-- Calculate the total revenue generated from pizza sales.

SELECT 
    ROUND(SUM(p.price * o.quantity), 2)
FROM
    pizzas p
        JOIN
    orders_details o ON p.pizza_id = o.pizza_id