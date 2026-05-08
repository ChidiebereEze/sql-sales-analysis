-- ============================================
-- SALES DATABASE ANALYSIS
-- Author: Eze Chidiebere Favour (Smart)
-- Tools: MySQL
-- Description: A mini sales database project
--              demonstrating JOINs, GROUP BY,
--              Subqueries, HAVING and Aggregations
-- ============================================


-- ============================================
-- SECTION 1: CREATE TABLES
-- ============================================

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(50)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    name VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT,
    order_date DATE
);


-- ============================================
-- SECTION 2: INSERT DATA
-- ============================================

INSERT INTO customers VALUES
(1, 'Smart', 'Enugu'),
(2, 'Chidi', 'Lagos'),
(3, 'Favour', 'Abuja'),
(4, 'Tunde', 'Lagos'),
(5, 'Amaka', 'Enugu');

INSERT INTO products VALUES
(1, 'Laptop', 800.00),
(2, 'Mouse', 25.00),
(3, 'Keyboard', 45.00),
(4, 'Monitor', 300.00),
(5, 'Headset', 60.00);

INSERT INTO orders VALUES
(1, 1, 1, 1, '2024-01-05'),
(2, 2, 2, 3, '2024-01-07'),
(3, 3, 3, 2, '2024-01-10'),
(4, 4, 4, 1, '2024-01-12'),
(5, 5, 5, 2, '2024-01-15'),
(6, 1, 3, 1, '2024-02-01'),
(7, 2, 4, 1, '2024-02-03'),
(8, 3, 1, 1, '2024-02-10'),
(9, 4, 2, 2, '2024-02-14'),
(10, 5, 3, 1, '2024-02-20');


-- ============================================
-- SECTION 3: BUSINESS QUESTIONS
-- ============================================

-- Q1: Total revenue per product (JOIN + GROUP BY)
SELECT b.name AS product, SUM(b.price * c.quantity) AS total_revenue
FROM products AS b
JOIN orders AS c ON b.product_id = c.product_id
GROUP BY b.name;


-- Q2: Which customer spent the most? (JOIN + GROUP BY + ORDER BY + LIMIT)
SELECT a.name AS customer, SUM(b.price * c.quantity) AS total_spent
FROM customers AS a
JOIN orders AS c ON a.customer_id = c.customer_id
JOIN products AS b ON b.product_id = c.product_id
GROUP BY a.name
ORDER BY total_spent DESC
LIMIT 1;


-- Q3: How many orders per city? (JOIN + GROUP BY)
SELECT a.city, COUNT(c.order_id) AS number_of_orders
FROM customers AS a
JOIN orders AS c ON a.customer_id = c.customer_id
GROUP BY a.city;


-- Q4: Products that generated above average revenue (JOIN + GROUP BY + HAVING + Subquery)
SELECT b.name AS product, SUM(b.price * c.quantity) AS total_revenue
FROM products AS b
JOIN orders AS c ON b.product_id = c.product_id
GROUP BY b.name
HAVING SUM(b.price * c.quantity) > (
    SELECT AVG(b.price * c.quantity)
    FROM products AS b
    JOIN orders AS c ON b.product_id = c.product_id
);


-- Q5: Each customer's name with total amount spent (3-table JOIN + GROUP BY)
SELECT a.name AS customer, SUM(b.price * c.quantity) AS total_spent
FROM customers AS a
JOIN orders AS c ON a.customer_id = c.customer_id
JOIN products AS b ON b.product_id = c.product_id
GROUP BY a.name;
