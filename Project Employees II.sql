-- Link:
-- https://leetcode.com/problems/project-employees-ii/


-- Requirement:
Table: Project
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| project_id  | int     |
| employee_id | int     |
+-------------+---------+
(project_id, employee_id) is the primary key of this table.
employee_id is a foreign key to Employee table.


Table: Employee
+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| employee_id      | int     |
| name             | varchar |
| experience_years | int     |
+------------------+---------+
employee_id is the primary key of this table.


Write an SQL query that reports all the projects that have the most employees.
The query result format is in the following example:

Project table:
+-------------+-------------+
| project_id  | employee_id |
+-------------+-------------+
| 1           | 1           |
| 1           | 2           |
| 1           | 3           |
| 2           | 1           |
| 2           | 4           |
+-------------+-------------+

Employee table:
+-------------+--------+------------------+
| employee_id | name   | experience_years |
+-------------+--------+------------------+
| 1           | Khaled | 3                |
| 2           | Ali    | 2                |
| 3           | John   | 1                |
| 4           | Doe    | 2                |
+-------------+--------+------------------+

Result table:
+-------------+
| project_id  |
+-------------+
| 1           |
+-------------+
The first project has 3 employees while the second one has 2.


-- Solution:
SELECT project_id
FROM
(SELECT project_id
FROM Project
GROUP BY project_id
ORDER BY COUNT(employee_id) DESC)
LIMIT 1;
-- ⚠️Error: Every derived table must have its own alias
-- Solution to this Error:
-- https://stackoverflow.com/questions/1888779/what-is-the-error-every-derived-table-must-have-its-own-alias-in-mysql

SELECT project_id
FROM
(SELECT project_id
FROM Project
GROUP BY project_id
ORDER BY COUNT(employee_id) DESC) AS employee_count_desc
LIMIT 1;
--- ⚠️Error: Not deal with the "TIES" !!!


--- Solution：
SELECT project_id
FROM project
GROUP BY project_id
HAVING COUNT(employee_id) =
(
    SELECT count(employee_id)
    FROM project
    GROUP BY project_id
    ORDER BY count(employee_id) desc
    LIMIT 1
);
