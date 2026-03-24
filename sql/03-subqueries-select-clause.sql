-- ============================================
-- Concept : Subquery — SELECT Clause (Scalar Subquery)
-- Dataset : maven_advanced_sql > products
-- Goal    : Compare each product's price against the overall average
-- --------------------------------------------------------
-- Business Problem:
--   The product team plans on evaluating product prices later this week
--   to see if any adjustments need to be made next year. Can you give
--   a list of products from most to least expensive, along with how
--   much each product differs from the average unit price?
-- ============================================


-- Step 1: List products from most to least expensive
SELECT	product_id,
		product_name,
		unit_price
FROM 	products
ORDER BY unit_price DESC;


-- Step 2: Get the overall average unit price
SELECT	AVG(unit_price) AS avg_unit_price
FROM	products;


-- Step 3: Final Output
--         Inject the average as a scalar subquery in SELECT,
--         then compute the difference per product.
SELECT	product_id,
		product_name,
		unit_price,
		ROUND((SELECT AVG(unit_price) FROM products), 2) AS avg_unit_price,
        ROUND(unit_price - (SELECT AVG(unit_price) FROM products), 2) AS diff_from_avg
FROM 	products
ORDER BY unit_price DESC;


-- Note: The scalar subquery in SELECT runs once per row.
--       For large tables, computing AVG in a FROM clause subquery
--       and joining it is more efficient. At this scale, both are fine.
