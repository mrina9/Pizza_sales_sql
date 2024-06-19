--INTERMEDIATE

--Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT
pizza_types.category,
SUM(order_details.quantity) AS total_quantity
FROM
pizza_types JOIN pizzas
ON pizzas.pizza_type_id = pizza_types.pizza_type_id
JOIN order_details
ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY total_quantity;

-------------

--Determine the distribution of orders by hour of the day.
SELECT
    EXTRACT(HOUR FROM order_time) AS hour,
    COUNT(orders.order_id)
FROM
    orders
GROUP BY hour;

--Join relevant tables to find the category-wise distribution of pizzas.

SELECT 
    pizza_types.category,
    COUNT(pizza_types.name)
FROM pizza_types
GROUP BY category;

-------------

--Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT ROUND(AVG(quantity),0)
FROM
(SELECT 
    orders.order_date,
    SUM(order_details.quantity) AS quantity
FROM orders 
JOIN order_details
ON order_details.order_id = orders.order_id
GROUP BY orders.order_date) AS order_quantity;

-------------

--Determine the top 3 most ordered pizza types based on revenue.

SELECT
    pizza_types.name,
    SUM(order_details.quantity * pizzas.price) AS revenue
FROM pizza_types JOIN pizzas
ON pizzas.pizza_type_id = pizza_types.pizza_type_id
JOIN order_details
ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue DESC LIMIT 3;

