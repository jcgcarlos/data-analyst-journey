# SQL — Data Analysis Practice
This folder contains SQL exercises and business problem walkthroughs written as part of my ongoing transition into a Senior Data/Operations Analyst role.

All queries are written in **MySQL** against the `maven_advanced_sql` dataset, which includes tables for products, orders, customers, students, student grades, and global happiness scores.

Each file follows a consistent structure: a business problem statement, exploratory queries, and a final output query — reflecting how I approach real analytical problems at work.

---

## Folder Structure

```
sql/
├── README.md
├── 01-sql-basics-review.sql
├── 02-joins.sql
├── 02-joins-assignment.sql
├── 03-subqueries-select-clause.sql
├── 04-subqueries-from-clause.sql
├── 05-subqueries-where-clause.sql
```

---

## Concepts Covered

| File | Concept | Business Context |
|------|---------|-----------------|
| `01-sql-basics-review.sql` | SELECT, WHERE, GROUP BY, HAVING, CASE | Student performance reporting |
| `02-joins.sql` | INNER, LEFT, RIGHT, SELF, CROSS, UNION | Product and order reconciliation |
| `02-joins-assignment.sql` | JOIN practice | Product gap analysis, price comparison |
| `03-subqueries-select-clause.sql` | Scalar subquery in SELECT | Product price vs. average benchmarking |
| `04-subqueries-from-clause.sql` | Derived table in FROM | Grade-level GPA comparison, dept performance |
| `05-subqueries-where-clause.sql` | Subquery in WHERE clause | WHERE and HAVING clause |

---

## How I Structure Each File

Every `.sql` file in this folder follows this format:

```sql
-- ============================================
-- Concept : [e.g. Subquery — FROM Clause]
-- Dataset : maven_advanced_sql > [table(s)]
-- Goal    : [One-line summary of what the query does]
-- --------------------------------------------------------
-- Business Problem:
--   [The full question being answered, written as a
--    realistic request from a stakeholder or team.]
-- ============================================
```

Exploratory queries come first, final output last. This mirrors how I work through analytical problems — verifying the data at each step before combining everything.

---

## About This Project

I am a Business Intelligence Specialist with 3 years of experience in BPO analytics, currently upskilling toward a Senior Data Analyst role. This repository documents my structured self-study across SQL, Python, Statistics, and Looker/LookML.

**Target roles:** Senior Data Analyst, Operations Research Analyst  
**Industries:** Banking, Fintech, E-commerce (BDO, BPI, GCash, Lazada, Grab)

---

## Dataset

**Maven Advanced SQL** — a relational teaching dataset covering:
- `students` / `student_grades` — academic performance data
- `products` / `orders` / `customers` — Wonka-themed retail data
- `happiness_scores` / `country_stats` / `inflation_rates` — global economic data
- `employees` — organizational hierarchy data
