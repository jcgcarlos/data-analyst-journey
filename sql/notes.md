# My SQL Learning Log

A running journal of what I'm working through, what's clicking, and what I still need to sit with.
This isn't a textbook — it's just me tracking my own progress honestly.

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
