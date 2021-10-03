--- Link：
-- https://leetcode.com/problems/project-employees-iii/


-- Requirement：
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


Write an SQL query that reports the most experienced employees in each project.
In case of a tie, report all employees with the maximum number of experience years.
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
| 3           | John   | 3                |
| 4           | Doe    | 2                |
+-------------+--------+------------------+
Result table:
+-------------+---------------+
| project_id  | employee_id   |
+-------------+---------------+
| 1           | 1             |
| 1           | 3             |
| 2           | 1             |
+-------------+---------------+
Both employees with id 1 and 3 have the most experience among the employees of the first project.
For the second project, the employee with id 1 has the most experience.



-- https://leetcode.com/problems/project-employees-iii/discuss/369363/Three-straightforward-solutions-(window-function-and-subquery)
-- Solution1:
-- Runtime: 1098 ms
select t.project_id, t.employee_id
from
    (select project_id,
    p.employee_id,
    rank() over(partition by project_id order by experience_years desc) as rank
    from Project p join Employee e
    on p.employee_id = e.employee_id) t
where t.rank = 1;


-- Solution2:
-- Runtime: 1098 ms
with employee_experience as (
    select p.project_id, p.employee_id,
    rank() over(partition by p.project_id order by experience_years desc) as rank
    from Project p join Employee e
    on p.employee_id = e.employee_id)

select project_id, employee_id
from employee_experience
where rank = 1;


-- Solution3:
-- Runtime: 278 ms
select p.project_id, p.employee_id
from Project p join Employee e
on p.employee_id = e.employee_id
where (p.project_id, e.experience_years) in (
    select a.project_id, max(b.experience_years)
    from Project a join Employee b
    on a.employee_id = b.employee_id
    group by a.project_id);








