USE maven_advanced_sql;

-- ============================================
-- Concept : Subquery — WHERE Clause
-- Dataset : maven_advanced_sql > products
-- Goal    : Return products priced above the overall average unit price
-- --------------------------------------------------------
-- Business Problem:
--   The GCash product team wants a list of products priced above the
--   overall average unit price. They want to flag these as "premium"
--   candidates for a loyalty rewards catalog.
-- ============================================

-- Step 1: Explore the table
SELECT * FROM products;

-- Step 2: Find the overall average unit price
SELECT AVG(unit_price)
FROM   products;

-- Step 3: Final Output — filter using subquery in WHERE
SELECT  product_id,
        product_name,
        unit_price
FROM    products
WHERE   unit_price > (SELECT AVG(unit_price) FROM products)
ORDER BY unit_price DESC;


-- ============================================
-- Concept : Subquery — HAVING Clause
-- Dataset : maven_advanced_sql > orders, products
-- Goal    : Return customers whose total spend exceeds the average customer spend
-- --------------------------------------------------------
-- Business Problem:
--   A Lazada seller analytics report is being prepped for category managers.
--   They want to know which customers have spent more than the average
--   customer's total spend — so they can be flagged for a VIP tier review.
-- ============================================

-- Step 1: Explore the tables
SELECT * FROM orders;
SELECT * FROM products;

-- Step 2: Get total spend per customer (total spend = units * unit_price)
SELECT  o.customer_id,
        SUM(p.unit_price * o.units) AS total_spend
FROM    orders o
        LEFT JOIN products p ON o.product_id = p.product_id
GROUP BY o.customer_id;

-- Step 3: Get the average total spend across all customers
--         (average of per-customer sums, not average of line items)
SELECT  AVG(per_customer_spend) AS avg_customer_spend
FROM    (
            SELECT  o.customer_id,
                    SUM(p.unit_price * o.units) AS per_customer_spend
            FROM    orders o
                    LEFT JOIN products p ON o.product_id = p.product_id
            GROUP BY o.customer_id
        ) AS customer_totals;

-- Step 4: Final Output — return VIP-tier customers using HAVING + nested subquery
SELECT  o.customer_id,
        SUM(p.unit_price * o.units) AS total_spend
FROM    orders o
        LEFT JOIN products p ON o.product_id = p.product_id
GROUP BY o.customer_id
HAVING  total_spend > (
            SELECT  AVG(per_customer_spend)
            FROM    (
                        SELECT  o.customer_id,
                                SUM(p.unit_price * o.units) AS per_customer_spend
                        FROM    orders o
                                LEFT JOIN products p ON o.product_id = p.product_id
                        GROUP BY o.customer_id
                    ) AS customer_totals
        )
ORDER BY total_spend DESC;


-- ============================================
-- Session Notes — 2026-03-26
-- ============================================
-- Subqueries in WHERE filter individual rows before grouping; subqueries in
-- HAVING filter after aggregation, making them the right tool when the filter
-- depends on a calculated value like SUM or AVG. The key confusion point today
-- was the difference between AVG of line items vs. AVG of customer totals —
-- these return different numbers, and getting the right one required wrapping
-- the per-customer SUM inside a derived table before averaging. The nested
-- subquery pattern (subquery inside a subquery inside HAVING) clicked after
-- building and testing each layer in isolation before combining them.
-- ============================================