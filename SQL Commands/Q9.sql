-- Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT 
    ROUND(AVG(quantity_per_day), 2)
FROM
    (SELECT 
        DATE(o.order_date), SUM(od.quantity) AS quantity_per_day
    FROM
        orders o
    JOIN orders_details od ON o.order_id = od.order_id
    GROUP BY DATE(o.order_date)) AS order_quantity