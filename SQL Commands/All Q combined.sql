-- Creating the table layout to fit the raw data 
create database pizzahut;

create table orders(
order_id int not null,	
order_date date not null,
order_time time not null,
primary key(order_id));

create table orders_details(
order_details_id int not null,
order_id int not null,	
pizza_id text not null,
quantity int not null,
primary key(order_details_id));

-- ---------------------------------------------- -- 
-- Q1. Retrieve the total number of orders placed.
SELECT COUNT(order_id) AS Total_orders from orders;

-- ---------------------------------------------- -- 
-- Q2. Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(p.price * o.quantity), 2)
FROM
    pizzas p
        JOIN
    orders_details o ON p.pizza_id = o.pizza_id;
    
-- ---------------------------------------------- -- 
-- Q3. Identify the highest-priced pizza.
SELECT 
    pt.name, p.price
FROM
    pizzas p
        JOIN
    pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;

-- ---------------------------------------------- -- 
-- Q4. Identify the most common pizza size ordered.
SELECT 
    p.size, COUNT(o.order_details_id) AS No_of_Pizzas_Ordered
FROM
    pizzas p
        JOIN
    orders_details o ON p.pizza_id = o.pizza_id
GROUP BY p.size
order by No_of_Pizzas_Ordered DESC;

-- ---------------------------------------------- -- 
-- Q5. List the top 5 most ordered pizza types along with their quantities.
SELECT 
    pt.name, SUM(od.quantity) total_quantity_ordered
FROM
    pizzas p
        JOIN
    orders_details od ON od.pizza_id = p.pizza_id
        JOIN
    pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.name
ORDER BY total_quantity_ordered DESC
LIMIT 5;

-- ---------------------------------------------- -- 
-- Q6. Calculate the percentage contribution of each pizza type to total revenue.
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
    
-- ---------------------------------------------- -- 
-- Q7. Determine the distribution of orders by hour of the day.
SELECT 
    HOUR(order_time) AS hour, COUNT(order_id) AS order_count
FROM
    orders
GROUP BY HOUR(order_time)
ORDER BY order_count DESC;

-- ---------------------------------------------- -- 
-- Q8. Join relevant tables to find the category-wise distribution of pizzas.
SELECT 
    category, COUNT(name) AS total_quantity_ordered
FROM
    pizza_types
GROUP BY category
ORDER BY COUNT(name);

-- ---------------------------------------------- -- 
-- Q9. Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT 
    ROUND(AVG(quantity_per_day), 2)
FROM
    (SELECT 
        DATE(o.order_date), SUM(od.quantity) AS quantity_per_day
    FROM
        orders o
    JOIN orders_details od ON o.order_id = od.order_id
    GROUP BY DATE(o.order_date)) AS order_quantity;
    
-- ---------------------------------------------- -- 
-- Q10. Determine the top 3 most ordered pizza types based on revenue.
SELECT 
    pt.name, ROUND(SUM(p.price * od.quantity), 2) AS revenue
FROM
    pizzas p
        JOIN
    orders_details od ON p.pizza_id = od.pizza_id
        JOIN
    pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.name
ORDER BY revenue DESC
LIMIT 3;

-- ---------------------------------------------- -- 
-- Q11. Calculate the percentage contribution of each pizza type to total revenue.
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
    
-- ---------------------------------------------- -- 
-- Q12. Analyze the cumulative revenue generated over time.
SELECT order_date,ROUND(SUM(revenue) over(order by order_date),2) AS cum_revenue
FROM (SELECT o.order_date, 
SUM(od.quantity*p.price) AS revenue
FROM orders_details od
JOIN pizzas p
    ON od.pizza_id = p.pizza_id
JOIN orders o 
	ON o.order_id = od.order_id
GROUP BY o.order_date) AS sales;

-- ---------------------------------------------- -- 
-- Q13. Determine the top 3 most ordered pizza types based on revenue for each pizza category.
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