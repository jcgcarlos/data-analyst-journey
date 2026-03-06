-- Connect to database (MySQL)
USE maven_advanced_sql;

-- 1. View the students table
SELECT * FROM students;

-- 2. The big 6
SELECT grade_level, AVG(gpa) AS avg_gpa 
FROM students
WHERE school_lunch = 'Yes'
GROUP BY grade_level
HAVING avg_gpa < 3.3
ORDER BY grade_level;

-- 3. Common keywords

-- DISTINCT
SELECT DISTINCT grade_level
FROM students;

-- COUNT
SELECT COUNT(student_name)
FROM students;

-- MAX and MIN
SELECT MAX(gpa), MIN(gpa)
FROM students;

-- AND
SELECT DISTINCT student_name
FROM students
WHERE gpa > 3 AND school_lunch = 'No';

-- IN
SELECT student_name
FROM students
WHERE grade_level IN (9,11,12);

-- IS NULL
SELECT student_name
FROM students
WHERE email IS NULL;

-- LIKE
SELECT email
FROM students
WHERE email LIKE '%.com';

-- ORDER BY
SELECT *
FROM students
WHERE grade_level IN (9,11,12)
ORDER BY grade_level;

-- LIMIT
SELECT *
FROM students
ORDER BY grade_level
LIMIT 5;

-- CASE statements
SELECT student_name, grade_level, gpa,
	   CASE WHEN gpa <= 2 THEN 'Needs Improvement'
			WHEN gpa > 2 AND gpa <= 3 THEN 'Achieving'
			WHEN gpa > 3 AND gpa < 4 THEN 'Excelling'
			ELSE 'Perfect' END AS Performance
FROM students;