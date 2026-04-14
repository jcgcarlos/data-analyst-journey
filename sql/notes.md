# My SQL Learning Log

A running journal of what I'm working through, what's clicking, and what I still need to sit with.
This isn't a textbook — it's just me tracking my own progress honestly.

---

## March 15, 2026 — SQL Basics (The Big 6)

First proper SQL session. Went through the Big 6 — SELECT, FROM, WHERE, GROUP BY, HAVING, ORDER BY — and the biggest thing that stood out immediately is that the order you *write* them isn't the order SQL actually *executes* them.

The written vs. execution order is the mental model I'll keep coming back to. SQL runs FROM first, then WHERE, then GROUP BY, then HAVING, then SELECT, then ORDER BY. This is why you can't reference a SELECT alias in WHERE — the alias doesn't exist yet when WHERE runs. But you *can* use it in ORDER BY, because that runs last.

WHERE vs. HAVING also clicked as a real distinction, not just a technicality. WHERE filters individual rows before grouping happens. HAVING filters groups *after* GROUP BY. If your filter involves an aggregate like `AVG()`, it must go in HAVING — WHERE runs too early for that.

Two smaller ones worth locking in: `IS NULL` not `= NULL` (NULL is never "equal" to anything, not even itself), and `CASE` works like if/elif/else — only the *first* matching WHEN fires. The ELSE is the catch-all.

Next Session: JOINs

---

## March 18, 2026 — JOINs

Today was all about JOINs. I already had a rough idea of what they do from work,
but I never really understood *why* you'd pick one over another until today.

The one that finally clicked for me: a LEFT JOIN keeps everything from the left table
even if there's no match on the right. So if you want to find products that have
never been ordered, you LEFT JOIN orders onto products and then filter for
WHERE orders.product_id IS NULL. That's a clean trick I'll definitely use at work.

SELF JOINs felt weird at first — joining a table to itself sounds like a mistake —
but once I saw the employees and manager example it made sense. You're just
treating the same table as two different perspectives.

Still a bit fuzzy on when UNION vs UNION ALL matters in practice beyond
"one removes duplicates." I'll keep an eye out for a real example.

---

## March 24, 2026 — Subqueries (SELECT and FROM clause)

Two subquery patterns today. They look similar on the surface but they behave
very differently depending on where you put them.

The SELECT clause version is the simpler one. You drop a single calculation
inside the SELECT and it runs once per row — like asking "what's the school
average?" and stamping that answer next to every student. Simple, readable,
but not great for huge tables since it's technically running repeatedly.

The FROM clause version is more powerful. You write a full query inside FROM,
give it an alias, and treat it like its own temporary table. This one took me
a couple of tries to get comfortable with, but the mental model that helped was:
*build the answer to the sub-question first, then join it to the main question.*

The trickiest part was knowing when to use CROSS JOIN vs INNER JOIN inside the FROM clause.
Here's how I'm remembering it now — if the subquery returns ONE row (like a single
school-wide average), you CROSS JOIN it because you're just broadcasting that one
number to every row. If it returns MULTIPLE rows (like one average per department),
you INNER JOIN it and match on the shared column.

I also learned to stop wrapping HAVING comparisons in ROUND(). It works, but it's
doing unnecessary math on every row just to filter. Compare the raw values in HAVING,
then ROUND() only what you're displaying in SELECT.

Solved both practice problems without looking at the scaffold on the second one.
That felt good.

Next Session: Subqueries (WHERE and HAVING clause)

---

## March 26, 2026 — Subqueries (WHERE and HAVING clause)

Picked up where I left off — still subqueries, but now placing them
in WHERE and HAVING instead of SELECT and FROM. Same tool, different seat.

The WHERE clause version is about filtering rows before any grouping happens.
You're essentially asking a question first — "what's the threshold?" — and
then using that answer to decide which rows to keep. The key thing I had to
internalize: the subquery runs first, returns a value (or a list of values),
and the outer query uses that result as its filter condition. It's not magic —
it's just two questions stacked, where the inner one feeds the outer one.

The classic pattern is `WHERE column > (SELECT AVG(...) FROM ...)`.
That subquery in parentheses returns one number, and the outer WHERE compares
every row against it. Simple once you see it, but confusing when you first
encounter it because it looks like you're comparing against a query instead
of a value.

The HAVING clause version follows the same logic, but it runs *after* GROUP BY.
That's the key distinction — WHERE filters individual rows before aggregation,
HAVING filters groups after aggregation. So if you want "only show me
departments where the average salary beats the company average," you can't
use WHERE because the group averages don't exist yet at that point.
You need HAVING, and the subquery inside it computes the benchmark you're
comparing against.

The part that trips people up (myself included): forgetting which clause
runs at which stage. The mental model I'm using now —
*WHERE talks to rows, HAVING talks to groups.*
If you're filtering something that requires aggregation to compute, it goes
in HAVING. If it's a raw row-level comparison, it goes in WHERE.

One pattern worth locking in: correlated subqueries inside WHERE.
These are different from the regular ones because the inner query
*references the outer query's current row*. It re-runs for every row,
which makes it powerful but slower on big tables. Good to know it exists,
but something to use deliberately.

Also reinforced: IN vs comparison operators matter here.
Use `= (subquery)` when you're sure it returns exactly one value.
Use `IN (subquery)` when it returns a list. Mixing these up causes errors
that aren't always obvious at first glance.

Next Session: CTEs

## 2026-03-31 — SQL: CTEs (Common Table Expressions)

**Hook:** A CTE isn't a temp table. It's a named subquery that exists only for the duration of one SQL statement — and that single distinction matters in interviews.

**The concept in plain English:**
A CTE lets you name a calculation at the top of your query so the rest of the query can reference it by name. It doesn't get stored anywhere. The moment the query finishes, it's gone. You use it when a subquery would work, but you want the logic to be readable, reusable within the same statement, or both.

**Three reasons to use a CTE over a subquery:**
1. **Complexity** — logic that builds on itself is cleaner as a named block
2. **Reusability** — reference the same calculation multiple times without repeating it
3. **Readability** — someone reading your query top-to-bottom can follow the logic without mentally unrolling nested subqueries

**AHA moment:**
CTEs read like a story — top to bottom, each named block setting up the next. Subqueries read inside out — you have to find the innermost query first, understand it, then work your way outward. Both can solve the same problem. But when you hand a CTE to a stakeholder or a colleague, they can follow it. A deeply nested subquery makes people reach for a whiteboard.

The most common mistake with CTEs: putting logic inside the CTE that doesn't need to be there. A CTE should only contain what other parts of the query need to reference. If you're doing `ROUND()` inside it, you're pre-shaping display data in the wrong place — the CTE is for calculation, the `SELECT` is for presentation.

**Syntax traps:**
- Don't nest inside the CTE unless the value genuinely doesn't exist yet. If it's just `AVG(column)`, write it flat.
- `ROUND()` belongs in `SELECT`, not inside the CTE. Round at display, not at calculation — the `WHERE` filter needs full precision.
- Always alias display columns. `ROUND(avg_seat_count, 0)` as a column header is noise.
- Missing commas in `SELECT` don't always throw errors in MySQL — they silently alias the wrong column. Always double-check multi-column selects.
- `COUNT(non_id_column)` works but signals a bad habit. Always count on the actual identifier (`task_id`, `completion_id`), not a timestamp or label.

**Practice exercise recap (medium — CTE with multi-table join):**
Business problem: *Which workspaces have at least one task completion?*

Key decisions made:
- Join path: `workspaces` → `teams` → `tasks` / `task_completions`
- `tasks` and `task_completions` must join on `task_id`, not `team_id` — joining on `team_id` causes fanout (tasks incorrectly matching completions from the same team but different tasks)
- HAVING is correct for filtering on aggregated values; WHERE runs before GROUP BY so it can't see `total_completions`
- LEFT JOIN + WHERE on the joined table silently becomes an INNER JOIN — use INNER JOIN intentionally or move the filter to HAVING

**Senior patterns to remember:**
- Always surface workspace/entity *name* in output, not just ID — stakeholders don't read ID columns
- Add a derived metric like `completion_rate_pct` — raw counts tell you what happened, rates tell you what it means
- Name CTEs after what the dataset *is* (`workspace_completion_summary`), not how it's filtered (`total_completion_more_than_one`)

**Next session pointer:**
Recursive CTEs

## April 14, 2026 — Recursive CTEs

Recursive CTEs are the one CTE variant that feels like actual programming logic
inside SQL. A regular CTE runs once and hands you a result. A recursive CTE loops —
it runs the anchor once to get a starting point, then keeps running the recursive
part on its own output until the stopping condition is false.

The structure is always the same: two SELECT blocks connected by UNION ALL.
The anchor is the seed value. The recursive part references the CTE by name
and builds on what the previous round returned. The WHERE clause is your exit —
without it, MySQL hits the 1,000 iteration limit and kills the query.

The most practical use case right away: date spines. If you need every date in
January for a daily trend report, you can't pull it from the transactions table
because days with zero activity don't exist there. A recursive CTE generates
the full sequence — then you LEFT JOIN your activity data onto it so zero-days
show up as NULL instead of just disappearing from the report entirely.

**AHA moment:** UNION ALL is not optional here. UNION removes duplicates, and
since recursive CTEs build incrementally on previous output, removing duplicates
breaks the chain. The loop either stops early or behaves unpredictably. Always
UNION ALL in recursive CTEs, even if you think there won't be duplicates.

Syntax trap: don't name your output column `date`, `day`, or `year` — these are
reserved words in MySQL and will throw confusing errors. Use `report_date`, `dt`,
or `period` instead. Also cast your anchor date string explicitly:
`CAST('2024-01-01' AS DATE)` — don't rely on implicit conversion or the column
type downstream might not behave as expected.

Next Session: Window Functions — RANK & DENSE_RANK

## April 15, 2026 — Window Functions: RANK & DENSE_RANK

Honestly, half this session was debugging MySQL before a single query got written.
Server was down, fintech_analytics was gone, and we had to rebuild the whole database
from scratch using a generated seed script. Annoying detour, but the database is back
and now there's actually a seed file saved in project-vela so it never disappears again.

Lesson zero: always commit your setup scripts.

On to the actual SQL. RANK and DENSE_RANK are siblings of ROW_NUMBER — all three
rank rows, but they handle ties differently. ROW_NUMBER doesn't care about ties,
it just keeps counting (1, 2, 3). RANK acknowledges the tie but skips the next
position (1, 1, 3). DENSE_RANK acknowledges the tie and doesn't skip anything (1, 1, 2).
The difference only matters when there are tied values, but when it matters, it really matters.
Telling a stakeholder "you're ranked 3rd" when there's a gap because of a skip is the
kind of thing that starts a meeting you don't want to be in.

**AHA moment:** You can't filter on a window function result with WHERE in the same query
— not because the syntax is wrong, but because of execution order. WHERE runs before
SELECT, so the rank alias doesn't exist yet when the filter is applied. The fix is a
second CTE: compute the ranks in CTE 1, then filter in the outer SELECT where the
column finally exists. This is the standard pattern and it comes up constantly.

Two bugs worth remembering from today. First: `WHERE rank_position AND dense_rank_position IN (1,2,3)`
doesn't do what it looks like. MySQL reads `rank_position` alone as a boolean — any
non-zero number is TRUE — so that half of the condition never actually filters anything.
Write it as `WHERE rank_position <= 3` and mean it. Second: CTEs can't live inside a
subquery in MySQL. `SELECT * FROM (WITH ... )` throws a syntax error. Chain CTEs at the
top of the statement instead — it reads cleaner anyway.

Senior pattern picked up today: the named WINDOW clause. When RANK and DENSE_RANK
share the same OVER definition, define it once with `WINDOW w AS (...)` and reference
it as `OVER w`. One place to update if the partition or sort changes.

Also confirmed today that `total_spent` should always filter `WHERE status = 'completed'`.
Including failed and pending transactions inflates spend numbers silently — the query runs
fine but the output is wrong. That's the kind of mistake that gets caught in a stakeholder
review, not in testing.

Next Session: NTILE or LAG/LEAD — navigation functions.