/* A Recursive CTE is a CTE that calls itself.
   It loops through data where each round builds on the output of the previous one
   until a stopping condition tells it to stop.
   
   It has two parts connected by UNION ALL:
   - Anchor     : the starting point, runs once
   - Recursive  : references the CTE itself, runs until the WHERE condition is false
*/

-- Syntax:
-- WITH RECURSIVE cte_name AS (
--     SELECT ...              <- Anchor
--     UNION ALL
--     SELECT ...              <- Recursive part
--     FROM cte_name
--     WHERE <stopping condition>
-- )
-- SELECT * FROM cte_name;

-- Notes:
-- UNION ALL is required — UNION breaks recursion logic by removing duplicates
-- Always have a stopping condition — MySQL will kill the query at 1,000 iterations without one
-- Don't name columns after reserved words (day, date, year) — use report_date, dt, period instead
-- Cast date strings explicitly: CAST('2024-01-01' AS DATE) — don't rely on implicit conversion
-- Every column should have a reason to exist — if it doesn't serve the output, cut it


-- Exercise 1 
-- No database needed

/* Generate a sequence of numbers from 1 to 10.
   The anchor gives you 1. The recursive part adds 1 each round.
   Output column: n */

WITH RECURSIVE numbers AS (
    SELECT 1 AS n
    
    UNION ALL
    
    SELECT n + 1
    FROM numbers
    WHERE n < 10
)

SELECT * FROM numbers;


-- Exercise 2 — Medium

/* Business Scenario: The finance team needs a full calendar for January 2024
   to build a daily transaction trend report. Some days have no transactions,
   so you can't pull dates from the transactions table alone.
   Generate every date from 2024-01-01 to 2024-01-31 as a date spine.
   Output column: report_date. Type: DATE. */

-- Cast the anchor as DATE explicitly so the column type is correct downstream
WITH RECURSIVE dates AS (
    
    SELECT CAST('2024-01-01' AS DATE) AS report_date
    
    UNION ALL
    
    SELECT DATE_ADD(report_date, INTERVAL 1 DAY)
    FROM dates
    WHERE report_date < '2024-01-31'
)

SELECT * FROM dates;

-- Notes:
-- This date spine is reusable — LEFT JOIN any activity table onto it
-- and zero-activity days show up as NULL instead of disappearing from the report
-- That's what makes this actually useful in dashboards and time-series analysis