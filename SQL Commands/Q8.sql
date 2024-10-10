-- Join relevant tables to find the category-wise distribution of pizzas.

SELECT 
    category, COUNT(name) AS total_quantity_ordered
FROM
    pizza_types
GROUP BY category
ORDER BY COUNT(name)