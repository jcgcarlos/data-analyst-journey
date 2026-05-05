USE fintech_analytics;

-- ============================================================
-- Concept : Window Functions — LAG & LEAD
-- Dataset : fintech_analytics > transactions, users
-- Goal    : Compare each transaction against the previous or next
--           transaction to surface trends and anomalies
-- ------------------------------------------------------------
-- Business Problem:
--   The risk and growth teams need to detect unusual shifts in
--   user transaction behavior over time. By surfacing each
--   transaction alongside its neighbor, analysts can flag
--   sudden spikes, drops, and behavioral patterns without
--   writing self-joins.
-- ============================================================

/*
  LAG(column, offset, default)  — looks backward: returns the value from N rows before the current row
  LEAD(column, offset, default) — looks forward: returns the value from N rows after the current row

  Unlike FIRST_VALUE / LAST_VALUE which pull from a fixed position in the partition,
  LAG and LEAD are relative — they always look N steps away from *wherever you currently are*.

  offset  : how many rows to look back/forward (default = 1)
  default : what to return when no neighbor row exists (default = NULL)
*/

-- Syntax:
-- SELECT
--     col,
--     LAG(col, 1, 0)  OVER (PARTITION BY group_col ORDER BY sort_col) AS prev_value,
--     LEAD(col, 1, 0) OVER (PARTITION BY group_col ORDER BY sort_col) AS next_value
-- FROM table;

-- Notes:
-- LAG/LEAD do not require a frame clause — they look at actual rows, not a sliding range
-- The first row per partition always returns NULL for LAG (no prior row exists)
-- The last row per partition always returns NULL for LEAD (no next row exists)
-- Use the default parameter (3rd argument) to replace NULL with 0 or another sentinel value
-- Always filter status = 'completed' — including failed/pending distorts behavioral analysis
-- Use COALESCE on difference columns as an alternative to the default parameter —
-- keeps prev/next values as NULL (signals no prior row) while protecting computed columns


-- ============================================================
-- Exercise 1:
-- The finance team wants to see how each user's transaction amount
-- compares to their previous transaction. For every completed
-- transaction, return: transaction_id, user_id, transaction_date,
-- amount, prev_transaction_amount, and the difference between them.
-- ============================================================

/*
Output: Multiple rows per user showing the user's current transaction amount
        and previous transaction amount for comparison
Needs:  LAG(amount) PARTITION BY user_id ORDER BY created_at
Joins:  No joins — all needed columns exist in transactions
*/

WITH prev_transaction AS (
    SELECT  transaction_id,
            user_id,
            created_at AS transaction_date,
            amount,
            LAG(amount) OVER (PARTITION BY user_id ORDER BY created_at) AS prev_transaction_amount
    FROM    transactions
    WHERE   status = 'completed'
)
SELECT  transaction_id,
        user_id,
        transaction_date,
        amount,
        prev_transaction_amount,
        COALESCE(amount - prev_transaction_amount, 0) AS amount_diff
FROM    prev_transaction;

-- Notes:
-- Stakeholder framing: Surfaces bloated transaction differences that risk managers
-- can review to flag potentially fraudulent activity