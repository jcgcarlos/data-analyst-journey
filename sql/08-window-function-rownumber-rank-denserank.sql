-- ============================================================
-- Concept : Window Functions — RANK & DENSE_RANK
-- Dataset : fintech_analytics > transactions, users
-- Goal    : Rank users by total completed spend per segment;
--           surface ties and filter to top 3 per segment
-- ------------------------------------------------------------
-- Business Problem:
--   The product team wants to identify top-spending users per
--   segment. Rank users by total completed transaction amount
--   and show RANK and DENSE_RANK side by side so the team
--   can spot any tied positions.
-- ============================================================

/* Window functions perform a calculation across a set of rows
   related to the current row — without collapsing them into a
   single output row the way GROUP BY does.

   RANK()       — assigns rank; skips positions on ties (1,1,3)
   DENSE_RANK() — assigns rank; no gaps on ties (1,1,2)
   ROW_NUMBER() — always unique; ties get arbitrary order (1,2,3)

   All three use the same OVER() clause to define:
   - PARTITION BY : the group to rank within (like GROUP BY, but keeps all rows)
   - ORDER BY     : what to rank by and in which direction
*/

-- Syntax:
-- SELECT
--     col,
--     RANK()       OVER(PARTITION BY group_col ORDER BY rank_col DESC) AS rank_position,
--     DENSE_RANK() OVER(PARTITION BY group_col ORDER BY rank_col DESC) AS dense_rank_position
-- FROM table;
--
-- Named window (use when reusing the same OVER definition):
-- SELECT
--     col,
--     RANK()       OVER w AS rank_position,
--     DENSE_RANK() OVER w AS dense_rank_position
-- FROM table
-- WINDOW w AS (PARTITION BY group_col ORDER BY rank_col DESC);

-- Notes:
-- PARTITION BY splits the ranking by group — without it, ranking is global
-- Window functions run after WHERE and GROUP BY — you can't filter on their
-- result directly with WHERE because the alias doesn't exist yet at that stage
-- To filter on a window function result, wrap it in a second CTE so the
-- rank column exists before the WHERE clause runs
-- RANK skips positions after a tie (1,1,3); DENSE_RANK never skips (1,1,2)
-- Always filter completed transactions only — including failed/pending
-- distorts spend totals and misleads stakeholders

USE fintech_analytics;

-- Exercise 1
/* The product team wants to rank all users within each segment
   by their total completed transaction amount.
   Show both RANK and DENSE_RANK side by side so tied users are visible.
   Output: user_segment, user_id, total_spent, rank_position, dense_rank_position */

-- Explore
SELECT * FROM users LIMIT 10;
SELECT * FROM transactions LIMIT 10;

-- Sanity check: total completed spend per user
SELECT  user_id,
        SUM(amount) AS total_spent
FROM    transactions
WHERE   status = 'completed'
GROUP BY user_id;

-- Final output
WITH transaction_amount AS (
    SELECT  user_id,
            SUM(amount) AS total_spent
    FROM    transactions
    WHERE   status = 'completed'
    GROUP BY user_id
)
SELECT  u.user_segment,
        u.user_id,
        t.total_spent,
        RANK()       OVER w AS rank_position,
        DENSE_RANK() OVER w AS dense_rank_position
FROM    users u
        INNER JOIN transaction_amount t ON u.user_id = t.user_id
WINDOW  w AS (PARTITION BY u.user_segment ORDER BY t.total_spent DESC);

-- Exercise 2 
/* Same ask as above, but the product team only wants to see
   the top 3 users per segment — not the full ranked list.
   Output: user_segment, user_id, total_spent, rank_position, dense_rank_position */

WITH transaction_amount AS (
    SELECT  user_id,
            SUM(amount) AS total_spent
    FROM    transactions
    WHERE   status = 'completed'
    GROUP BY user_id
),
ranked AS (
    SELECT  u.user_segment,
            u.user_id,
            t.total_spent,
            RANK()       OVER w AS rank_position,
            DENSE_RANK() OVER w AS dense_rank_position
    FROM    users u
            INNER JOIN transaction_amount t ON u.user_id = t.user_id
    WINDOW  w AS (PARTITION BY u.user_segment ORDER BY t.total_spent DESC)
)
SELECT  *
FROM    ranked
WHERE   rank_position <= 3;

-- Notes:
-- Can't filter window function results with WHERE in the same query —
-- wrap in a second CTE so rank_position exists before the filter runs
-- Filter on rank_position not dense_rank_position —