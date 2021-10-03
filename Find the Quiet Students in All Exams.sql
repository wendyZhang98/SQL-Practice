-- Link:
-- https://leetcode.com/problems/find-the-quiet-students-in-all-exams/


-- Requirement:
Table: Student
+---------------------+---------+
| Column Name         | Type    |
+---------------------+---------+
| student_id          | int     |
| student_name        | varchar |
+---------------------+---------+
student_id is the primary key for this table.
student_name is the name of the student.


Table: Exam
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| exam_id       | int     |
| student_id    | int     |
| score         | int     |
+---------------+---------+
(exam_id, student_id) is the primary key for this table.
Student with student_id got score points in exam with id exam_id.


A "quite" student is the one who took at least one exam and didnt score neither the high score nor the low score.

Write an SQL query to report the students (student_id, student_name) being "quiet" in ALL exams.

Dont return the student who has never taken any exam. Return the result table ordered by student_id.

The query result format is in the following example.


Student table:
+-------------+---------------+
| student_id  | student_name  |
+-------------+---------------+
| 1           | Daniel        |
| 2           | Jade          |
| 3           | Stella        |
| 4           | Jonathan      |
| 5           | Will          |
+-------------+---------------+

Exam table:
+------------+--------------+-----------+
| exam_id    | student_id   | score     |
+------------+--------------+-----------+
| 10         |     1        |    70     |
| 10         |     2        |    80     |
| 10         |     3        |    90     |
| 20         |     1        |    80     |
| 30         |     1        |    70     |
| 30         |     3        |    80     |
| 30         |     4        |    90     |
| 40         |     1        |    60     |
| 40         |     2        |    70     |
| 40         |     4        |    80     |
+------------+--------------+-----------+

Result table:
+-------------+---------------+
| student_id  | student_name  |
+-------------+---------------+
| 2           | Jade          |
+-------------+---------------+

For exam 1: Student 1 and 3 hold the lowest and high score respectively.
For exam 2: Student 1 hold both highest and lowest score.
For exam 3 and 4: Studnet 1 and 4 hold the lowest and high score respectively.
Student 2 and 5 have never got the highest or lowest in any of the exam.
Since student 5 is not taking any exam, he is excluded from the result.
So, we only return the information of Student 2.


-- Solution: ❌
SELECT s.student_id, student_name FROM
(SELECT student_id FROM Exam
WHERE (exam_id, score) IN
(SELECT exam_id, MAX(score) FROM Exam GROUP BY exam_id
UNION ALL
SELECT exam_id, MIN(score) FROM Exam GROUP BY exam_id)) i
LEFT JOIN Student s
ON s.student_id = i.student_id;


-- Solution: 92%
-- https://leetcode.com/problems/find-the-quiet-students-in-all-exams/discuss/586018/10-lines-very-simple-solution
WITH cte AS(
SELECT exam_id,
       exam.student_id,
       student_name,
       score,
       RANK() OVER(PARTITION BY exam_id ORDER BY score) rk1,
       RANK() OVER(PARTITION BY exam_id ORDER BY score DESC) rk2
FROM exam LEFT JOIN student
ON exam.student_id = student.student_id
)

SELECT DISTINCT student_id,
                student_name
FROM cte
WHERE student_id NOT IN (SELECT student_id FROM cte WHERE rk1 = 1 or rk2 = 1)
ORDER BY student_id;


-- Solution: 80%
-- https://leetcode.com/problems/find-the-quiet-students-in-all-exams/discuss/746176/Easy-to-Understand-Solution-with-Comments
WITH cte AS (SELECT exam_id, student_id,
             RANK() OVER(partition by exam_id order by score DESC) high_score,
             RANK() OVER(partition by exam_id order by score) low_score FROM Exam)

SELECT DISTINCT e.student_id, s.student_name
FROM Exam e LEFT JOIN Student s ON s.student_id = e.student_id
WHERE e.student_id NOT IN (SELECT student_id FROM cte WHERE high_score = 1 OR low_score = 1)
ORDER BY e.student_id;