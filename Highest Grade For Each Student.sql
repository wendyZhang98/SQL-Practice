-- Link:
-- https://leetcode.com/problems/highest-grade-for-each-student/


-- Requirement:
Table: Enrollments
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| student_id    | int     |
| course_id     | int     |
| grade         | int     |
+---------------+---------+
(student_id, course_id) is the primary key of this table.

Write a SQL query to find the highest grade with its corresponding course for each student.
In case of a tie, you should find the course with the smallest course_id.
The output must be sorted by increasing student_id.

The query result format is in the following example:

Enrollments table:
+------------+-------------------+
| student_id | course_id | grade |
+------------+-----------+-------+
| 2          | 2         | 95    |
| 2          | 3         | 95    |
| 1          | 1         | 90    |
| 1          | 2         | 99    |
| 3          | 1         | 80    |
| 3          | 2         | 75    |
| 3          | 3         | 82    |
+------------+-----------+-------+
Result table:
+------------+-------------------+
| student_id | course_id | grade |
+------------+-----------+-------+
| 1          | 2         | 99    |
| 2          | 2         | 95    |
| 3          | 3         | 82    |
+------------+-----------+-------+


-- Solution:
SELECT student_id, course_id, grade
FROM Enrollments
WHERE (student_id, grade) IN
(SELECT student_id, MAX(grade) FROM Enrollments GROUP BY student_id);


-- !!!
-- In case of a tie, you should find the course with the smallest course_id.
-- !!!
SELECT student_id,course_id,grade
FROM Enrollments
WHERE (student_id, course_id) IN
(SELECT student_id, MIN(course_id) as course_id
FROM Enrollments
WHERE (student_id, grade) IN
(SELECT student_id, MAX(grade) FROM Enrollments GROUP BY student_id)
GROUP BY student_id)
ORDER BY student_id;
-- 10.8%


-- Solution:
SELECT t.student_id, t.course_id, t.grade
FROM
	(SELECT student_id, course_id, grade,
	row_number() over (partition by student_id order by grade desc, course_id asc) as r
	FROM Enrollments) t
WHERE t.r=1
ORDER BY t.student_id ASC;


-- Ranking Functions:
-- https://docs.microsoft.com/en-us/sql/t-sql/functions/ranking-functions-transact-sql?view=sql-server-ver15
-- row_number() 1 2 3 4 5 6
-- dense_rank() 1 2 2 3 4 5
-- rank() 1 2 2 4 5 6
