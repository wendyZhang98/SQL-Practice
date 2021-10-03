-- Link:
-- https://leetcode.com/problems/rectangles-area/


-- Requirement:
Table: Points
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| x_value       | int     |
| y_value       | int     |
+---------------+---------+
id is the primary key for this table.
Each point is represented as a 2D coordinate (x_value, y_value).


Write an SQL query to report all possible axis-aligned rectangles with non-zero area
that can be formed by any two points in the Points table.

Each row in the result should contain three columns (p1, p2, area) where:

p1 and p2 are the ids of the two points that determine the opposite corners of a rectangle.
area is the area of the rectangle and must be non-zero.
Report the query in descending order by area first, then in ascending order by p1s id if there is a tie,
then in ascending order by p2s id if there is another tie.

The query result format is in the following table:


Points table:
+----------+-------------+-------------+
| id       | x_value     | y_value     |
+----------+-------------+-------------+
| 1        | 2           | 7           |
| 2        | 4           | 8           |
| 3        | 2           | 10          |
+----------+-------------+-------------+

Result table:
+----------+-------------+-------------+
| p1       | p2          | area        |
+----------+-------------+-------------+
| 2        | 3           | 4           |
| 1        | 2           | 2           |
+----------+-------------+-------------+


The rectangle formed by p1 = 2 and p2 = 3 has an area equal to |4-2| * |8-10| = 4.
The rectangle formed by p1 = 1 and p2 = 2 has an area equal to |2-4| * |7-8| = 2.
Note that the rectangle formed by p1 = 1 and p2 = 3 is invalid because the area is 0.


-- Solution: 71%
-- https://leetcode.com/problems/rectangles-area/discuss/669444/Simple-MySQL-solution
SELECT  pt1.id as P1, pt2.id as P2,
		ABS(pt2.x_value-pt1.x_value) * ABS(pt2.y_value-pt1.y_value) as AREA
FROM Points pt1 JOIN Points pt2
ON pt1.id < pt2.id
AND pt1.x_value != pt2.x_value
AND pt2.y_value != pt1.y_value
ORDER BY AREA DESC, p1 ASC, p2 ASC;