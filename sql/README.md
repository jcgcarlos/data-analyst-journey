# SQL — Data Analysis Practice

This folder contains SQL exercises and business problem walkthroughs written as part of my structured transition into a Senior Data Analyst / Analytics Engineer role.

All queries from file `06` onward are written in **MySQL** against the `fintech_analytics` database — a synthetic fintech dataset (Project Vela) covering users, transactions, merchants, payment features, feature activations, and KYC history. Earlier files (`01–05`) use the `maven_advanced_sql` teaching dataset.

Each file follows a consistent four-part structure: header comment block, definition block, syntax skeleton, and numbered exercises with business scenarios — reflecting how I approach real analytical problems.

---

## Folder Structure

```
sql/
├── README.md
├── notes.md
├── 01-sql-basics-review.sql
├── 02-joins.sql
├── 02-joins-assignment.sql
├── 03-subqueries-select-clause.sql
├── 04-subqueries-from-clause.sql
├── 05-subqueries-where-clause.sql
├── 06-CTEs.sql
├── 07-recursive-CTE.sql
├── 08-window-function-rownumber-rank-denserank.sql
└── 09-first_value()-last_value()-nth_value().sql
```

---

## Concepts Covered

| File | Concept | Dataset | Business Context |
|------|---------|---------|-----------------|
| `01-sql-basics-review.sql` | SELECT, WHERE, GROUP BY, HAVING, ORDER BY, CASE | maven_advanced_sql | Student performance reporting |
| `02-joins.sql` | INNER, LEFT, RIGHT, SELF, CROSS, UNION | maven_advanced_sql | Product and order reconciliation |
| `02-joins-assignment.sql` | JOIN practice | maven_advanced_sql | Product gap analysis, price comparison |
| `03-subqueries-select-clause.sql` | Scalar subquery in SELECT | maven_advanced_sql | Product price vs. average benchmarking |
| `04-subqueries-from-clause.sql` | Derived table in FROM | maven_advanced_sql | Grade-level GPA comparison, dept performance |
| `05-subqueries-where-clause.sql` | Subquery in WHERE / HAVING clause | maven_advanced_sql | Filtering by aggregated conditions |
| `06-CTEs.sql` | Common Table Expressions — single and multiple CTEs | fintech_analytics | Workspace completion analysis, user segmentation |
| `07-recursive-CTE.sql` | Recursive CTEs — number sequences and date spines | fintech_analytics | Date spine generation for daily trend reports |
| `08-window-function-rownumber-rank-denserank.sql` | ROW_NUMBER, RANK, DENSE_RANK | fintech_analytics | Top-spending users per segment, tie handling |
| `09-first_value()-last_value()-nth_value().sql` | FIRST_VALUE, LAST_VALUE, NTH_VALUE | fintech_analytics | Transaction spread and outlier flagging by segment |

---

## How I Structure Each File

Every `.sql` file from `06` onward follows this four-part format:

```sql
-- ============================================================
-- Concept : [e.g. Window Functions — RANK & DENSE_RANK]
-- Dataset : fintech_analytics > [table(s)]
-- Goal    : [One-line summary of what the query does]
-- ------------------------------------------------------------
-- Business Problem:
--   [The full question being answered, written as a
--    realistic request from a stakeholder or team.]
-- ============================================================

/* Plain-language explanation of the concept before any code */

-- Syntax skeleton (commented out)

-- Notes: gotchas, rules, and patterns to remember

-- Exercise 1 / 2 / 3
/* Business scenario framing */
[query]
```

Output comment is written before each exercise — one row per what, showing what, needs what — to confirm the intended result before writing code.

---

## What's Next

| Topic | Status |
|-------|--------|
| LAG / LEAD | 🔜 Next — navigation functions, period-over-period analysis |
| Running totals + moving averages | Upcoming |
| NTILE | Upcoming |
| String manipulation (CONCAT, TRIM, REPLACE) | L1 gap — scheduled |
| Date functions (DATEDIFF, DATE_FORMAT) | L1 gap — scheduled |
| Data cleaning (COALESCE, NULLIF, CAST) | L1 gap — scheduled |
| Set operations (UNION, INTERSECT, EXCEPT) | Month 2 |

---

## About This Project

BI Specialist with 3 years of enterprise reporting experience at Telus Digital, actively transitioning into a Data Analyst and eventually Analytics Engineer role. This repository documents structured self-study across SQL, Python, and LookML.

**Target roles:** Data Analyst, Aspiring Analytics Engineer  
**Target industries:** Fintech, SaaS, e-commerce  
**Target companies:** BDO, BPI, GCash, Grab, Lazada (PH) + Australian remote roles
