USE fintech_analytics;

-- ============================================================
-- Concept:       FIRST_VALUE, LAST_VALUE, NTH_VALUE
-- Dataset:       fintech_analytics (Vela)
-- Goal:          Understand transaction amount spread within each user segment
-- Business Problem: The Vela risk team wants to flag outlier transactions
--                   by comparing each transaction against the highest, lowest,
--                   and 3rd highest amount in its segment.
-- ============================================================

/*
  FIRST_VALUE()  - Returns the first value in a sorted window partition
  LAST_VALUE()   - Returns the last value in a sorted window partition
  NTH_VALUE()    - Returns the value at position N in a sorted window partition

  Unlike RANK() or ROW_NUMBER() which return a position number,
  these functions return the actual column value from a target row —
  stamped on every row in the partition for easy comparison.
*/

-- Syntax skeleton:
-- FIRST_VALUE(column)    OVER (PARTITION BY ... ORDER BY ...)
-- LAST_VALUE(column)     OVER (PARTITION BY ... ORDER BY ... ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
-- NTH_VALUE(column, n)   OVER (PARTITION BY ... ORDER BY ... ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)

-- Notes:
-- LAST_VALUE and NTH_VALUE require the frame clause: ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
-- Without it, MySQL defaults to ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
-- which means LAST_VALUE only sees rows up to the current one — returning its own value most of the time
-- FIRST_VALUE does not need the frame clause — the first row is always already in scope

-- ============================================================
-- Exercise 1:
-- The Vela risk team wants to understand transaction spread within each user segment.
-- For every completed transaction, return:
--   - transaction_id, user_id, amount, user_segment
--   - segment_max_amount    : highest transaction amount in that segment
--   - segment_min_amount    : lowest transaction amount in that segment
--   - segment_3rd_highest   : 3rd highest transaction amount in that segment
-- ============================================================

/*
Output: one row per transaction, showing the transaction amount alongside
        the highest, lowest, and 3rd highest amount within its user segment
Needs:  FIRST_VALUE(amount) for max, LAST_VALUE(amount) for min,
        NTH_VALUE(amount, 3) for 3rd highest — all partitioned by user_segment
Joins:  transactions → users ON user_id (to get user_segment)
Filter: status = 'completed'
*/

SELECT  t.transaction_id,
        t.user_id,
        t.amount,
        u.user_segment,
        FIRST_VALUE(t.amount)  OVER (PARTITION BY u.user_segment ORDER BY t.amount DESC) AS segment_max_amount,
        LAST_VALUE(t.amount)   OVER (PARTITION BY u.user_segment ORDER BY t.amount DESC
                                     ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS segment_min_amount,
        NTH_VALUE(t.amount, 3) OVER (PARTITION BY u.user_segment ORDER BY t.amount DESC
                                     ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS segment_3rd_highest
FROM    transactions t
LEFT JOIN users u ON t.user_id = u.user_id
WHERE   t.status = 'completed';