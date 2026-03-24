-- ============================================
-- Concept : Subquery — FROM Clause (Scalar Derived Table + CROSS JOIN)
-- Dataset : maven_advanced_sql > students
-- Goal    : Compare each grade level's average GPA against the overall school average
-- --------------------------------------------------------
-- Business Problem:
--   You're preparing a grade-level performance report for the school's
--   academic committee. The committee wants to know: "For each grade level,
--   what is the average GPA — and how does each grade level compare against
--   the overall school average GPA?"
--   Show: grade_level, avg_gpa, overall_avg_gpa, and the difference.
-- ============================================


-- Step 1: Explore the table
SELECT  *
FROM    students;


-- Step 2: Get the average GPA per grade level
--         (This will be the outer query's aggregation)
SELECT  grade_level,
        AVG(gpa) AS avg_gpa
FROM    students
GROUP BY grade_level;


-- Step 3: Get the overall school average GPA
--         (This becomes the subquery — returns 1 row, 1 column)
SELECT  AVG(gpa) AS overall_avg_gpa
FROM    students;


-- Step 4: Final Output
--         CROSS JOIN broadcasts the single school average to every row
--         before GROUP BY aggregates per grade level.
SELECT  grade_level,
        ROUND(AVG(gpa), 2) AS avg_gpa,
        ROUND(school_avg.overall_avg_gpa, 2) AS overall_avg_gpa,
        ROUND(AVG(gpa) - school_avg.overall_avg_gpa, 2) AS difference
FROM    students
        CROSS JOIN (
            SELECT AVG(gpa) AS overall_avg_gpa
            FROM   students
        ) AS school_avg
GROUP BY grade_level, school_avg.overall_avg_gpa
ORDER BY grade_level;


-- Note: CROSS JOIN is appropriate here because the subquery returns exactly
--       one row (the school-wide average). Broadcasting a single scalar value
--       across all rows before aggregation is the correct pattern for this type
--       of comparison. This is different from the department avg problem where
--       the subquery returned multiple rows and required a JOIN ON condition.
