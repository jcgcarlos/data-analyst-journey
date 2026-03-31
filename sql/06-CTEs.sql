USE maven_advanced_sql;

/* A common table expression (CTE) creates a named, temporary output that can
be referenced within another query */

-- Example: Return each country's happiness score 
-- for the year alongside the country's average happiness score

WITH country_hs AS (SELECT country, 							
					AVG(happiness_score) AS avg_hs_by_country	-- This is a CTE named country_hs
                    FROM	 happiness_scores
                    GROUP BY country)
                    
SELECT	hs.year, hs.country, hs.happiness_score,
		country_hs.avg_hs_by_country
FROM	happiness_scores hs
		LEFT JOIN country_hs					-- The CTE is referenced here
		ON hs.country = country_hs.country;
 
 
 -- Notes:
 -- CTE Syntax: WITH table_name AS subquery
 -- CTEs are used because of the following reasons: Readability, Reusability and Recursiveness
 -- Remember: For simple queries, subquery is readable enough and works fine
 -- CTE can be referenced multiple times
 
 -- Exercise 1
 -- Database: saas_analytics
 
 /* Business Scenario: The growth team at a SaaS company wants to identify high-value workspaces 
 — those whose total seat count is above the average across all workspaces. 
 They want to prioritize these for an upsell campaign. */
 
 USE saas_analytics;
 
 -- Explore tables:
 SELECT * FROM workspaces;
 
 -- Write the CTE to calculate the average seat across all workspaces
 /* WITH w2 AS (SELECT AVG(seat_count)
			 FROM workspaces) */

-- Write the final output
WITH avg_seats AS (
	SELECT AVG(seat_count) AS avg_seat_count 
    FROM workspaces
)

SELECT	w.workspace_id, w.name, w.seat_count,
		ROUND(a.avg_seat_count, 0) as avg_seat_count
FROM	workspaces w CROSS JOIN avg_seats a
WHERE   w.seat_count > a.avg_seat_count
ORDER BY w.seat_count DESC;

-- Exercise 2

/* You're a data analyst at a SaaS company. The product team asks: "Give me a list of workspaces along with their total tasks 
and total completions — but only show workspaces that actually have at least one completion. */

-- Explore tables
SELECT * FROM workspaces;
SELECT * FROM teams;
SELECT * FROM tasks;
SELECT * FROM task_completions; 

-- Write the subuqery that will get the total task and total completion and connect team_id to workspace_id
SELECT tm.workspace_id, COUNT(ts.created_at) AS total_task, 
	   COUNT(tc.completion_id) AS total_completions
FROM   tasks ts INNER JOIN task_completions tc
	   ON ts.task_id = tc.task_id
	   INNER JOIN teams tm
       ON tc.team_id = tm.team_id
GROUP BY tm.workspace_id
HAVING total_completions >= 1;

-- Write the query to return workspaces that have completed atleast 1 task
WITH workspace_completion_summary AS (
	SELECT tm.workspace_id, 
		   COUNT(ts.task_id) AS total_task, 
		   COUNT(tc.completion_id) AS total_completions
	FROM   tasks ts 
		   INNER JOIN task_completions tc ON ts.task_id = tc.task_id
		   INNER JOIN teams tm ON tc.team_id = tm.team_id
	       GROUP BY tm.workspace_id
		   HAVING total_completions >= 1
)

SELECT w.name AS workspace_name,
	   s.total_task,
       s.total_completions,
       ROUND(s.total_task / s.total_completions * 100, 2) AS completion_rate_pct
FROM   workspace_completion_summary s
	   INNER JOIN workspaces w ON s.workspace_id = w.workspace_id
ORDER BY completion_rate_pct DESC;
	