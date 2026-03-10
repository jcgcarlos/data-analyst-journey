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

        
-- 4. Joining multiple tables


-- 5. Self joins


-- Employees with the same salary


-- Employees that have a greater salary


-- Employees and their managers

        
-- 6. Cross joins

    
-- View the tables

-- Cross join the tables


-- From the self join assignment:
-- Which products are within 25 cents of each other in terms of unit price?

        
-- Rewritten with a CROSS JOIN


-- 7. Union vs union all


-- Union


-- Union all


-- Union with different column names
