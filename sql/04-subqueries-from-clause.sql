-- ============================================
-- Concept : Subquery — FROM Clause (Derived Table)
-- Dataset : maven_advanced_sql > student_grades
-- Goal    : Identify classes that performed above their department average
-- --------------------------------------------------------
-- Business Problem:
--   You're supporting the academic team ahead of semester-end reviews.
--   A department head asks: "Which classes performed above their own
--   department's average final grade? Show me the class name, department,
--   the class average, the department average, and the difference."
-- ============================================


-- Step 1: Explore the table
SELECT 	*
FROM	student_grades;


-- Step 2: Compute each department's average final grade
--         (This becomes the subquery in Step 3)
SELECT	department,
		AVG(final_grade) AS avg_department_final_grade
FROM 	student_grades
GROUP BY department;


-- Step 3: Final Output
--         Join each class row against its department average,
--         then filter for classes that beat that average.
SELECT	t1.class_name,
		t1.department,
		ROUND(AVG(t1.final_grade), 2) AS class_avg_grade,
		ROUND(department_average.avg_department_final_grade, 2) AS dept_avg_grade,
        ROUND(AVG(t1.final_grade) - department_average.avg_department_final_grade, 2) AS difference
FROM	student_grades t1
		INNER JOIN (
			SELECT 	department,
					AVG(final_grade) AS avg_department_final_grade
			FROM 	student_grades
			GROUP BY department
        ) AS department_average
		ON t1.department = department_average.department
GROUP BY t1.class_name, t1.department, department_average.avg_department_final_grade
HAVING	AVG(t1.final_grade) > department_average.avg_department_final_grade
ORDER BY t1.department, difference DESC;

-- ============================================
-- Concept : Subquery — FROM Clause (Derived Table)
-- Dataset : maven_advanced_sql > products
-- Goal    : Return the factory, product name and number of products the factory produce 
-- --------------------------------------------------------
-- Business Problem:
-- Our inventory management team would like to review the products produced by each factory.
-- Can you give me a list of our factories, along with the names of the products they produce 
-- and the number of products they produce?
-- ============================================

-- Step 1: Explore the table
SELECT * FROM products;

-- Step 2: Count number of products
SELECT factory, COUNT(product_name) as num_products
FROM products
GROUP BY factory;

-- Step 3: Join count of number of products with the original table
SELECT pr.factory, pr.product_name, count_prod.num_products
FROM products pr 
LEFT JOIN (SELECT factory, COUNT(product_name) as num_products
FROM products
GROUP BY factory) AS count_prod ON pr.factory = count_prod.factory;

-- Step 4: Final Output
SELECT pr.factory, pr.product_name, count_prod.num_products
FROM products pr 
LEFT JOIN (SELECT factory, COUNT(product_name) as num_products
FROM products
GROUP BY factory) AS count_prod ON pr.factory = count_prod.factory
ORDER BY pr.factory;
