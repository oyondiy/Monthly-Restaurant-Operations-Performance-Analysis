CREATE DATABASE restaurant_db;
USE restaurant_db;
CREATE TABLE restaurants (
    restaurant_id INT,
    restaurant_name VARCHAR(100),
    city VARCHAR(100),
    country VARCHAR(100),
    location VARCHAR(100),
    capacity INT
);

CREATE TABLE orders (
    order_id INT,
    restaurant_name VARCHAR(100),
    order_date DATE,
    order_time TIME,
    customer_name VARCHAR(100),
    food_item VARCHAR(100),
    category VARCHAR(100),
    quantity INT,
    price DECIMAL(10,2),
    discount DECIMAL(10,2),
    payment_method VARCHAR(50),
    total_amount DECIMAL(10,2)
);

CREATE TABLE food_items (
    food_item_id INT,
    food_item VARCHAR(100),
    category VARCHAR(100),
    selling_price DECIMAL(10,2),
    cost_price DECIMAL(10,2)
);

CREATE TABLE cost (
    food_item VARCHAR(100),
    ingredient_cost DECIMAL(10,2),
    labor_cost DECIMAL(10,2),
    other_cost DECIMAL(10,2),
    total_cost DECIMAL(10,2)
);

SELECT * FROM orders LIMIT 10;
SELECT * FROM restaurants LIMIT 10;
SELECT * FROM food_items LIMIT 10;
SELECT * FROM cost LIMIT 10;
SHOW TABLES;
SELECT
    o.order_id,
    o.order_date,
    o.customer_name,
    o.food_item,
    o.quantity,
    o.price,
    o.total_amount,

    r.restaurant_name,
    r.city,
    r.country,

    f.category,
    f.selling_price,
    f.cost_price,

    c.ingredient_cost,
    c.labor_cost,
    c.other_cost,
    c.total_cost

FROM orders o
JOIN restaurants r
    ON o.restaurant_name = r.restaurant_name
JOIN food_items f
    ON o.food_item = f.food_item
JOIN cost c
    ON f.food_item = c.food_item;
    #Total Revenue by Restaurant
    SELECT 
    r.restaurant_name,
    SUM(o.total_amount) AS total_revenue
FROM orders o
JOIN restaurants r
    ON o.restaurant_name = r.restaurant_name
GROUP BY r.restaurant_name
ORDER BY total_revenue DESC;

#Profit per Food Item

SELECT 
    f.food_item,
    SUM(o.total_amount) AS revenue,
    SUM(c.total_cost * o.quantity) AS total_cost,
    SUM(o.total_amount - (c.total_cost * o.quantity)) AS profit
FROM orders o
JOIN food_items f
    ON o.food_item = f.food_item
JOIN cost c
    ON f.food_item = c.food_item
GROUP BY f.food_item
ORDER BY profit DESC;

#Profit Margin per Food Item

SELECT 
    f.food_item,
    SUM(o.total_amount) AS revenue,
    SUM(o.total_amount - (c.total_cost * o.quantity)) AS profit,
    ROUND(
        SUM(o.total_amount - (c.total_cost * o.quantity)) 
        / SUM(o.total_amount) * 100, 2
    ) AS profit_margin_pct
FROM orders o
JOIN food_items f
    ON o.food_item = f.food_item
JOIN cost c
    ON f.food_item = c.food_item
GROUP BY f.food_item
ORDER BY profit_margin_pct DESC;

#Best and Worst Performing Food Items

SELECT 
    f.food_item,
    SUM(o.total_amount) AS revenue
FROM orders o
JOIN food_items f
    ON o.food_item = f.food_item
GROUP BY f.food_item
ORDER BY revenue DESC;

#Restaurant Profitability Analysis

SELECT 
    r.restaurant_name,
    SUM(o.total_amount) AS revenue,
    SUM(c.total_cost * o.quantity) AS cost,
    SUM(o.total_amount - (c.total_cost * o.quantity)) AS profit
FROM orders o
JOIN restaurants r
    ON o.restaurant_name = r.restaurant_name
JOIN food_items f
    ON o.food_item = f.food_item
JOIN cost c
    ON f.food_item = c.food_item
GROUP BY r.restaurant_name
ORDER BY profit DESC;

#Monthly Sales Trend

SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    SUM(o.total_amount) AS monthly_revenue
FROM orders o
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month;

#Most Popular Food Categories

SELECT 
    f.category,
    SUM(o.quantity) AS total_units_sold
FROM orders o
JOIN food_items f
    ON o.food_item = f.food_item
GROUP BY f.category
ORDER BY total_units_sold DESC;

#High Cost vs Low Profit Items

SELECT 
    f.food_item,
    SUM(o.total_amount) AS revenue,
    SUM(c.total_cost * o.quantity) AS cost,
    SUM(o.total_amount - (c.total_cost * o.quantity)) AS profit
FROM orders o
JOIN food_items f
    ON o.food_item = f.food_item
JOIN cost c
    ON f.food_item = c.food_item
GROUP BY f.food_item
HAVING profit < 0
ORDER BY profit ASC;

SELECT * FROM orders limit 300;