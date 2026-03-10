-- Connect to database
USE maven_advanced_sql;

-- ASSIGNMENT 1: Basic Joins
-- Looking at the orders and products tables, which products exist in one table, but not the other?
SELECT	pd.product_id, pd.product_name, od.product_id AS product_id_in_orders
FROM	orders od
		RIGHT JOIN products pd
		ON od.product_id = pd.product_id
WHERE od.product_id IS NULL;

-- View the orders and products tables
SELECT * FROM orders;
SELECT * FROM products;

-- Join the tables using various join types & note the number of rows in the output

-- LEFT JOIN 8549        
SELECT	COUNT(*)
FROM	orders od
		LEFT JOIN products pd
		ON od.product_id = pd.product_id;

-- RIGHT JOIN 8552
SELECT	COUNT(*)
FROM	orders od
		RIGHT JOIN products pd
		ON od.product_id = pd.product_id;
        
-- View the products that exist in one table, but not the other

-- Product existing in orders table but not the products table [ALL]]
SELECT	od.product_id
FROM	orders od
		LEFT JOIN products pd
		ON od.product_id = pd.product_id
WHERE pd.product_id IS NULL;

-- Product existing in products table but not the orders table [ALL]
SELECT	pd.product_id
FROM	orders od
		RIGHT JOIN products pd
		ON od.product_id = pd.product_id
WHERE od.product_id IS NULL;

-- Pick a final JOIN type to join products and orders
SELECT	pd.product_id, pd.product_name, od.product_id AS product_id_in_orders
FROM	orders od
		RIGHT JOIN products pd
		ON od.product_id = pd.product_id
WHERE od.product_id IS NULL;

-- ASSIGNMENT 2: Self Joins
-- Which products are within 25 cents of each other in terms of unit price?

-- View the products table


-- Join the products table with itself so each candy is paired with a different candy

        
-- Calculate the price difference, do a self join, and then return only price differences under 25 cents


