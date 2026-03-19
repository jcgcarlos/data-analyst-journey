-- Connect to database (MySQL)
USE maven_advanced_sql;

-- 1. Basic joins
SELECT * FROM happiness_scores;
SELECT * FROM country_stats;

SELECT	hs.year, hs.country, cs.continent, hs.happiness_score
FROM	happiness_scores hs
		INNER JOIN country_stats cs
		ON hs.country = cs.country;

-- 2. Join types

-- INNER JOIN returns records that exist in BOTH tables, and excludes unmatched records from either table

SELECT	hs.year, hs.country, hs.happiness_score,
		cs.country, cs.continent
FROM	happiness_scores hs
		INNER JOIN country_stats cs
		ON hs.country = cs.country;
        
-- LEFT JOIN returns ALL records from the LEFT table, and any matching records from the RIGHT table

SELECT	hs.year, hs.country, hs.happiness_score,
		cs.country, cs.continent
FROM	happiness_scores hs
		LEFT JOIN country_stats cs
		ON hs.country = cs.country
WHERE	cs.country IS NULL;
        
-- RIGHT JOIN returns ALL records from the RIGHT table, and any matching records from the LEFT table

SELECT	hs.year, hs.country, hs.happiness_score,
		cs.country, cs.continent
FROM	happiness_scores hs
		RIGHT JOIN country_stats cs
		ON hs.country = cs.country
WHERE	hs.country IS NULL;

-- Practical way to determine the unique entries in LEFT/RIGHT table

SELECT	DISTINCT hs.country
FROM	happiness_scores hs
		LEFT JOIN country_stats cs
		ON hs.country = cs.country
WHERE	cs.country IS NULL;

SELECT	DISTINCT cs.country
FROM	happiness_scores hs
		RIGHT JOIN country_stats cs
		ON hs.country = cs.country
WHERE	hs.country IS NULL;

-- FULL OUTER returns ALL records from BOTH tables, including non-matching records
        
-- 3. Joining on multiple columns
SELECT * FROM happiness_scores;
SELECT * FROM inflation_rates;

SELECT	hs.year, hs.country, ir.inflation_rate
FROM	happiness_scores as hs
		INNER JOIN inflation_rates as ir
        ON hs.year = ir.year AND hs.country = ir.country_name;	 
        
-- 4. Joining multiple tables
SELECT * FROM happiness_scores;
SELECT * FROM country_stats;
SELECT * FROM inflation_rates;

SELECT 	hs.year, hs.country, hs.happiness_score,
		cs.continent, cs.population, ir.inflation_rate
FROM 	happiness_scores as hs
		LEFT JOIN country_stats as cs
        ON hs.country = cs.country
        LEFT JOIN inflation_rates ir
        ON hs.year = ir.year AND hs.country = ir.country_name;

-- 5. Self joins
CREATE TABLE IF NOT EXISTS employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    salary INT,
    manager_id INT
);

INSERT INTO employees (employee_id, employee_name, salary, manager_id) VALUES
	(1, 'Ava', 85000, NULL),
	(2, 'Bob', 72000, 1),
	(3, 'Cat', 59000, 1),
	(4, 'Dan', 85000, 2);
    
SELECT * FROM employees;

-- Employees with the same salary
SELECT	e1.employee_name, e1.salary,
		e2.employee_name, e2.salary
FROM	employees e1 INNER JOIN employees e2
		ON e1.salary = e2.salary
WHERE 	e1.employee_id > e2.employee_id;

-- Employees that have a greater salary
-- JOIN Conditions can be changed
SELECT	e1.employee_name, e1.salary,
		e2.employee_name, e2.salary
FROM	employees e1 INNER JOIN employees e2
		ON e1.salary > e2.salary 
ORDER BY e1.employee_id;

-- Employees and their managers
SELECT	e1.employee_id, e1.employee_name, e1.manager_id,
		e2.employee_name AS manager_name
FROM	employees e1 LEFT JOIN employees e2
		ON e1.manager_id = e2.employee_id;
	
-- 6. Cross joins
CREATE TABLE tops (
    id INT,
    item VARCHAR(50)
);

CREATE TABLE sizes (
    id INT,
    size VARCHAR(50)
);

CREATE TABLE outerwear (
    id INT,
    item VARCHAR(50)
);

INSERT INTO tops (id, item) VALUES
	(1, 'T-Shirt'),
	(2, 'Hoodie');

INSERT INTO sizes (id, size) VALUES
	(101, 'Small'),
	(102, 'Medium'),
	(103, 'Large');

INSERT INTO outerwear (id, item) VALUES
	(2, 'Hoodie'),
	(3, 'Jacket'),
	(4, 'Coat');
    
-- View the tables
SELECT * FROM tops;
SELECT * FROM sizes;
SELECT * FROM outerwear;

-- Cross join the tables
SELECT	*
FROM tops CROSS JOIN sizes;

-- From the self join assignment:
-- Which products are within 25 cents of each other in terms of unit price?
SELECT	p1.product_name, p1.unit_price,
		p2.product_name, p2.unit_price,
        p1.unit_price - p2.unit_price AS price_diff
FROM	products p1 INNER JOIN products p2
		ON p1.product_id <> p2.product_id
WHERE 	ABS(p1.unit_price - p2.unit_price) < 0.25
		AND p1.product_name < p2.product_name
ORDER BY price_diff DESC;
        
-- Rewritten with a CROSS JOIN
SELECT	p1.product_name, p1.unit_price,
		p2.product_name, p2.unit_price,
        p1.unit_price - p2.unit_price AS price_diff
FROM	products p1 CROSS JOIN products p2
WHERE 	ABS(p1.unit_price - p2.unit_price) < 0.25
		AND p1.product_name < p2.product_name
ORDER BY price_diff DESC;

-- 7. Union vs union all
SELECT * FROM tops;
SELECT * FROM outerwear;

-- Union
SELECT * FROM tops
UNION
SELECT * FROM outerwear;

-- Union all
SELECT * FROM tops
UNION ALL
SELECT * FROM outerwear;

-- Union with different column names
SELECT * FROM happiness_scores;
SELECT * FROM happiness_scores_current;

SELECT year, country, happiness_score FROM happiness_scores
UNION ALL
SELECT 2024, country, ladder_score FROM happiness_scores_current;