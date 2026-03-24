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

---
