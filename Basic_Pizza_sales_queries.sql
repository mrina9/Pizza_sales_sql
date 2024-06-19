--ADVANCED

--Calculate the percentage contribution of each pizza type to total revenue.

SELECT 
pizza_types.category,
(SUM(order_details.quantity * pizzas.price)/(
    SELECT 
    SUM (order_details.quantity * pizzas.price) AS total_revenue
    FROM order_details
    JOIN pizzas
    ON pizzas.pizza_id = order_details.pizza_id
))* 100 AS revenue
FROM pizza_types JOIN pizzas
ON pizzas.pizza_type_id = pizza_types.pizza_type_id
JOIN order_details
ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue DESC LIMIT 5;

-------------

--Analyze the cumulative revenue generated over time.

SELECT
order_date,
SUM(revenue) OVER (ORDER BY order_date) AS cum_revenue
FROM
(SELECT
orders.order_date AS order_date,
SUM(order_details.quantity * pizzas.price) AS revenue
FROM pizza_types JOIN pizzas
ON pizzas.pizza_type_id = pizza_types.pizza_type_id
JOIN order_details
ON pizzas.pizza_id = order_details.pizza_id
JOIN orders
ON order_details.order_id = orders.order_id
GROUP BY orders.order_date) AS sales;

-------------

--Determine the top 3 most ordered pizza types based on revenue for each pizza category

SELECT
category, name, revenue
FROM
(SELECT
category,
name,
revenue,
RANK() OVER (PARTITION BY category ORDER BY revenue) AS rank
FROM
(SELECT
pizza_types.category AS category,
pizza_types.name AS name,
SUM(order_details.quantity * pizzas.price) AS revenue
FROM pizza_types
JOIN pizzas
ON pizzas.pizza_type_id = pizza_types.pizza_type_id
JOIN order_details
ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category, pizza_types.name) AS abc) AS def
WHERE rank <=3;